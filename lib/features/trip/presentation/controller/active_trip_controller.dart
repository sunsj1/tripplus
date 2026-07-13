import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/services/location_service.dart';
import 'package:journeyplus/core/telemetry/app_telemetry.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:journeyplus/features/trip/data/local_db/trip_history_box.dart';
import 'package:journeyplus/features/trip/data/local_db/trip_box.dart';
import 'package:journeyplus/features/trip/domain/models/corridor_cache.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/domain/models/trip_status.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:uuid/uuid.dart';

/// Manages the full lifecycle of the single active road trip.
///
/// All state transitions are immediately Hive-persisted so the trip
/// survives app restarts and background/foreground cycles.
///
/// P1-042 — integrates foreground location tracking via [LocationService].
/// P1-043 — builds and persists a [CorridorCache] on [prepareTrip].
class ActiveTripController extends StateNotifier<ActiveTripState> {
  ActiveTripController({required this.locationService})
      : super(_loadFromHive()) {
    // P1-042 fix: if the app was killed while a trip was active and Hive
    // restored it as [ActiveTripRunning], the location stream must be
    // restarted immediately so [lastPosition] is populated and the alert
    // engine can fire. Without this, every _evaluateNow() call bails at
    // `position == null` for the entire restored session.
    if (state is ActiveTripRunning) _startLocationTracking();
  }

  final LocationService locationService;

  /// Live position subscription — non-null while the trip is [TripStatus.active].
  StreamSubscription<Position>? _positionSub;

  /// Latest recorded position (for route deviation and display).
  Position? _lastPosition;

  Position? get lastPosition => _lastPosition;

  // ---------------------------------------------------------------------------
  // Initialisation — restore from Hive on construction
  // ---------------------------------------------------------------------------

  static ActiveTripState _loadFromHive() {
    final trip = TripBox.read();
    if (trip == null) return const ActiveTripState.idle();
    return switch (trip.status) {
      TripStatus.notStarted => ActiveTripState.ready(trip: trip),
      TripStatus.active     => ActiveTripState.running(trip: trip),
      TripStatus.paused     => ActiveTripState.paused(trip: trip),
      TripStatus.completed  => ActiveTripState.completed(trip: trip),
    };
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Creates a [Trip] from a completed [PlanResult], places it in
  /// [ActiveTripState.ready].
  ///
  /// Uses [PlanResult.vehicle] when set (per-trip override from plan analyze).
  /// Also builds and persists a [CorridorCache] for offline resilience (P1-043).
  Future<void> prepareTrip({
    required PlanResult plan,
    Vehicle? vehicle,
  }) async {
    final tripVehicle =
        plan.vehicle ?? vehicle ?? const Vehicle(type: VehicleType.petrol);
    final trip = Trip(
      id: const Uuid().v4(),
      from: plan.from,
      to: plan.to,
      vehicle: tripVehicle,
      status: TripStatus.notStarted,
      totalDistanceKm: plan.totalDistanceKm,
      drivingMinutes: plan.durationMinutes,
      etaMinutes: plan.etaMinutes,
      hasTolls: plan.hasTolls,
      tripCostEstimate: plan.fuelEstimateCost ?? plan.chargingEstimate,
      isCostCharging: plan.chargingEstimate != null,
      stationCount: plan.stations.length,
      createdAt: DateTime.now(),
    );

    // P1-043 — persist corridor cache so offline mode has route data.
    final cache = CorridorCache(
      tripId: trip.id,
      encodedPolyline: plan.encodedRoutePolyline ?? '',
      stationIds: plan.stations
          .map((s) => s.id.toString())
          .toList(),
      totalDistanceKm: plan.totalDistanceKm,
      cachedAt: DateTime.now(),
    );
    await CorridorCacheBox.save(cache);

    await _persist(trip);
    state = ActiveTripState.ready(trip: trip);
    AppTelemetry.tripPrepared(tripId: trip.id);
  }

  /// [ready] → [running]: starts location tracking, records [startedAt].
  Future<void> startTrip() async {
    final current = state.trip;
    if (current == null || current.status != TripStatus.notStarted) return;
    final updated = current.copyWith(
      status: TripStatus.active,
      startedAt: DateTime.now(),
    );
    await _persist(updated);
    state = ActiveTripState.running(trip: updated);
    _startLocationTracking(); // P1-042
    AppTelemetry.tripStarted(tripId: updated.id);
  }

  /// [running] → [paused]: suspends location tracking, records [pausedAt].
  Future<void> pauseTrip() async {
    final current = state.trip;
    if (current == null || current.status != TripStatus.active) return;
    _stopLocationTracking(); // P1-042
    final updated = current.copyWith(
      status: TripStatus.paused,
      pausedAt: DateTime.now(),
    );
    await _persist(updated);
    state = ActiveTripState.paused(trip: updated);
  }

  /// [paused] → [running]: resumes location tracking, accumulates paused time.
  Future<void> resumeTrip() async {
    final current = state.trip;
    if (current == null || current.status != TripStatus.paused) return;
    final addedMs = current.pausedAt != null
        ? DateTime.now().difference(current.pausedAt!).inMilliseconds
        : 0;
    final updated = current.copyWith(
      status: TripStatus.active,
      pausedAt: null,
      elapsedPausedMs: current.elapsedPausedMs + addedMs,
    );
    await _persist(updated);
    state = ActiveTripState.running(trip: updated);
    _startLocationTracking(); // P1-042
  }

  /// Any → [completed]: finalises the trip, persists summary.
  Future<void> endTrip() async {
    final current = state.trip;
    if (current == null) return;
    _stopLocationTracking(); // P1-042
    // Accumulate remaining paused time if we ended while paused.
    int pausedMs = current.elapsedPausedMs;
    if (current.status == TripStatus.paused && current.pausedAt != null) {
      pausedMs += DateTime.now().difference(current.pausedAt!).inMilliseconds;
    }
    final updated = current.copyWith(
      status: TripStatus.completed,
      completedAt: DateTime.now(),
      elapsedPausedMs: pausedMs,
    );
    await TripHistoryBox.append(updated);
    await _persist(updated);
    await TripBox.clear(); // active slot cleared; summary lives in history
    await CorridorCacheBox.clear();
    state = ActiveTripState.completed(trip: updated);
    AppTelemetry.tripEnded(
      tripId: updated.id,
      alertCount: updated.firedAlerts.length,
    );
  }

  /// Appends a fired [alert] to the active trip log (deduped by [AlertType]).
  Future<void> recordFiredAlert(Alert alert) async {
    final current = state.trip;
    if (current == null) return;
    if (current.firedAlerts.any((a) => a.type == alert.type)) return;

    final updated = current.copyWith(
      firedAlerts: [...current.firedAlerts, alert],
    );
    await _persist(updated);
    state = switch (state) {
      ActiveTripReady() => ActiveTripState.ready(trip: updated),
      ActiveTripRunning() => ActiveTripState.running(trip: updated),
      ActiveTripPaused() => ActiveTripState.paused(trip: updated),
      ActiveTripCompleted() => ActiveTripState.completed(trip: updated),
      ActiveTripIdle() => const ActiveTripState.idle(),
    };
  }

  /// Clears the completed-trip banner and returns to [idle].
  Future<void> dismissCompleted() async {
    await TripBox.clear();
    state = const ActiveTripState.idle();
  }

  // ---------------------------------------------------------------------------
  // P1-042 — Location helpers
  // ---------------------------------------------------------------------------

  void _startLocationTracking() {
    _positionSub?.cancel();
    _positionSub = locationService.listenToPosition(
      (pos) => _lastPosition = pos,
      onError: (_) {}, // silent — UI shows offline banner instead
    );
  }

  void _stopLocationTracking() {
    _positionSub?.cancel();
    _positionSub = null;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _persist(Trip trip) => TripBox.save(trip);
}
