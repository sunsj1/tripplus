import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/telemetry/app_telemetry.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_delivery_gate.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';
import 'package:journeyplus/features/alerts/domain/alert_notification_payload.dart';
import 'package:journeyplus/features/alerts/domain/alert_notifier_state.dart';
import 'package:journeyplus/features/alerts/presentation/controller/alerts_providers.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:journeyplus/features/pois/presentation/controller/pois_providers.dart';
import 'package:journeyplus/features/profile/presentation/controller/profile_providers.dart';
import 'package:journeyplus/features/settings/domain/app_settings.dart';
import 'package:journeyplus/features/settings/presentation/controller/settings_controller.dart';
import 'package:journeyplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';
import 'package:journeyplus/features/weather/domain/route_weather_segment.dart';
import 'package:journeyplus/features/weather/presentation/controller/weather_providers.dart';

/// Evaluates [AlertEngine] while a trip is active; fires local notifications
/// and drives the in-app banner.
///
/// HA-030 — Position ticks are the primary trigger (debounced). A 30s timer
/// remains as a sparse fallback when GPS is quiet.
///
/// P2-006 / HA-035 — Per-type cooldown via [AlertDeliveryGate].
class AlertNotifierController extends StateNotifier<AlertNotifierState> {
  AlertNotifierController(this._ref) : super(const AlertNotifierState());

  /// Alias kept for existing tests and call sites.
  static const cooldown = AlertDeliveryGate.cooldown;

  /// Collapses rapid GPS ticks into one evaluation.
  static const positionDebounce = Duration(seconds: 5);

  final Ref _ref;
  Timer? _pollTimer;
  Timer? _positionDebounce;
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
      _lastFiredAt.clear();
      _positionDebounce?.cancel();
      _positionDebounce = null;
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
      (_) => _evaluateNow(trigger: 'timer'),
    );
    unawaited(_evaluateNow(trigger: 'start'));
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _positionDebounce?.cancel();
    _positionDebounce = null;
  }

  /// HA-030 — Called when [tripPositionProvider] publishes a new fix.
  void onPositionTick() {
    final tripState = _ref.read(activeTripControllerProvider);
    if (tripState is! ActiveTripRunning) return;

    _positionDebounce?.cancel();
    _positionDebounce = Timer(positionDebounce, () {
      unawaited(_evaluateNow(trigger: 'position'));
    });
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

  Future<void> _evaluateNow({required String trigger}) async {
    if (_evaluating) return;
    final tripState = _ref.read(activeTripControllerProvider);
    final trip = tripState.trip;
    // HA-033 — paused / idle / completed never evaluate.
    if (trip == null || tripState is! ActiveTripRunning) return;

    final position = _ref.read(tripPositionProvider);
    if (position == null) {
      AppTelemetry.alertEvalSkippedNoGps(trigger: trigger);
      return;
    }

    _evaluating = true;
    try {
      final route = await _ensureRoute(trip);
      if (route == null) {
        AppTelemetry.alertEvalSkipped(reason: 'no_route', trigger: trigger);
        return;
      }

      final pois = await _ensurePois(trip, route);
      final weather = await _ensureWeather(trip, route);
      final profile = _ref.read(profileControllerProvider).data;

      final engine = _ref.read(alertEngineProvider);
      final alerts = engine.evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: position.latLng,
          vehicle: trip.vehicle,
          preferences: profile.preferences,
          upcomingPois: pois,
          drivingDuration: trip.elapsed,
          upcomingWeather: weather,
        ),
      );

      AppTelemetry.alertEvalOk(trigger: trigger, alertCount: alerts.length);

      final settings = _ref.read(settingsControllerProvider);
      final now = DateTime.now();
      for (final alert in alerts) {
        if (!AlertDeliveryGate.shouldDeliver(
          settings: settings,
          type: alert.type,
          lastFiredAt: _lastFiredAt,
          now: now,
        )) {
          continue;
        }
        await _deliver(alert, trip, settings);
      }
    } finally {
      _evaluating = false;
    }
  }

  Future<void> _deliver(Alert alert, Trip trip, AppSettings settings) async {
    // Record cooldown before awaits so concurrent ticks cannot double-fire.
    _lastFiredAt[alert.type] = DateTime.now();

    await _ref
        .read(activeTripControllerProvider.notifier)
        .recordFiredAlert(alert);

    final inBackground =
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed;

    if (AlertDeliveryGate.shouldShowSystemNotification(settings)) {
      final notifications = _ref.read(localNotificationServiceProvider);
      final payload = AlertNotificationPayload(
        tripId: trip.id,
        alertType: alert.type,
      );
      await notifications.showTripAlert(
        notificationId: alert.type.index,
        title: alert.type.label,
        body: alert.message,
        payload: payload.encode(),
      );
      if (inBackground) {
        AppTelemetry.alertFiredBackground(
          type: alert.type,
          severity: alert.severity,
        );
      }
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
      PoiCategory.hotel,
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
    _positionDebounce?.cancel();
    super.dispose();
  }
}
