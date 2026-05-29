import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/core/services/location_service.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:tripplus/features/trip/data/local_db/trip_box.dart';
import 'package:tripplus/features/trip/domain/models/corridor_cache.dart';
import 'package:tripplus/features/trip/domain/models/trip.dart';
import 'package:tripplus/features/trip/domain/models/trip_status.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_state.dart';
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
      : super(_loadFromHive());

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

  /// Creates a [Trip] from a completed [PlanResult] and [vehicle], places it
  /// in [ActiveTripState.ready].
  ///
  /// Also builds and persists a [CorridorCache] for offline resilience (P1-043).
  Future<void> prepareTrip({
    required PlanResult plan,
    required Vehicle vehicle,
  }) async {
    final trip = Trip(
      id: const Uuid().v4(),
      from: plan.from,
      to: plan.to,
      vehicle: vehicle,
      status: TripStatus.notStarted,
      totalDistanceKm: plan.totalDistanceKm,
      drivingMinutes: plan.durationMinutes,
      etaMinutes: plan.etaMinutes,
      tollsEstimate: plan.tollsEstimate,
      tripCostEstimate: plan.fuelEstimateCost ?? plan.chargingEstimate,
      isCostCharging: plan.chargingEstimate != null,
      stationCount: plan.stations.length,
      createdAt: DateTime.now(),
    );

    // P1-043 — persist corridor cache so offline mode has route data.
    final cache = CorridorCache(
      tripId: trip.id,
      encodedPolyline: '', // populated when DirectionsService returns polyline
      stationIds: plan.stations
          .map((s) => s.id.toString())
          .toList(),
      totalDistanceKm: plan.totalDistanceKm,
      cachedAt: DateTime.now(),
    );
    await CorridorCacheBox.save(cache);

    await _persist(trip);
    state = ActiveTripState.ready(trip: trip);
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
    await _persist(updated);
    await CorridorCacheBox.clear(); // evict cache when trip ends
    state = ActiveTripState.completed(trip: updated);
  }

  /// Clears a completed trip and returns to [idle].
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
