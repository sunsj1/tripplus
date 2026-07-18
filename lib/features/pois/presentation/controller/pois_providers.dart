import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/services/route_poi_service.dart';
import 'package:journeyplus/core/utils/corridor_ahead.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_providers.dart'
    show
        directionsServiceProvider,
        geocodingServiceProvider,
        googleDioProvider,
        planControllerProvider,
        routeStationServiceProvider;
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/pois/data/repository/google_places_poi_source.dart';
import 'package:journeyplus/features/pois/data/repository/poi_repository.dart';
import 'package:journeyplus/features/pois/presentation/controller/poi_category_controller.dart';
import 'package:journeyplus/features/pois/presentation/controller/poi_category_ui_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

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
/// Watches [tripCorridorProgressProvider] so ahead trimming updates on every
/// GPS tick without re-fetching Places.
final poiCategoryControllerProvider = StateNotifierProvider.autoDispose
    .family<PoiCategoryController, PoiCategoryUiState, PoiCategory>(
  (ref, category) {
    final planState = ref.watch(planControllerProvider);
    String? from;
    String? to;
    if (planState is PlanResult) {
      from = planState.from;
      to = planState.to;
    }

    // Read once for seed; listen below so GPS ticks re-trim without Places refetch.
    final progress = ref.read(tripCorridorProgressProvider);

    final controller = PoiCategoryController(
      category: category,
      routePoiService: ref.watch(routePoiServiceProvider),
      poiRepository: ref.watch(poiRepositoryProvider),
      planFrom: from,
      planTo: to,
      tripRunning: progress.tripRunning,
      currentPositionKm: progress.currentKm,
      waitingForGps: progress.waitingForGps,
    );

    ref.listen<TripCorridorProgress>(tripCorridorProgressProvider, (_, next) {
      controller.updateProgress(
        tripRunning: next.tripRunning,
        currentPositionKm: next.currentKm,
        waitingForGps: next.waitingForGps,
      );
    });

    return controller;
  },
);

/// Plan EV stations trimmed to ahead-of-driver when a trip is running.
///
/// Returns the full planned list when not on an active trip or when GPS is
/// unavailable (callers should not claim “ahead” in that case).
final aheadRouteStationsProvider = Provider<List<ChargingStation>>((ref) {
  final planState = ref.watch(planControllerProvider);
  if (planState is! PlanResult) return const [];

  final stations = planState.stations;
  final progress = ref.watch(tripCorridorProgressProvider);
  if (!progress.canFilterAhead) return stations;

  return CorridorAhead.filterByKm(
    stations,
    (s) => s.distanceKm,
    progress.currentKm!,
  );
});
