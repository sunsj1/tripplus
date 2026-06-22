import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:journeyplus/core/constants/api_constants.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/utils/failure.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart' show LatLng;
import 'package:journeyplus/features/pois/data/repository/poi_repository.dart';

/// Concrete [PoiRepository] backed by Google Places (Nearby Search +
/// Place Details). EV charging is **not** served here — that path stays on the
/// existing `GoogleEvStationService` + OCM merge so the previously verified
/// EV-detection heuristics keep working.
class GooglePlacesPoiSource implements PoiRepository {
  GooglePlacesPoiSource(this._dio);

  final Dio _dio;
  final _logger = Logger();

  /// Maximum number of polyline samples we'll hit. Beyond this the route
  /// gets denser without yielding new POIs, and Places quota gets hammered.
  static const int _maxSamples = 10;

  static const String _nearbyEndpoint =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  static const String _detailsEndpoint =
      'https://maps.googleapis.com/maps/api/place/details/json';

  @override
  Future<Either<Failure, List<Poi>>> searchAlongRoute({
    required List<LatLng> polyline,
    required PoiCategory category,
    double corridorWidthKm = 5,
  }) async {
    if (category == PoiCategory.ev) {
      return left(const Failure.platform(
        'EV stations are served by GoogleEvStationService — call RoutePoiService instead.',
      ));
    }
    if (!ApiConstants.isGoogleMapsKeyConfigured) {
      return left(const Failure.permission(
        'Google Maps API key is missing — set GOOGLE_MAPS_API_KEY in .env.',
      ));
    }
    if (polyline.length < 2) {
      return left(const Failure.platform(
        'Polyline must have at least 2 points.',
      ));
    }

    final spec = _querySpec(category);
    final radiusMeters = (corridorWidthKm * 1000).clamp(500, 50000).toInt();
    final samples = _samplePolyline(polyline);

    final futures = samples.map(
      (p) => _nearbySearchOnce(
        point: p,
        radiusMeters: radiusMeters,
        spec: spec,
        category: category,
      ),
    );

    final results = await Future.wait(futures);

    // First failure wins; otherwise collect + dedupe.
    Failure? firstFailure;
    final dedup = <String, Poi>{};
    for (final r in results) {
      r.match(
        (f) => firstFailure ??= f,
        (list) {
          for (final p in list) {
            dedup.putIfAbsent(p.id, () => p);
          }
        },
      );
    }

    if (firstFailure != null && dedup.isEmpty) {
      return left(firstFailure!);
    }

    return right(dedup.values.toList());
  }

  @override
  Future<Either<Failure, List<Poi>>> searchNearby({
    required double latitude,
    required double longitude,
    required PoiCategory category,
    double radiusKm = 5,
  }) {
    if (category == PoiCategory.ev) {
      return Future.value(left(const Failure.platform(
        'EV stations are served by GoogleEvStationService — call RoutePoiService instead.',
      )));
    }
    if (!ApiConstants.isGoogleMapsKeyConfigured) {
      return Future.value(left(const Failure.permission(
        'Google Maps API key is missing — set GOOGLE_MAPS_API_KEY in .env.',
      )));
    }
    return _nearbySearchOnce(
      point: LatLng(latitude, longitude),
      radiusMeters: (radiusKm * 1000).clamp(500, 50000).toInt(),
      spec: _querySpec(category),
      category: category,
    );
  }

  @override
  Future<Either<Failure, Poi>> getById(String id) async {
    if (!ApiConstants.isGoogleMapsKeyConfigured) {
      return left(const Failure.permission(
        'Google Maps API key is missing — set GOOGLE_MAPS_API_KEY in .env.',
      ));
    }
    final placeId = id.startsWith('g_') ? id.substring(2) : id;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _detailsEndpoint,
        queryParameters: {
          'place_id': placeId,
          'fields':
              'place_id,name,formatted_address,geometry,rating,user_ratings_total,types,opening_hours,price_level,photos',
          'key': ApiConstants.googleMapsApiKey,
        },
      );
      final data = response.data;
      if (data == null) {
        return left(const Failure.platform('Place Details: empty response.'));
      }
      final failure = _failureFromStatus(data['status'] as String?);
      if (failure != null) return left(failure);
      final result = data['result'] as Map<String, dynamic>?;
      if (result == null) {
        return left(const Failure.platform('Place Details: missing result.'));
      }
      return right(_mapToPoi(result, fallbackCategory: PoiCategory.tourist));
    } on DioException catch (e) {
      return left(_failureFromDio(e));
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message ?? e.code));
    } catch (e) {
      _logger.w('Place Details unexpected error: $e');
      return left(Failure.platform(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Poi>>> searchAlongRouteKeyword({
    required List<LatLng> polyline,
    required String keyword,
    required PoiCategory displayCategory,
    double corridorWidthKm = 10,
  }) async {
    if (!ApiConstants.isGoogleMapsKeyConfigured) {
      return left(const Failure.permission(
        'Google Maps API key is missing — set GOOGLE_MAPS_API_KEY in .env.',
      ));
    }
    if (polyline.length < 2) {
      return left(const Failure.platform(
        'Polyline must have at least 2 points.',
      ));
    }

    final radiusMeters = (corridorWidthKm * 1000).clamp(500, 50000).toInt();
    final samples = _samplePolyline(polyline);
    final spec = _NearbyQuerySpec(keyword: keyword);

    final futures = samples.map(
      (p) => _nearbySearchOnce(
        point: p,
        radiusMeters: radiusMeters,
        spec: spec,
        category: displayCategory,
      ),
    );

    final results = await Future.wait(futures);
    Failure? firstFailure;
    final dedup = <String, Poi>{};
    for (final r in results) {
      r.match(
        (f) => firstFailure ??= f,
        (list) {
          for (final p in list) {
            dedup.putIfAbsent(p.id, () => p);
          }
        },
      );
    }

    if (firstFailure != null && dedup.isEmpty) {
      return left(firstFailure!);
    }
    return right(dedup.values.toList());
  }

  @override
  Future<Either<Failure, List<Poi>>> searchNearbyKeyword({
    required double latitude,
    required double longitude,
    required String keyword,
    required PoiCategory displayCategory,
    double radiusKm = 15,
  }) {
    if (!ApiConstants.isGoogleMapsKeyConfigured) {
      return Future.value(left(const Failure.permission(
        'Google Maps API key is missing — set GOOGLE_MAPS_API_KEY in .env.',
      )));
    }
    return _nearbySearchOnce(
      point: LatLng(latitude, longitude),
      radiusMeters: (radiusKm * 1000).clamp(500, 50000).toInt(),
      spec: _NearbyQuerySpec(keyword: keyword),
      category: displayCategory,
    );
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  Future<Either<Failure, List<Poi>>> _nearbySearchOnce({
    required LatLng point,
    required int radiusMeters,
    required _NearbyQuerySpec spec,
    required PoiCategory category,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _nearbyEndpoint,
        queryParameters: {
          'location': '${point.latitude},${point.longitude}',
          'radius': radiusMeters,
          if (spec.type != null) 'type': spec.type,
          if (spec.keyword != null) 'keyword': spec.keyword,
          'key': ApiConstants.googleMapsApiKey,
        },
      );
      final data = response.data;
      if (data == null) {
        return left(const Failure.platform('Places Nearby: empty response.'));
      }
      final failure = _failureFromStatus(data['status'] as String?);
      if (failure != null) return left(failure);

      final results = data['results'] as List? ?? const [];
      final pois = results
          .whereType<Map<String, dynamic>>()
          .map((r) => _mapToPoi(r, fallbackCategory: category))
          .toList();
      return right(pois);
    } on DioException catch (e) {
      return left(_failureFromDio(e));
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message ?? e.code));
    } catch (e) {
      _logger.w('Places Nearby unexpected error: $e');
      return left(Failure.platform(e.toString()));
    }
  }

  List<LatLng> _samplePolyline(List<LatLng> polyline) {
    final n = min(polyline.length, _maxSamples);
    if (n <= 2) return [polyline.first, polyline.last];
    final step = (polyline.length - 1) / (n - 1);
    return [
      for (var i = 0; i < n; i++)
        polyline[(step * i).round().clamp(0, polyline.length - 1)],
    ];
  }

  Failure? _failureFromStatus(String? status) {
    switch (status) {
      case 'OK':
      case 'ZERO_RESULTS':
        return null;
      case 'OVER_QUERY_LIMIT':
        return const Failure.quota('Places API quota exhausted.');
      case 'REQUEST_DENIED':
        return const Failure.permission('Places API key denied the request.');
      case 'INVALID_REQUEST':
        return const Failure.platform('Places API: invalid request.');
      case 'UNKNOWN_ERROR':
      default:
        return Failure.platform('Places API: ${status ?? 'unknown status'}.');
    }
  }

  Failure _failureFromDio(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Failure.network(e.message ?? 'Network error.');
    }
    return Failure.platform(e.message ?? e.toString());
  }

  Poi _mapToPoi(
    Map<String, dynamic> data, {
    required PoiCategory fallbackCategory,
  }) {
    final placeId = data['place_id'] as String? ?? '';
    final geometry = data['geometry']?['location'] as Map<String, dynamic>?;
    final lat = (geometry?['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (geometry?['lng'] as num?)?.toDouble() ?? 0.0;
    final name = data['name'] as String? ?? 'Unknown';
    final address =
        data['vicinity'] as String? ?? data['formatted_address'] as String?;
    final rating = (data['rating'] as num?)?.toDouble() ?? 0;
    final reviewCount = (data['user_ratings_total'] as num?)?.toInt() ?? 0;
    final openNow = data['opening_hours']?['open_now'] as bool?;
    final priceLevel = (data['price_level'] as num?)?.toInt();
    final types = (data['types'] as List?)?.cast<String>() ?? const <String>[];

    const maxPhotos = 5;
    final photoEntries = (data['photos'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .take(maxPhotos)
            .toList() ??
        const <Map<String, dynamic>>[];

    final photos = photoEntries
        .map((p) => p['photo_reference'] as String?)
        .whereType<String>()
        .toList();

    final attributions = photoEntries
        .expand(
          (p) =>
              (p['html_attributions'] as List?)?.whereType<String>() ??
              const <String>[],
        )
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();

    return Poi(
      id: placeId.isNotEmpty ? 'g_$placeId' : 'g_${name}_${lat}_$lng',
      name: name,
      category: fallbackCategory,
      latitude: lat,
      longitude: lng,
      address: address,
      source: PoiSource.googlePlaces,
      rating: rating,
      reviewCount: reviewCount,
      openNow: openNow,
      priceLevel: priceLevel,
      photos: photos,
      attributes: {
        if (types.isNotEmpty) 'google_types': types,
        if (attributions.isNotEmpty) 'photo_attributions': attributions,
      },
    );
  }

  _NearbyQuerySpec _querySpec(PoiCategory category) {
    switch (category) {
      case PoiCategory.fuel:
        return const _NearbyQuerySpec(type: 'gas_station');
      case PoiCategory.ev:
        // Delegated; never reached because of the early-return guard above.
        return const _NearbyQuerySpec(type: 'electric_vehicle_charging_station');
      case PoiCategory.restaurant:
        return const _NearbyQuerySpec(type: 'restaurant');
      case PoiCategory.pureVeg:
        return const _NearbyQuerySpec(
          type: 'restaurant',
          keyword: 'pure veg',
        );
      case PoiCategory.washroom:
        return const _NearbyQuerySpec(keyword: 'public toilet');
      case PoiCategory.atm:
        return const _NearbyQuerySpec(type: 'atm');
      case PoiCategory.hotel:
        return const _NearbyQuerySpec(type: 'lodging');
      case PoiCategory.medical:
        return const _NearbyQuerySpec(type: 'hospital');
      case PoiCategory.scenic:
        return const _NearbyQuerySpec(
          type: 'tourist_attraction',
          keyword: 'scenic viewpoint',
        );
      case PoiCategory.temple:
        return const _NearbyQuerySpec(type: 'hindu_temple');
      case PoiCategory.kidsStop:
        return const _NearbyQuerySpec(keyword: 'kids play area');
      case PoiCategory.mechanic:
        return const _NearbyQuerySpec(type: 'car_repair');
      case PoiCategory.parking:
        return const _NearbyQuerySpec(type: 'parking');
      case PoiCategory.cafe:
        return const _NearbyQuerySpec(type: 'cafe');
      case PoiCategory.tourist:
        return const _NearbyQuerySpec(type: 'tourist_attraction');
      case PoiCategory.police:
        return const _NearbyQuerySpec(type: 'police');
    }
  }
}

class _NearbyQuerySpec {
  const _NearbyQuerySpec({this.type, this.keyword});
  final String? type;
  final String? keyword;
}
