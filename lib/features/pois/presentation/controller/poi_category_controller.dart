import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/services/route_poi_service.dart';
import 'package:tripplus/core/utils/failure.dart';
import 'package:tripplus/core/utils/location_helper.dart';
import 'package:tripplus/features/pois/data/repository/poi_repository.dart';
import 'package:tripplus/features/pois/presentation/controller/poi_category_ui_state.dart';

/// Drives the [PoiCategoryScreen] for one [PoiCategory].
///
/// Decides between two query strategies based on whether the user has an
/// active plan:
/// - Plan present → `RoutePoiService.findAlongRoute(from, to, category)`
///   (route-aware corridor search, principle: "route-aware, not nearby").
/// - No plan → fallback to `PoiRepository.searchNearby` from current location.
///
/// EV without a plan has no good answer here (the EV pipeline needs route
/// context for OCM + gap detection); we steer the user back to "plan a trip".
class PoiCategoryController extends StateNotifier<PoiCategoryUiState> {
  PoiCategoryController({
    required PoiCategory category,
    required RoutePoiService routePoiService,
    required PoiRepository poiRepository,
    required String? planFrom,
    required String? planTo,
  })  : _category = category,
        _routePoiService = routePoiService,
        _poiRepository = poiRepository,
        _planFrom = planFrom,
        _planTo = planTo,
        super(const PoiCategoryUiState.loading()) {
    refresh();
  }

  final PoiCategory _category;
  final RoutePoiService _routePoiService;
  final PoiRepository _poiRepository;
  final String? _planFrom;
  final String? _planTo;

  bool get _hasPlan =>
      _planFrom != null &&
      _planTo != null &&
      _planFrom.isNotEmpty &&
      _planTo.isNotEmpty;

  Future<void> refresh() async {
    state = const PoiCategoryUiState.loading();
    if (_hasPlan) {
      await _loadAlongRoute();
    } else if (_category == PoiCategory.ev) {
      state = const PoiCategoryUiState.empty(
        reason:
            'Plan a trip to see chargers along your route. EV discovery is corridor-aware.',
      );
    } else {
      await _loadNearby();
    }
  }

  Future<void> _loadAlongRoute() async {
    final result = await _routePoiService.findAlongRoute(
      from: _planFrom!,
      to: _planTo!,
      category: _category,
    );
    state = result.match(
      (failure) => PoiCategoryUiState.errored(failure),
      (data) => data.pois.isEmpty
          ? PoiCategoryUiState.empty(
              reason:
                  'No ${_category.label.toLowerCase()} found along this corridor.',
            )
          : PoiCategoryUiState.data(
              pois: _sortByDistance(data.pois),
              source: PoiQuerySource.alongRoute,
            ),
    );
  }

  Future<void> _loadNearby() async {
    try {
      final pos = await LocationHelper.getCurrentLocation();
      final result = await _poiRepository.searchNearby(
        latitude: pos.latitude,
        longitude: pos.longitude,
        category: _category,
      );
      state = result.match(
        (failure) => PoiCategoryUiState.errored(failure),
        (pois) => pois.isEmpty
            ? PoiCategoryUiState.empty(
                reason:
                    'Nothing in ${_category.label.toLowerCase()} within range. Try planning a trip.',
              )
            : PoiCategoryUiState.data(
                pois: _sortByDistanceFromOrigin(
                  pois,
                  pos.latitude,
                  pos.longitude,
                ),
                source: PoiQuerySource.nearby,
              ),
      );
    } on LocationException catch (e) {
      state = PoiCategoryUiState.errored(Failure.permission(e.message));
    } catch (e) {
      state = PoiCategoryUiState.errored(Failure.platform(e.toString()));
    }
  }

  List<Poi> _sortByDistance(List<Poi> pois) {
    final sorted = [...pois];
    sorted.sort((a, b) {
      final da = a.distanceAlongRouteKm ?? double.infinity;
      final db = b.distanceAlongRouteKm ?? double.infinity;
      return da.compareTo(db);
    });
    return sorted;
  }

  List<Poi> _sortByDistanceFromOrigin(List<Poi> pois, double lat, double lng) {
    final sorted = [...pois];
    sorted.sort((a, b) {
      final da = LocationHelper.distanceInKm(
          lat, lng, a.latitude, a.longitude);
      final db = LocationHelper.distanceInKm(
          lat, lng, b.latitude, b.longitude);
      return da.compareTo(db);
    });
    return sorted;
  }
}
