import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// P1-042 — Foreground location tracking helper.
///
/// Wraps [Geolocator] with permission handling and a high-accuracy position
/// stream. The stream is consumed by [ActiveTripController] while a trip is
/// [TripStatus.active] and is cancelled on pause or end.
///
/// Android foreground-service permission is declared in AndroidManifest.xml.
/// iOS always-on tracking is unnecessary for Phase 1 — while-in-use suffices.
class LocationService {
  static const _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 50, // emit at most once per 50 m moved
  );

  // ---------------------------------------------------------------------------
  // Permission
  // ---------------------------------------------------------------------------

  /// Checks current permission status. Requests if denied (but not permanently).
  /// Returns true if [whileInUse] or [always] is granted.
  Future<bool> requestPermission() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always;
  }

  // ---------------------------------------------------------------------------
  // One-shot read
  // ---------------------------------------------------------------------------

  /// Returns the best last-known or fresh position, or null if no permission.
  Future<Position?> currentPosition() async {
    final granted = await requestPermission();
    if (!granted) return null;
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Continuous stream
  // ---------------------------------------------------------------------------

  /// Live [Position] updates while a trip is active.
  ///
  /// Callers should [cancel] the returned [StreamSubscription] when the trip
  /// is paused or ended to avoid draining battery unnecessarily.
  StreamSubscription<Position> listenToPosition(
    void Function(Position) onPosition, {
    void Function(Object)? onError,
  }) {
    return Geolocator.getPositionStream(locationSettings: _locationSettings)
        .listen(onPosition, onError: onError);
  }
}

/// Singleton [LocationService] — shared across the app.
final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);
