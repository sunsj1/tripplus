import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/services/route_poi_service.dart';
import 'package:tripplus/core/utils/failure.dart';
import 'package:tripplus/core/utils/location_helper.dart';
import 'package:tripplus/features/pois/data/repository/poi_repository.dart';
import 'package:tripplus/features/pois/presentation/controller/poi_category_ui_state.dart';

/// Drives the [PoiCategoryScreen] for one [PoiCategory].
///
/// Query strategy selection:
/// - Active trip running → route-aware fetch, then filtered to POIs **ahead**
///   of the driver's current GPS position ([currentPositionKm]).
/// - Plan present (no active trip) → full corridor fetch along the planned route.
/// - No plan → nearest-first radial search from current location.
/// - EV without a plan → explicit empty state (EV needs corridor context).
class PoiCategoryController extends StateNotifier<PoiCategoryUiState> {
  PoiCategoryController({
    required PoiCategory category,
    required RoutePoiService routePoiService,
    required PoiRepository poiRepository,
    required String? planFrom,
    required String? planTo,
    this.currentPositionKm,
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

  /// P2 edge-case — distance (km) along the active route where the driver
  /// currently is. When non-null and > 0, the fetched list is trimmed to only
  /// POIs ahead of this position. Null = no active trip → show full corridor.
  final double? currentPositionKm;

  /// Minimum progress (km) before "ahead" filtering activates. Below this the
  /// driver is so close to the start that showing the full list is better UX.
  static const _minProgressKmForFilter = 5.0;

  bool get _hasPlan =>
      _planFrom != null &&
      _planTo != null &&
      _planFrom.isNotEmpty &&
      _planTo.isNotEmpty;

  bool get _shouldFilterAhead =>
      currentPositionKm != null &&
      currentPositionKm! >= _minProgressKmForFilter;

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
      (data) {
        if (data.pois.isEmpty) {
          return PoiCategoryUiState.empty(
            reason:
                'No ${_category.label.toLowerCase()} found along this corridor.',
          );
        }

        final sorted = _sortByDistance(data.pois);

        // P2 edge-case — active trip is running: trim to POIs ahead of the
        // driver's current GPS position so they never see stops they've passed.
        if (_shouldFilterAhead) {
          final ahead = sorted
              .where((p) =>
                  p.distanceAlongRouteKm == null ||
                  p.distanceAlongRouteKm! > currentPositionKm!)
              .toList();

          // Fallback: if the filter leaves nothing (e.g. near destination),
          // show the full sorted list so the screen isn't empty.
          if (ahead.isNotEmpty) {
            return PoiCategoryUiState.data(
              pois: ahead,
              source: PoiQuerySource.aheadOnRoute,
            );
          }
        }

        return PoiCategoryUiState.data(
          pois: sorted,
          source: PoiQuerySource.alongRoute,
        );
      },
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
    return [...pois]
      ..sort((a, b) {
        final da = a.distanceAlongRouteKm ?? double.infinity;
        final db = b.distanceAlongRouteKm ?? double.infinity;
        return da.compareTo(db);
      });
  }

  List<Poi> _sortByDistanceFromOrigin(List<Poi> pois, double lat, double lng) {
    return [...pois]
      ..sort((a, b) {
        final da =
            LocationHelper.distanceInKm(lat, lng, a.latitude, a.longitude);
        final db =
            LocationHelper.distanceInKm(lat, lng, b.latitude, b.longitude);
        return da.compareTo(db);
      });
  }
}
