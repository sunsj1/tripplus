import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/services/directions_service.dart';
import 'package:tripplus/core/telemetry/app_telemetry.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/alerts/domain/alert_engine.dart';
import 'package:tripplus/features/alerts/domain/alert_engine_input.dart';
import 'package:tripplus/features/alerts/domain/alert_notifier_state.dart';
import 'package:tripplus/features/alerts/presentation/controller/alerts_providers.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:tripplus/features/pois/presentation/controller/pois_providers.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_providers.dart';
import 'package:tripplus/features/settings/domain/app_settings.dart';
import 'package:tripplus/features/settings/presentation/controller/settings_controller.dart';
import 'package:tripplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:tripplus/features/trip/domain/models/trip.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:tripplus/features/trip/presentation/controller/trip_providers.dart';
import 'package:tripplus/features/weather/domain/route_weather_segment.dart';
import 'package:tripplus/features/weather/presentation/controller/weather_providers.dart';

/// Polls location + [AlertEngine] while a trip is active; fires local
/// notifications and drives the in-app banner.
///
/// P2-006 — Per-type cooldown replaces the Phase 1 "fire once per trip"
/// permanent deduplication. The same alert type can re-fire after
/// [_cooldown] has elapsed, allowing e.g. a second fuel-low warning if the
/// driver ignored the first one and is now in a worse situation.
class AlertNotifierController extends StateNotifier<AlertNotifierState> {
  AlertNotifierController(this._ref) : super(const AlertNotifierState());

  /// P2-006 — Minimum gap between two firings of the same alert type.
  static const _cooldown = Duration(minutes: 20);

  final Ref _ref;
  Timer? _pollTimer;
  RouteInfo? _route;
  Map<PoiCategory, List<Poi>>? _pois;
  /// P2-005 — Per-segment weather, fetched once per trip.
  List<RouteWeatherSegment>? _weather;
  DateTime? _weatherFetchedAt;
  bool _evaluating = false;

  /// P2-006 — Tracks when each [AlertType] last fired in this session.
  final Map<AlertType, DateTime> _lastFiredAt = {};

  void onTripStateChanged(ActiveTripState tripState) {
    if (tripState is ActiveTripIdle || tripState is ActiveTripCompleted) {
      _route = null;
      _pois = null;
      _weather = null;
      _weatherFetchedAt = null;
      _lastFiredAt.clear(); // P2-006 — reset cooldowns for next trip
      state = const AlertNotifierState();
    }

    if (tripState is ActiveTripRunning) {
      unawaited(_requestNotificationPermission());
    }
  }

  void startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _evaluateNow(),
    );
    unawaited(_evaluateNow());
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void dismissBanner() {
    final alert = state.activeBanner;
    if (alert != null) {
      AppTelemetry.alertBannerDismissed(type: alert.type);
    }
    state = state.copyWith(bannerDismissed: true);
  }

  Future<void> _requestNotificationPermission() async {
    await _ref.read(localNotificationServiceProvider).requestPermissions();
  }

  Future<void> _evaluateNow() async {
    if (_evaluating) return;
    final tripState = _ref.read(activeTripControllerProvider);
    final trip = tripState.trip;
    if (trip == null || tripState is! ActiveTripRunning) return;

    final position = _ref.read(activeTripControllerProvider.notifier).lastPosition;
    if (position == null) return;

    _evaluating = true;
    try {
      final route = await _ensureRoute(trip);
      if (route == null) return;

      final pois = await _ensurePois(trip, route);
      final weather = await _ensureWeather(trip, route);
      final profile = _ref.read(profileControllerProvider).data;

      final engine = _ref.read(alertEngineProvider);
      final alerts = engine.evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: LatLng(position.latitude, position.longitude),
          vehicle: trip.vehicle,
          preferences: profile.preferences,
          upcomingPois: pois,
          // P2-004 — continuous driving time (paused time already excluded).
          drivingDuration: trip.elapsed,
          // P2-005 — pre-fetched weather along the corridor.
          upcomingWeather: weather,
        ),
      );

      final settings = _ref.read(settingsControllerProvider);
      final now = DateTime.now();
      for (final alert in alerts) {
        // P2-053 — Honour user mute settings (master switch + per-type).
        if (settings.isMuted(alert.type)) continue;
        // P2-006 — Cooldown: skip if the same type fired within [_cooldown].
        final lastFired = _lastFiredAt[alert.type];
        if (lastFired != null && now.difference(lastFired) < _cooldown) {
          continue;
        }
        await _deliver(alert, trip, settings);
      }
    } finally {
      _evaluating = false;
    }
  }

  Future<void> _deliver(Alert alert, Trip trip, AppSettings settings) async {
    // P2-006 — Record cooldown timestamp before any async work so a rapid
    // second evaluation can't slip through before the await resolves.
    _lastFiredAt[alert.type] = DateTime.now();

    await _ref.read(activeTripControllerProvider.notifier).recordFiredAlert(alert);

    // P2-053 — Skip system notifications when the user disabled them.
    if (settings.systemNotificationsEnabled) {
      final notifications = _ref.read(localNotificationServiceProvider);
      await notifications.showTripAlert(
        notificationId: alert.type.index,
        title: alert.type.label,
        body: alert.message,
      );
    }

    AppTelemetry.alertFired(type: alert.type, severity: alert.severity);

    state = AlertNotifierState(activeBanner: alert, bannerDismissed: false);
  }

  Future<RouteInfo?> _ensureRoute(Trip trip) async {
    if (_route != null) return _route;

    final cache = CorridorCacheBox.read();
    if (cache != null &&
        cache.tripId == trip.id &&
        cache.encodedPolyline.isNotEmpty) {
      final points = PolylineDecoder.decode(cache.encodedPolyline);
      if (points.length >= 2) {
        _route = RouteInfo(
          origin: points.first,
          destination: points.last,
          distanceKm: trip.totalDistanceKm,
          durationMinutes: trip.drivingMinutes,
          polylinePoints: points,
          encodedPolyline: cache.encodedPolyline,
        );
        return _route;
      }
    }

    try {
      final geocoding = _ref.read(geocodingServiceProvider);
      final directions = _ref.read(directionsServiceProvider);
      final origin = await geocoding.geocode(trip.from);
      final destination = await geocoding.geocode(trip.to);
      _route = await directions.getRoute(origin, destination);
      return _route;
    } catch (_) {
      return null;
    }
  }

  Future<Map<PoiCategory, List<Poi>>> _ensurePois(
    Trip trip,
    RouteInfo route,
  ) async {
    if (_pois != null) return _pois!;

    final service = _ref.read(routePoiServiceProvider);
    final map = <PoiCategory, List<Poi>>{};

    final categories = <PoiCategory>[
      if (trip.vehicle.burnsFuel) PoiCategory.fuel,
      if (trip.vehicle.isElectric) PoiCategory.ev,
      PoiCategory.restaurant,
      PoiCategory.pureVeg,
      PoiCategory.hotel, // P2-003 — night rule suggests hotels as safe stops
    ];

    for (final category in categories) {
      final result = await service.findInCorridor(
        route: route,
        category: category,
      );
      map[category] = result.match((_) => <Poi>[], (pois) => pois);
    }

    _pois = map;
    return map;
  }

  /// P2-005 — Fetch weather samples along the corridor. Cache for [_weatherTtl]
  /// so polling doesn't hammer Open-Meteo every 30 seconds.
  static const _weatherTtl = Duration(minutes: 20);

  Future<List<RouteWeatherSegment>> _ensureWeather(
    Trip trip,
    RouteInfo route,
  ) async {
    final cached = _weather;
    final cachedAt = _weatherFetchedAt;
    if (cached != null &&
        cachedAt != null &&
        DateTime.now().difference(cachedAt) < _weatherTtl) {
      return cached;
    }

    try {
      final service = _ref.read(openMeteoWeatherServiceProvider);
      final fresh = await service.sampleAlongRoute(
        polylinePoints: route.polylinePoints,
        totalDistanceKm: trip.totalDistanceKm,
      );
      _weather = fresh;
      _weatherFetchedAt = DateTime.now();
      return fresh;
    } catch (_) {
      return const [];
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}

