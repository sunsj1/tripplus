import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/services/location_service.dart';
import 'package:journeyplus/features/trip/data/local_db/trip_history_box.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_controller.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';

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
  ),
);

/// Completed trips stored on-device only (no coordinates).
final tripHistoryProvider = Provider<List<Trip>>(
  (ref) => TripHistoryBox.readAll(),
);
