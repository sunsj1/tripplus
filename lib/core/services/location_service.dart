import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Active-trip location tracking helper.
///
/// Wraps [Geolocator] with permission handling and a high-accuracy position
/// stream. The stream is consumed by [ActiveTripController] while a trip is
/// [TripStatus.active] and is cancelled on pause or end.
///
class LocationService {
  /// 25 m keeps ahead-list transitions and alert distance accurate at highway
  /// speed without requesting continuous per-metre fixes. Tracking only runs
  /// while the trip is active, limiting the battery cost.
  static const activeTripDistanceFilterMeters = 25;
  static const androidUpdateInterval = Duration(seconds: 10);

  /// Platform-tuned settings for an actively running trip.
  ///
  /// Android's foreground configuration displays the mandatory persistent
  /// tracking notification. iOS background delivery requires the matching
  /// `UIBackgroundModes/location` declaration.
  @visibleForTesting
  static LocationSettings activeTripSettings(TargetPlatform platform) {
    if (platform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: activeTripDistanceFilterMeters,
        intervalDuration: androidUpdateInterval,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'JourneyPlus trip active',
          notificationText: 'Watching your corridor for stops and alerts',
          // Geolocator posts this on its own `geolocator_channel_01`, which is
          // intentionally separate from `journeyplus_alerts`.
          notificationChannelName: 'JourneyPlus trip tracking',
          enableWakeLock: true,
          setOngoing: true,
        ),
      );
    }

    if (platform == TargetPlatform.iOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: activeTripDistanceFilterMeters,
        activityType: ActivityType.automotiveNavigation,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    }

    return const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: activeTripDistanceFilterMeters,
    );
  }

  // ---------------------------------------------------------------------------
  // Permission
  // ---------------------------------------------------------------------------

  /// Checks current permission and requests When In Use when still undecided.
  Future<LocationPermission> requestTripPermission() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return perm;
  }

  Future<bool> requestPermission() async {
    final permission = await requestTripPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// On iOS, locked-screen delivery may require promoting When In Use to
  /// Always from system Settings. Android does not use this upgrade path.
  bool hasLimitedBackgroundPermission(LocationPermission permission) {
    return defaultTargetPlatform == TargetPlatform.iOS &&
        permission == LocationPermission.whileInUse;
  }

  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

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
    return Geolocator.getPositionStream(
      locationSettings: activeTripSettings(defaultTargetPlatform),
    ).listen(onPosition, onError: onError);
  }
}

/// Singleton [LocationService] — shared across the app.
final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);
