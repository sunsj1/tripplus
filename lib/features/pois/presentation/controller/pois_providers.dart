import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/services/route_poi_service.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';
import 'package:tripplus/features/alerts/domain/alert_route_utils.dart';
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
import 'package:tripplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:tripplus/features/trip/presentation/controller/trip_providers.dart';

/// Public seam for the POI feature. Bound to [GooglePlacesPoiSource].
final poiRepositoryProvider = Provider<PoiRepository>((ref) {
  return GooglePlacesPoiSource(ref.watch(googleDioProvider));
});

/// Generalized route-aware POI service.
final routePoiServiceProvider = Provider<RoutePoiService>((ref) {
  return RoutePoiService(
    poiRepository: ref.watch(poiRepositoryProvider),
    routeStationService: ref.watch(routeStationServiceProvider),
    directions: ref.watch(directionsServiceProvider),
    geocoding: ref.watch(geocodingServiceProvider),
  );
});

/// Per-category controller. AutoDispose so brief previews don't leak.
///
/// P2 edge-case: when a trip is actively running, the factory computes the
/// driver's current distance along the route (using the corridor cache polyline
/// + GPS position from [ActiveTripController.lastPosition]) and passes it to
/// [PoiCategoryController] so the list is filtered to stops *ahead* only.
///
/// All computation is synchronous — Hive reads and haversine math — so the
/// provider factory stays non-async.
final poiCategoryControllerProvider = StateNotifierProvider.autoDispose
    .family<PoiCategoryController, PoiCategoryUiState, PoiCategory>(
  (ref, category) {
    // Plan context for route-aware fetch.
    final planState = ref.read(planControllerProvider);
    String? from;
    String? to;
    if (planState is PlanResult) {
      from = planState.from;
      to = planState.to;
    }

    // P2 edge-case — compute driver's position along the route when a trip
    // is actively running.  All steps are synchronous.
    double? currentPositionKm;

    final tripState = ref.read(activeTripControllerProvider);
    if (tripState is ActiveTripRunning) {
      final lastPos =
          ref.read(activeTripControllerProvider.notifier).lastPosition;

      if (lastPos != null) {
        final cache = CorridorCacheBox.read();
        if (cache != null && cache.encodedPolyline.isNotEmpty) {
          final points = PolylineDecoder.decode(cache.encodedPolyline);
          if (points.length >= 2) {
            currentPositionKm = AlertRouteUtils.distanceAlongRoute(
              points,
              LatLng(lastPos.latitude, lastPos.longitude),
            );
          }
        }
      }
    }

    return PoiCategoryController(
      category: category,
      routePoiService: ref.watch(routePoiServiceProvider),
      poiRepository: ref.watch(poiRepositoryProvider),
      planFrom: from,
      planTo: to,
      currentPositionKm: currentPositionKm,
    );
  },
);
