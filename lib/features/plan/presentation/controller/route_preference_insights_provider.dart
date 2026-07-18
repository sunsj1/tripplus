import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/utils/corridor_ahead.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/core/utils/trip_plan_copy.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';
import 'package:journeyplus/features/plan/domain/preference_corridor_insight.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/pois/presentation/controller/pois_providers.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

@immutable
class RoutePreferenceInsightsKey {
  const RoutePreferenceInsightsKey({
    required this.plan,
    required this.isEv,
    this.preferences,
  });

  final PlanResult plan;
  final bool isEv;
  final UserPreferences? preferences;

  @override
  bool operator ==(Object other) =>
      other is RoutePreferenceInsightsKey &&
      other.plan == plan &&
      other.isEv == isEv &&
      other.preferences == preferences;

  @override
  int get hashCode => Object.hash(plan, isEv, preferences);
}

RouteInfo? _routeFromPlan(PlanResult plan) {
  final encoded = plan.encodedRoutePolyline;
  if (encoded == null || encoded.isEmpty) return null;
  final points = PolylineDecoder.decode(encoded);
  if (points.length < 2) return null;
  return RouteInfo(
    origin: points.first,
    destination: points.last,
    distanceKm: plan.totalDistanceKm,
    durationMinutes: plan.durationMinutes,
    polylinePoints: points,
    encodedPolyline: encoded,
  );
}

Poi _stationToPoi(ChargingStation s) {
  return Poi(
    id: 'ev_${s.uuid ?? s.id}',
    name: s.name,
    category: PoiCategory.ev,
    latitude: s.latitude,
    longitude: s.longitude,
    address: s.address,
    source: s.dataSource == 'google' ? PoiSource.googlePlaces : PoiSource.ocm,
    rating: 0,
    reviewCount: 0,
    openNow: s.isOperational,
    photos: const [],
    distanceAlongRouteKm: s.distanceKm,
  );
}

List<Poi> _fastChargerPois(PlanResult plan) {
  return plan.stations
      .where(
        (s) => s.connections.any((c) => c.isFastCharge == true),
      )
      .map(_stationToPoi)
      .toList();
}

/// Loads POI counts per active trip preference along the planned corridor.
final routePreferenceInsightsProvider = FutureProvider.autoDispose
    .family<List<PreferenceCorridorInsight>, RoutePreferenceInsightsKey>(
  (ref, key) async {
    final prefs = key.preferences ?? const UserPreferences();
    final items = prefs.timelineItems(forEv: key.isEv);
    if (items.isEmpty) return const [];

    final route = _routeFromPlan(key.plan);
    final service = ref.read(routePoiServiceProvider);
    final progress = ref.watch(tripCorridorProgressProvider);
    const corridorKm = 5.0;

    final insights = <PreferenceCorridorInsight>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final frac = (i + 1) / (items.length + 1);
      final suggestedKm = key.plan.totalDistanceKm * frac;

      List<Poi> pois = [];
      var loaded = true;

      if (item.id == 'fast_chargers') {
        pois = _fastChargerPois(key.plan);
      } else if (item.searchCategory != null && route != null) {
        final result = await service.findInCorridor(
          route: route,
          category: item.searchCategory!,
          corridorWidthKm: corridorKm,
        );
        pois = result.match((_) {
          loaded = false;
          return <Poi>[];
        }, (list) => list);
        if (item.id == 'family') {
          final wash = await service.findInCorridor(
            route: route,
            category: PoiCategory.washroom,
            corridorWidthKm: corridorKm,
          );
          wash.match((_) {}, (extra) {
            final ids = pois.map((p) => p.id).toSet();
            for (final p in extra) {
              if (ids.add(p.id)) pois.add(p);
            }
          });
        }
      } else {
        loaded = false;
      }

      if (progress.canFilterAhead) {
        pois = CorridorAhead.filterPois(pois, progress.currentKm!);
      }

      insights.add(
        PreferenceCorridorInsight(
          item: item,
          suggestedKmFromStart: suggestedKm,
          pois: pois,
          corridorLoaded: loaded,
        ),
      );
    }
    return insights;
  },
);
