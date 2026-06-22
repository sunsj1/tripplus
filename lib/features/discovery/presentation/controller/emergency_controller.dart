import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/services/geocoding_service.dart';
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
  })  : _poiRepository = poiRepository,
        _geocoding = geocoding,
        _directions = directions,
        _planFrom = planFrom,
        _planTo = planTo,
        super(const EmergencyLoading()) {
    refresh();
  }

  final PoiRepository _poiRepository;
  final GeocodingService _geocoding;
  final DirectionsService _directions;
  final String? _planFrom;
  final String? _planTo;

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

  Future<void> refresh() async {
    state = const EmergencyLoading();
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
    final contextLabel = '$from → $to';

    final sections = await Future.wait(
      EmergencyServiceType.values.map(
        (type) => _loadSectionAlongRoute(type, polyline),
      ),
    );

    state = EmergencyData(
      contextLabel: contextLabel,
      source: PoiQuerySource.alongRoute,
      hotlines: EmergencyHotline.indiaHotlines,
      sections: sections,
    );
  }

  Future<void> _loadNearby() async {
    final pos = await LocationHelper.getCurrentLocation();
    final sections = await Future.wait(
      EmergencyServiceType.values.map(
        (type) => _loadSectionNearby(
          type,
          pos.latitude,
          pos.longitude,
        ),
      ),
    );

    state = EmergencyData(
      contextLabel: 'Near your current location',
      source: PoiQuerySource.nearby,
      hotlines: EmergencyHotline.indiaHotlines,
      sections: sections,
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
