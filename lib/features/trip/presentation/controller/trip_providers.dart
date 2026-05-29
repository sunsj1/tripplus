import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_controller.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_state.dart';

/// Singleton controller for the active trip.
///
/// Restored from Hive on first access. Do NOT use autoDispose — the trip
/// must outlive individual screens and tab switches.
final activeTripControllerProvider =
    StateNotifierProvider<ActiveTripController, ActiveTripState>(
  (ref) => ActiveTripController(),
);
