import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/services/route_poi_service.dart';
import 'package:tripplus/features/pois/data/repository/google_places_poi_source.dart';
import 'package:tripplus/features/pois/data/repository/poi_repository.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_providers.dart'
    show
        directionsServiceProvider,
        geocodingServiceProvider,
        googleDioProvider,
        routeStationServiceProvider;

/// Public seam for the POI feature. Bound to [GooglePlacesPoiSource] in
/// `P1-008`. EV-only flows must go through [routePoiServiceProvider] (`P1-009`)
/// which delegates EV to the existing `GoogleEvStationService` + OCM merge.
final poiRepositoryProvider = Provider<PoiRepository>((ref) {
  return GooglePlacesPoiSource(ref.watch(googleDioProvider));
});

/// Generalized route-aware POI service. New features should consume this
/// instead of `RouteStationService` so any [PoiCategory] (incl. EV via the
/// internal adapter) is supported.
final routePoiServiceProvider = Provider<RoutePoiService>((ref) {
  return RoutePoiService(
    poiRepository: ref.watch(poiRepositoryProvider),
    routeStationService: ref.watch(routeStationServiceProvider),
    directions: ref.watch(directionsServiceProvider),
    geocoding: ref.watch(geocodingServiceProvider),
  );
});
