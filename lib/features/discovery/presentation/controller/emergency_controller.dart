import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/services/geocoding_service.dart';
import 'package:journeyplus/core/utils/corridor_ahead.dart';
import 'package:journeyplus/core/utils/failure.dart';
import 'package:journeyplus/core/utils/location_helper.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/discovery/domain/emergency_hotline.dart';
import 'package:journeyplus/features/discovery/domain/emergency_service_type.dart';
import 'package:journeyplus/features/discovery/presentation/controller/emergency_ui_state.dart';
import 'package:journeyplus/features/pois/data/repository/poi_repository.dart';
import 'package:journeyplus/features/pois/presentation/controller/poi_category_ui_state.dart';

class EmergencyController extends StateNotifier<EmergencyUiState> {
  EmergencyController({
    required PoiRepository poiRepository,
    required GeocodingService geocoding,
    required DirectionsService directions,
    required String? planFrom,
    required String? planTo,
    bool tripRunning = false,
    double? currentPositionKm,
    bool waitingForGps = false,
  })  : _poiRepository = poiRepository,
        _geocoding = geocoding,
        _directions = directions,
        _planFrom = planFrom,
        _planTo = planTo,
        _tripRunning = tripRunning,
        _currentPositionKm = currentPositionKm,
        _waitingForGps = waitingForGps,
        super(const EmergencyLoading()) {
    refresh();
  }

  final PoiRepository _poiRepository;
  final GeocodingService _geocoding;
  final DirectionsService _directions;
  final String? _planFrom;
  final String? _planTo;

  bool _tripRunning;
  double? _currentPositionKm;
  bool _waitingForGps;

  String? _contextLabel;
  List<EmergencySectionData>? _rawSections;
  bool _loadedAlongRoute = false;

  static const _corridorKm = 12.0;
  static const _nearbyKm = 20.0;

  bool get _hasPlan {
    final from = _planFrom;
    final to = _planTo;
    return from != null &&
        to != null &&
        from.isNotEmpty &&
        to.isNotEmpty;
  }

  void updateProgress({
    required bool tripRunning,
    double? currentPositionKm,
    bool waitingForGps = false,
  }) {
    _tripRunning = tripRunning;
    _currentPositionKm = currentPositionKm;
    _waitingForGps = waitingForGps;
    _emitFromCache();
  }

  Future<void> refresh() async {
    state = const EmergencyLoading();
    _rawSections = null;
    try {
      if (_hasPlan) {
        await _loadAlongRoute();
      } else {
        await _loadNearby();
      }
    } on LocationException catch (e) {
      state = EmergencyErrored(Failure.permission(e.message));
    } on GeocodingException catch (e) {
      state = EmergencyErrored(Failure.platform(e.message));
    } on DirectionsException catch (e) {
      state = EmergencyErrored(Failure.platform(e.message));
    } catch (e) {
      state = EmergencyErrored(Failure.platform(e.toString()));
    }
  }

  Future<void> _loadAlongRoute() async {
    final from = _planFrom!;
    final to = _planTo!;
    final origin = await _resolveLocation(from);
    final destination = await _geocoding.geocode(to);
    final route = await _directions.getRoute(origin, destination);
    final polyline = route.polylinePoints;
    _contextLabel = '$from → $to';
    _loadedAlongRoute = true;

    final sections = await Future.wait(
      EmergencyServiceType.values.map(
        (type) => _loadSectionAlongRoute(type, polyline),
      ),
    );
    _rawSections = sections;
    _emitFromCache();
  }

  Future<void> _loadNearby() async {
    final pos = await LocationHelper.getCurrentLocation();
    _loadedAlongRoute = false;
    _contextLabel = 'Near your current location';
    final sections = await Future.wait(
      EmergencyServiceType.values.map(
        (type) => _loadSectionNearby(
          type,
          pos.latitude,
          pos.longitude,
        ),
      ),
    );
    _rawSections = sections;
    state = EmergencyData(
      contextLabel: _contextLabel!,
      source: PoiQuerySource.nearby,
      hotlines: EmergencyHotline.indiaHotlines,
      sections: sections,
    );
  }

  void _emitFromCache() {
    final sections = _rawSections;
    final label = _contextLabel;
    if (sections == null || label == null || !_loadedAlongRoute) return;

    if (!_tripRunning) {
      state = EmergencyData(
        contextLabel: label,
        source: PoiQuerySource.alongRoute,
        hotlines: EmergencyHotline.indiaHotlines,
        sections: sections,
      );
      return;
    }

    if (_waitingForGps || _currentPositionKm == null) {
      state = EmergencyData(
        contextLabel: label,
        source: PoiQuerySource.waitingForGps,
        hotlines: EmergencyHotline.indiaHotlines,
        sections: sections,
      );
      return;
    }

    final filtered = [
      for (final section in sections)
        EmergencySectionData(
          type: section.type,
          failure: section.failure,
          pois: CorridorAhead.filterPois(section.pois, _currentPositionKm!),
        ),
    ];

    state = EmergencyData(
      contextLabel: label,
      source: PoiQuerySource.aheadOnRoute,
      hotlines: EmergencyHotline.indiaHotlines,
      sections: filtered,
    );
  }

  Future<EmergencySectionData> _loadSectionAlongRoute(
    EmergencyServiceType type,
    List<LatLng> polyline,
  ) async {
    if (type.usesKeyword) {
      final result = await _poiRepository.searchAlongRouteKeyword(
        polyline: polyline,
        keyword: type.keyword!,
        displayCategory: type.poiCategory,
        corridorWidthKm: _corridorKm,
      );
      return result.match(
        (f) => EmergencySectionData(type: type, pois: const [], failure: f),
        (pois) => EmergencySectionData(
          type: type,
          pois: _sortByRouteDistance(pois),
        ),
      );
    }

    final result = await _poiRepository.searchAlongRoute(
      polyline: polyline,
      category: type.poiCategory,
      corridorWidthKm: _corridorKm,
    );
    return result.match(
      (f) => EmergencySectionData(type: type, pois: const [], failure: f),
      (pois) => EmergencySectionData(
        type: type,
        pois: _sortByRouteDistance(pois),
      ),
    );
  }

  Future<EmergencySectionData> _loadSectionNearby(
    EmergencyServiceType type,
    double lat,
    double lng,
  ) async {
    if (type.usesKeyword) {
      final result = await _poiRepository.searchNearbyKeyword(
        latitude: lat,
        longitude: lng,
        keyword: type.keyword!,
        displayCategory: type.poiCategory,
        radiusKm: _nearbyKm,
      );
      return result.match(
        (f) => EmergencySectionData(type: type, pois: const [], failure: f),
        (pois) => EmergencySectionData(
          type: type,
          pois: _sortByDistanceFrom(pois, lat, lng),
        ),
      );
    }

    final result = await _poiRepository.searchNearby(
      latitude: lat,
      longitude: lng,
      category: type.poiCategory,
      radiusKm: _nearbyKm,
    );
    return result.match(
      (f) => EmergencySectionData(type: type, pois: const [], failure: f),
      (pois) => EmergencySectionData(
        type: type,
        pois: _sortByDistanceFrom(pois, lat, lng),
      ),
    );
  }

  Future<LatLng> _resolveLocation(String text) async {
    if (text.toLowerCase().contains('current location')) {
      final pos = await LocationHelper.getCurrentLocation();
      return LatLng(pos.latitude, pos.longitude);
    }
    return _geocoding.geocode(text);
  }

  List<Poi> _sortByRouteDistance(List<Poi> pois) {
    final sorted = [...pois];
    sorted.sort((a, b) {
      final da = a.distanceAlongRouteKm ?? double.infinity;
      final db = b.distanceAlongRouteKm ?? double.infinity;
      return da.compareTo(db);
    });
    return sorted;
  }

  List<Poi> _sortByDistanceFrom(List<Poi> pois, double lat, double lng) {
    final sorted = [...pois];
    sorted.sort((a, b) {
      final da = LocationHelper.distanceInKm(lat, lng, a.latitude, a.longitude);
      final db = LocationHelper.distanceInKm(lat, lng, b.latitude, b.longitude);
      return da.compareTo(db);
    });
    return sorted;
  }
}
