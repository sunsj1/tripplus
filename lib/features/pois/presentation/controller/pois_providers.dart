import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/services/route_poi_service.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_providers.dart'
    show
        directionsServiceProvider,
        geocodingServiceProvider,
        googleDioProvider,
        planControllerProvider,
        routeStationServiceProvider;
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/pois/data/repository/google_places_poi_source.dart';
import 'package:tripplus/features/pois/data/repository/poi_repository.dart';
import 'package:tripplus/features/pois/presentation/controller/poi_category_controller.dart';
import 'package:tripplus/features/pois/presentation/controller/poi_category_ui_state.dart';

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

/// Per-category controller. AutoDispose so tabs/screens that mount it for a
/// brief preview don't leak the fetched list. Reads `planControllerProvider`
/// once at creation to decide between route-aware and nearby strategies — does
/// NOT watch it, so the controller does not rebuild on every plan tick.
final poiCategoryControllerProvider = StateNotifierProvider.autoDispose
    .family<PoiCategoryController, PoiCategoryUiState, PoiCategory>(
  (ref, category) {
    final planState = ref.read(planControllerProvider);
    String? from;
    String? to;
    if (planState is PlanResult) {
      from = planState.from;
      to = planState.to;
    }
    return PoiCategoryController(
      category: category,
      routePoiService: ref.watch(routePoiServiceProvider),
      poiRepository: ref.watch(poiRepositoryProvider),
      planFrom: from,
      planTo: to,
    );
  },
);
