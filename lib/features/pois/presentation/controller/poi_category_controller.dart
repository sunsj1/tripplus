import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/services/route_poi_service.dart';
import 'package:journeyplus/core/utils/corridor_ahead.dart';
import 'package:journeyplus/core/utils/failure.dart';
import 'package:journeyplus/core/utils/location_helper.dart';
import 'package:journeyplus/features/pois/data/repository/poi_repository.dart';
import 'package:journeyplus/features/pois/presentation/controller/poi_category_ui_state.dart';

/// Drives the [PoiCategoryScreen] for one [PoiCategory].
///
/// Query strategy selection:
/// - Plan present → corridor fetch; while a trip is running, re-trimmed to
///   stops ahead of live GPS ([updateProgress]).
/// - No plan → nearest-first radial search from current location.
/// - EV without a plan → explicit empty state (EV needs corridor context).
class PoiCategoryController extends StateNotifier<PoiCategoryUiState> {
  PoiCategoryController({
    required PoiCategory category,
    required RoutePoiService routePoiService,
    required PoiRepository poiRepository,
    required String? planFrom,
    required String? planTo,
    bool tripRunning = false,
    double? currentPositionKm,
    bool waitingForGps = false,
  })  : _category = category,
        _routePoiService = routePoiService,
        _poiRepository = poiRepository,
        _planFrom = planFrom,
        _planTo = planTo,
        _tripRunning = tripRunning,
        _currentPositionKm = currentPositionKm,
        _waitingForGps = waitingForGps,
        super(const PoiCategoryUiState.loading()) {
    refresh();
  }

  final PoiCategory _category;
  final RoutePoiService _routePoiService;
  final PoiRepository _poiRepository;
  final String? _planFrom;
  final String? _planTo;

  bool _tripRunning;
  double? _currentPositionKm;
  bool _waitingForGps;

  /// Full corridor fetch result — re-filtered on each GPS progress update.
  List<Poi>? _corridorPois;

  bool get _hasPlan =>
      _planFrom != null &&
      _planTo != null &&
      _planFrom.isNotEmpty &&
      _planTo.isNotEmpty;

  /// Live GPS progress while a trip is running — does not re-hit Places.
  void updateProgress({
    required bool tripRunning,
    double? currentPositionKm,
    bool waitingForGps = false,
  }) {
    _tripRunning = tripRunning;
    _currentPositionKm = currentPositionKm;
    _waitingForGps = waitingForGps;
    _emitCorridorState();
  }

  Future<void> refresh() async {
    state = const PoiCategoryUiState.loading();
    _corridorPois = null;
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
    result.match(
      (failure) {
        state = PoiCategoryUiState.errored(failure);
      },
      (data) {
        if (data.pois.isEmpty) {
          state = PoiCategoryUiState.empty(
            reason:
                'No ${_category.label.toLowerCase()} found along this corridor.',
          );
          return;
        }
        _corridorPois = _sortByDistance(data.pois);
        _emitCorridorState();
      },
    );
  }

  void _emitCorridorState() {
    final pois = _corridorPois;
    if (pois == null) return;

    if (!_tripRunning) {
      state = PoiCategoryUiState.data(
        pois: pois,
        source: PoiQuerySource.alongRoute,
        currentPositionKm: null,
      );
      return;
    }

    if (_waitingForGps || _currentPositionKm == null) {
      state = PoiCategoryUiState.data(
        pois: pois,
        source: PoiQuerySource.waitingForGps,
        currentPositionKm: null,
      );
      return;
    }

    final ahead = CorridorAhead.filterPois(pois, _currentPositionKm!);
    if (ahead.isEmpty) {
      state = PoiCategoryUiState.empty(
        reason:
            'No more ${_category.label.toLowerCase()} ahead on this corridor.',
      );
      return;
    }

    state = PoiCategoryUiState.data(
      pois: ahead,
      source: PoiQuerySource.aheadOnRoute,
      currentPositionKm: _currentPositionKm,
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
