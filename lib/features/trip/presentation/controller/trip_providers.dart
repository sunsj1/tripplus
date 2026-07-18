import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/trip_position.dart';
import 'package:journeyplus/core/services/location_service.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';
import 'package:journeyplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:journeyplus/features/trip/data/local_db/trip_history_box.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_controller.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';

/// Latest GPS snapshot for the active trip.
///
/// This is deliberately separate from [ActiveTripState]: trip lifecycle writes
/// are persisted to Hive, while high-frequency GPS ticks are ephemeral. Any
/// alert, list, or widget that depends on location must watch this provider
/// instead of reading a field from [ActiveTripController].
final tripPositionProvider = StateProvider<TripPosition?>((ref) => null);

/// Driver progress along the cached corridor while a trip is running.
///
/// Corridor lists (POIs, EV, emergency, gems) watch this so they re-trim when
/// GPS moves without re-fetching Places.
class TripCorridorProgress {
  const TripCorridorProgress._({
    required this.tripRunning,
    required this.currentKm,
    required this.waitingForGps,
  });

  const TripCorridorProgress.inactive()
      : this._(tripRunning: false, currentKm: null, waitingForGps: false);

  const TripCorridorProgress.active({
    required double? currentKm,
    required bool waitingForGps,
  }) : this._(
          tripRunning: true,
          currentKm: currentKm,
          waitingForGps: waitingForGps,
        );

  final bool tripRunning;
  final double? currentKm;
  final bool waitingForGps;

  bool get canFilterAhead => tripRunning && currentKm != null;
}

final tripCorridorProgressProvider = Provider<TripCorridorProgress>((ref) {
  final tripState = ref.watch(activeTripControllerProvider);
  if (tripState is! ActiveTripRunning) {
    return const TripCorridorProgress.inactive();
  }

  final position = ref.watch(tripPositionProvider);
  if (position == null) {
    return const TripCorridorProgress.active(
      currentKm: null,
      waitingForGps: true,
    );
  }

  final cache = CorridorCacheBox.read();
  if (cache == null || cache.encodedPolyline.isEmpty) {
    return const TripCorridorProgress.active(
      currentKm: null,
      waitingForGps: true,
    );
  }

  final points = PolylineDecoder.decode(cache.encodedPolyline);
  final currentKm = AlertRouteUtils.currentDistanceAlongRouteKm(
    position,
    points,
  );
  if (currentKm == null) {
    return const TripCorridorProgress.active(
      currentKm: null,
      waitingForGps: true,
    );
  }

  return TripCorridorProgress.active(
    currentKm: currentKm,
    waitingForGps: false,
  );
});

/// Singleton controller for the active trip.
///
/// Restored from Hive on first access. Do NOT use autoDispose — the trip
/// must outlive individual screens and tab switches.
///
/// P1-042 — injects [LocationService] so the controller can start/stop
/// position tracking as the trip transitions between states.
final activeTripControllerProvider =
    StateNotifierProvider<ActiveTripController, ActiveTripState>(
      (ref) => ActiveTripController(
        locationService: ref.watch(locationServiceProvider),
        onPositionChanged: (position) {
          ref.read(tripPositionProvider.notifier).state = position == null
              ? null
              : TripPosition.fromGeolocator(position);
        },
      ),
    );

/// Completed trips stored on-device only (no coordinates).
final tripHistoryProvider = Provider<List<Trip>>(
  (ref) => TripHistoryBox.readAll(),
);
