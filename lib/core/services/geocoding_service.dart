import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/constants/api_constants.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';

class GeocodingService {
  final Dio _dio;
  final _logger = Logger();

  GeocodingService(this._dio);

  /// Converts a place name into geographic coordinates.
  /// Uses Google Geocoding API if key is available, otherwise falls back
  /// to OpenStreetMap Nominatim.
  Future<LatLng> geocode(String address) async {
    if (ApiConstants.isGoogleMapsKeyConfigured) {
      return _geocodeGoogle(address);
    }
    return _geocodeNominatim(address);
  }

  Future<LatLng> _geocodeGoogle(String address) async {
    _logger.d('Geocoding via Google: "$address"');

    final response = await _dio.get<Map<String, dynamic>>(
      'https://maps.googleapis.com/maps/api/geocode/json',
      queryParameters: {
        'address': address,
        'key': ApiConstants.googleMapsApiKey,
      },
    );

    final data = response.data;
    if (data == null || data['status'] != 'OK') {
      final status = data?['status'] ?? 'UNKNOWN';
      throw GeocodingException(
        'Could not find "$address" ($status). Try a more specific name.',
      );
    }

    final results = data['results'] as List;
    if (results.isEmpty) {
      throw GeocodingException('No results for "$address".');
    }

    final location = results[0]['geometry']['location'];
    final lat = (location['lat'] as num).toDouble();
    final lng = (location['lng'] as num).toDouble();

    _logger.i('Geocoded "$address" → $lat, $lng');
    return LatLng(lat, lng);
  }

  /// Free fallback using OpenStreetMap Nominatim.
  /// Rate limit: 1 req/s, no heavy usage.
  Future<LatLng> _geocodeNominatim(String address) async {
    _logger.d('Geocoding via Nominatim: "$address"');

    final response = await _dio.get<List<dynamic>>(
      'https://nominatim.openstreetmap.org/search',
      queryParameters: {
        'q': address,
        'format': 'json',
        'limit': 1,
      },
      options: Options(headers: {
        'User-Agent': 'TripPlus/1.0 (Flutter; EV charging app)',
      }),
    );

    final results = response.data;
    if (results == null || results.isEmpty) {
      throw GeocodingException('Could not find "$address".');
    }

    final first = results[0] as Map<String, dynamic>;
    final lat = double.parse(first['lat'] as String);
    final lng = double.parse(first['lon'] as String);

    _logger.i('Geocoded "$address" → $lat, $lng');
    return LatLng(lat, lng);
  }
}

class GeocodingException implements Exception {
  final String message;
  const GeocodingException(this.message);

  @override
  String toString() => message;
}
