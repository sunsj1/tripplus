import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/services/directions_service.dart';
import 'package:tripplus/core/services/geocoding_service.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/core/utils/failure.dart';
import 'package:tripplus/core/utils/location_helper.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';
import 'package:tripplus/features/pois/data/repository/poi_repository.dart';

/// Result of a route-aware POI lookup: the resolved route plus a list of
/// POIs (all in the same category) along its corridor.
class RoutePoiResult {
  const RoutePoiResult({required this.route, required this.pois});
  final RouteInfo route;
  final List<Poi> pois;
}

/// Generalized route-aware POI lookup. Dispatches by [PoiCategory]:
///
/// - `PoiCategory.ev` → delegates to the existing [RouteStationService] (OCM +
///   Google EV merge, with EV-detection heuristics + gap detection) and maps
///   `ChargingStation` → `Poi` so callers see a uniform [Poi] surface.
/// - everything else → uses the source-agnostic [PoiRepository] (concretely
///   [GooglePlacesPoiSource] in `P1-008`).
///
/// This keeps the existing station screens untouched — they still consume
/// `RouteStationService` directly. New POI-based features consume this.
class RoutePoiService {
  RoutePoiService({
    required PoiRepository poiRepository,
    required RouteStationService routeStationService,
    required DirectionsService directions,
    required GeocodingService geocoding,
  })  : _poiRepository = poiRepository,
        _routeStationService = routeStationService,
        _directions = directions,
        _geocoding = geocoding;

  final PoiRepository _poiRepository;
  final RouteStationService _routeStationService;
  final DirectionsService _directions;
  final GeocodingService _geocoding;

  final _logger = Logger();

  /// One-shot: resolve the route from text, then return POIs in its corridor.
  Future<Either<Failure, RoutePoiResult>> findAlongRoute({
    required String from,
    required String to,
    required PoiCategory category,
    double corridorWidthKm = 5,
  }) async {
    if (category == PoiCategory.ev) {
      // Delegate to the EV-specialized pipeline so OCM + the EV-description
      // gate keep applying. The text→polyline path runs once inside that
      // service — we pay one extra Directions call vs. fetching pois in
      // sibling categories. Acceptable for MVP.
      final result = await _routeStationService.analyzeRoute(from: from, to: to);
      return result.when(
        success: (analysis) => right(
          RoutePoiResult(
            route: analysis.route,
            pois: analysis.stations.map(_stationToPoi).toList(),
          ),
        ),
        failure: (message) => left(Failure.platform(message)),
      );
    }

    try {
      final origin = await _resolveLocation(from);
      final destination = await _geocoding.geocode(to);
      final route = await _directions.getRoute(origin, destination);
      final poisResult = await _poiRepository.searchAlongRoute(
        polyline: route.polylinePoints,
        category: category,
        corridorWidthKm: corridorWidthKm,
      );
      return poisResult.match(
        (failure) => left(failure),
        (pois) => right(RoutePoiResult(route: route, pois: pois)),
      );
    } on GeocodingException catch (e) {
      return left(Failure.platform(e.message));
    } on DirectionsException catch (e) {
      return left(Failure.platform(e.message));
    } on LocationException catch (e) {
      return left(Failure.permission(e.message));
    } catch (e) {
      _logger.w('RoutePoiService.findAlongRoute error: $e');
      return left(Failure.platform(e.toString()));
    }
  }

  /// Skip route resolution when the caller already has a polyline (e.g. an
  /// active trip with a cached corridor). EV path is not optimized here yet —
  /// it falls through to the polyline-based PoiRepository call and will return
  /// nothing because GooglePlacesPoiSource refuses EV. Callers wanting EV in
  /// this code path should use `RouteStationService` directly.
  Future<Either<Failure, List<Poi>>> findInCorridor({
    required RouteInfo route,
    required PoiCategory category,
    double corridorWidthKm = 5,
  }) {
    return _poiRepository.searchAlongRoute(
      polyline: route.polylinePoints,
      category: category,
      corridorWidthKm: corridorWidthKm,
    );
  }

  Future<LatLng> _resolveLocation(String text) async {
    if (text.toLowerCase().contains('current location')) {
      final pos = await LocationHelper.getCurrentLocation();
      return LatLng(pos.latitude, pos.longitude);
    }
    return _geocoding.geocode(text);
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
      photos: const <String>[],
      distanceAlongRouteKm: s.distanceKm,
      attributes: <String, dynamic>{
        if (s.operatorName != null) 'operator': s.operatorName,
        if (s.usageType != null) 'usage_type': s.usageType,
        if (s.usageCost != null) 'usage_cost': s.usageCost,
        if (s.numberOfPoints != null) 'number_of_points': s.numberOfPoints,
        if (s.connections.isNotEmpty)
          'connections': s.connections
              .map((c) => {
                    'type': c.connectionType,
                    'powerKw': c.powerKw,
                    'isFast': c.isFastCharge,
                  })
              .toList(),
        'data_source': s.dataSource,
        if (s.uuid != null) 'uuid': s.uuid,
      },
    );
  }
}
