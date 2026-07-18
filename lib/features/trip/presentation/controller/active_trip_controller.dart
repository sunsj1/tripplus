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

enum TripStartOutcome {
  started,
  startedBackgroundLimited,
  locationDenied,
  locationDeniedForever,
  locationServicesDisabled,
}

/// Manages the full lifecycle of the single active road trip.
///
/// All state transitions are immediately Hive-persisted so the trip
/// survives app restarts and background/foreground cycles.
///
/// P1-042 — integrates foreground location tracking via [LocationService].
/// P1-043 — builds and persists a [CorridorCache] on [prepareTrip].
class ActiveTripController extends StateNotifier<ActiveTripState> {
  ActiveTripController({
    required this.locationService,
    required void Function(Position?) onPositionChanged,
    ActiveTripState? initialState,
  }) : _onPositionChanged = onPositionChanged,
       super(initialState ?? _loadFromHive()) {
    // A restored running trip seeds a fresh position immediately instead of
    // waiting indefinitely for the first distance-filtered stream event.
    if (state is ActiveTripRunning) _startLocationTracking();
  }

  final LocationService locationService;
  final void Function(Position?) _onPositionChanged;

  /// Live position subscription — non-null while the trip is [TripStatus.active].
  StreamSubscription<Position>? _positionSub;

  /// Compatibility getter for callers being migrated to `tripPositionProvider`.
  ///
  /// New reactive consumers must watch that provider rather than reading this
  /// field, because a plain getter cannot trigger Riverpod rebuilds.
  Position? _lastPosition;

  Position? get lastPosition => _lastPosition;

  /// Invalidates late one-shot/stream callbacks after pause, end, or restart.
  int _trackingSession = 0;

  // ---------------------------------------------------------------------------
  // Initialisation — restore from Hive on construction
  // ---------------------------------------------------------------------------

  static ActiveTripState _loadFromHive() {
    final trip = TripBox.read();
    if (trip == null) return const ActiveTripState.idle();
    return switch (trip.status) {
      TripStatus.notStarted => ActiveTripState.ready(trip: trip),
      TripStatus.active => ActiveTripState.running(trip: trip),
      TripStatus.paused => ActiveTripState.paused(trip: trip),
      TripStatus.completed => ActiveTripState.completed(trip: trip),
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
  Future<void> prepareTrip({required PlanResult plan, Vehicle? vehicle}) async {
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
      stationIds: plan.stations.map((s) => s.id.toString()).toList(),
      totalDistanceKm: plan.totalDistanceKm,
      cachedAt: DateTime.now(),
    );
    await CorridorCacheBox.save(cache);

    _publishPosition(null);
    await _persist(trip);
    state = ActiveTripState.ready(trip: trip);
    AppTelemetry.tripPrepared(tripId: trip.id);
  }

  /// [ready] → [running]: starts location tracking, records [startedAt].
  Future<TripStartOutcome> startTrip() async {
    final current = state.trip;
    if (current == null || current.status != TripStatus.notStarted) {
      return TripStartOutcome.locationDenied;
    }

    if (!await locationService.isServiceEnabled()) {
      return TripStartOutcome.locationServicesDisabled;
    }

    final permission = await locationService.requestTripPermission();
    if (permission == LocationPermission.deniedForever) {
      return TripStartOutcome.locationDeniedForever;
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return TripStartOutcome.locationDenied;
    }

    final updated = current.copyWith(
      status: TripStatus.active,
      startedAt: DateTime.now(),
    );
    await _persist(updated);
    state = ActiveTripState.running(trip: updated);
    _startLocationTracking(); // P1-042
    AppTelemetry.tripStarted(tripId: updated.id);
    return locationService.hasLimitedBackgroundPermission(permission)
        ? TripStartOutcome.startedBackgroundLimited
        : TripStartOutcome.started;
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
    _publishPosition(null);
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
    _publishPosition(null);
    state = const ActiveTripState.idle();
  }

  // ---------------------------------------------------------------------------
  // P1-042 — Location helpers
  // ---------------------------------------------------------------------------

  void _startLocationTracking() {
    _positionSub?.cancel();
    final session = ++_trackingSession;

    unawaited(_beginLocationTracking(session));
  }

  Future<void> _beginLocationTracking(int session) async {
    final permission = await locationService.requestTripPermission();
    if (session != _trackingSession || state is! ActiveTripRunning) return;
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return;
    }

    _positionSub = locationService.listenToPosition(
      (position) => _acceptPosition(position, session),
      onError: (_) {}, // silent — UI shows offline banner instead
    );

    // The stream may wait until the distance filter is crossed. Seed an
    // immediate fix so restored/new trips can evaluate alerts right away.
    unawaited(_seedCurrentPosition(session));
  }

  void _stopLocationTracking() {
    _trackingSession++;
    _positionSub?.cancel();
    _positionSub = null;
  }

  Future<void> _seedCurrentPosition(int session) async {
    final position = await locationService.currentPosition();
    if (position != null) _acceptPosition(position, session);
  }

  void _acceptPosition(Position position, int session) {
    if (session != _trackingSession || state is! ActiveTripRunning) return;

    // A slow one-shot lookup must not overwrite a newer stream fix.
    final previous = _lastPosition;
    if (previous != null && position.timestamp.isBefore(previous.timestamp)) {
      return;
    }
    _publishPosition(position);
  }

  void _publishPosition(Position? position) {
    _lastPosition = position;
    _onPositionChanged(position);
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _trackingSession++;
    _positionSub?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _persist(Trip trip) => TripBox.save(trip);
}
