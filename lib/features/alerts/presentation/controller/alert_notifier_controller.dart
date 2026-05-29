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
import 'package:tripplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:tripplus/features/trip/domain/models/trip.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:tripplus/features/trip/presentation/controller/trip_providers.dart';

/// Polls location + [AlertEngine] while a trip is active; fires local
/// notifications and drives the in-app banner (`P1-028`).
class AlertNotifierController extends StateNotifier<AlertNotifierState> {
  AlertNotifierController(this._ref) : super(const AlertNotifierState());

  final Ref _ref;
  Timer? _pollTimer;
  RouteInfo? _route;
  Map<PoiCategory, List<Poi>>? _pois;
  bool _evaluating = false;

  void onTripStateChanged(ActiveTripState tripState) {
    if (tripState is ActiveTripIdle || tripState is ActiveTripCompleted) {
      _route = null;
      _pois = null;
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
      final profile = _ref.read(profileControllerProvider).data;

      final engine = _ref.read(alertEngineProvider);
      final alerts = engine.evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: LatLng(position.latitude, position.longitude),
          vehicle: trip.vehicle,
          preferences: profile.preferences,
          upcomingPois: pois,
        ),
      );

      for (final alert in alerts) {
        if (trip.firedAlerts.any((a) => a.type == alert.type)) continue;
        await _deliver(alert, trip);
      }
    } finally {
      _evaluating = false;
    }
  }

  Future<void> _deliver(Alert alert, Trip trip) async {
    await _ref.read(activeTripControllerProvider.notifier).recordFiredAlert(alert);

    final notifications = _ref.read(localNotificationServiceProvider);
    await notifications.showTripAlert(
      notificationId: alert.type.index,
      title: alert.type.label,
      body: alert.message,
    );

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

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}

