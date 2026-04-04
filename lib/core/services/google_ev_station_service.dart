import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/constants/api_constants.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';

class GoogleEvStationService {
  final Dio _dio;
  final _logger = Logger();

  GoogleEvStationService(this._dio);

  Future<List<ChargingStation>> fetchStationsNear({
    required double latitude,
    required double longitude,
    double radiusMeters = 50000,
  }) async {
    if (!ApiConstants.isGoogleMapsKeyConfigured) return [];

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: {
          'location': '$latitude,$longitude',
          'radius': radiusMeters.round(),
          'type': 'electric_vehicle_charging_station',
          'key': ApiConstants.googleMapsApiKey,
        },
      );

      final data = response.data;
      if (data['status'] != 'OK' && data['status'] != 'ZERO_RESULTS') {
        _logger.w('Google Places Nearby status: ${data['status']}');
        return [];
      }

      final results = data['results'] as List? ?? [];
      return results.map<ChargingStation>((r) => _mapResult(r)).toList();
    } catch (e) {
      _logger.w('Google EV station fetch failed: $e');
      return [];
    }
  }

  ChargingStation _mapResult(Map<String, dynamic> r) {
    final geometry = r['geometry']?['location'] ?? {};
    final lat = (geometry['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (geometry['lng'] as num?)?.toDouble() ?? 0.0;
    final placeId = r['place_id'] as String? ?? '';

    final isOpen = r['opening_hours']?['open_now'] as bool?;
    final rating = (r['rating'] as num?)?.toDouble();

    return ChargingStation(
      id: placeId.hashCode.abs(),
      uuid: placeId,
      name: r['name'] as String? ?? 'EV Charging Station',
      latitude: lat,
      longitude: lng,
      address: r['vicinity'] as String?,
      isOperational: isOpen,
      statusType: isOpen == true ? 'Operational' : null,
      operatorName: r['name'] as String?,
      generalComments: rating != null ? 'Google rating: $rating/5' : null,
      dataSource: 'google',
    );
  }
}
