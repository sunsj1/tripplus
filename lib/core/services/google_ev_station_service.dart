import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/constants/api_constants.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';

/// Fetches EV charging POIs from Google Places, then re-checks each candidate
/// with Place Details so we only keep listings whose description or name/address
/// clearly indicates electric vehicle charging. Mis-tagged POIs are dropped so
/// route and map views can rely on Open Charge Map for coverage instead.
class GoogleEvStationService {
  GoogleEvStationService(this._dio);

  final Dio _dio;
  final _logger = Logger();

  static final _detailFields = [
    'name',
    'editorial_summary',
    'types',
    'formatted_address',
    'business_status',
    'opening_hours',
    'rating',
    'geometry',
  ].join(',');

  /// Phrases that strongly indicate EV charging (not generic “charging station”).
  static final List<RegExp> _evSignals = [
    RegExp(r'\bev\b\s*(charging|charger|station|point)', caseSensitive: false),
    RegExp(r'electric\s+vehicle', caseSensitive: false),
    RegExp(r'electric\s+car\s+charg', caseSensitive: false),
    RegExp(r'vehicle\s+charging\s+station', caseSensitive: false),
    RegExp(r'car\s+charg(?:e|ing)?\s+station', caseSensitive: false),
    RegExp(r'dc\s+fast', caseSensitive: false),
    RegExp(r'\bccs\b', caseSensitive: false),
    RegExp(r'chademo', caseSensitive: false),
    RegExp(r'j1772', caseSensitive: false),
    RegExp(r'type\s*2\s+charg', caseSensitive: false),
    RegExp(r'\bnacs\b', caseSensitive: false),
    RegExp(r'supercharger', caseSensitive: false),
    RegExp(r'\bionity\b', caseSensitive: false),
    RegExp(r'\bevgo\b', caseSensitive: false),
    RegExp(r'charge\s*point', caseSensitive: false),
    RegExp(r'electrify\s+america', caseSensitive: false),
    RegExp(r'shell\s+recharge', caseSensitive: false),
    RegExp(r'bp\s+pulse', caseSensitive: false),
    RegExp(r'fastned', caseSensitive: false),
    RegExp(r'rapid\s+charg(?:e|er)', caseSensitive: false),
    RegExp(r'fast\s+charg(?:e|er)', caseSensitive: false),
  ];

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
          'radius': radiusMeters.round().clamp(1, 50000),
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
      if (results.isEmpty) return [];

      const batchSize = 6;
      final verified = <ChargingStation>[];
      for (var i = 0; i < results.length; i += batchSize) {
        final batch = results.skip(i).take(batchSize);
        final futures = batch.map(
          (raw) => _verifyAndMap(raw as Map<String, dynamic>),
        );
        final chunk = await Future.wait(futures);
        verified.addAll(chunk.whereType<ChargingStation>());
      }

      return verified;
    } catch (e) {
      _logger.w('Google EV station fetch failed: $e');
      return [];
    }
  }

  Future<ChargingStation?> _verifyAndMap(Map<String, dynamic> nearby) async {
    final placeId = nearby['place_id'] as String? ?? '';
    if (placeId.isEmpty) return null;

    final details = await _fetchPlaceDetails(placeId);
    if (details == null) return null;

    if (!_passesEvDescriptionGate(details)) {
      _logger.d(
        'Google EV candidate dropped (no clear EV signal in details): '
        '${details['name']}',
      );
      return null;
    }

    return _mapFromDetails(nearby, details);
  }

  Future<Map<String, dynamic>?> _fetchPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': _detailFields,
          'key': ApiConstants.googleMapsApiKey,
        },
      );
      final data = response.data;
      if (data['status'] != 'OK') {
        _logger.w('Google Place Details status: ${data['status']}');
        return null;
      }
      final result = data['result'];
      if (result is! Map<String, dynamic>) return null;
      return result;
    } catch (e) {
      _logger.w('Google Place Details failed for $placeId: $e');
      return null;
    }
  }

  static String? _editorialOverview(Map<String, dynamic> details) {
    final raw = details['editorial_summary'];
    if (raw is! Map) return null;
    return raw['overview'] as String?;
  }

  static bool _passesEvDescriptionGate(Map<String, dynamic> details) {
    final types = (details['types'] as List?)?.cast<String>() ?? [];
    if (!types.contains('electric_vehicle_charging_station')) return false;

    final overview = _editorialOverview(details);
    final name = details['name'] as String? ?? '';
    final addr = details['formatted_address'] as String? ?? '';

    if (overview != null && overview.trim().isNotEmpty) {
      return _clearlyEvCharging(overview);
    }
    return _clearlyEvCharging('$name $addr');
  }

  static bool _clearlyEvCharging(String text) {
    final t = text.toLowerCase().trim();
    if (t.isEmpty) return false;

    final looksLikePhoneOnly =
        t.contains('phone charging') &&
            !t.contains('electric vehicle') &&
            !RegExp(r'\bev\b').hasMatch(t);
    if (looksLikePhoneOnly) return false;

    for (final pattern in _evSignals) {
      if (pattern.hasMatch(t)) return true;
    }
    return false;
  }

  ChargingStation _mapFromDetails(
    Map<String, dynamic> nearby,
    Map<String, dynamic> details,
  ) {
    final placeId = nearby['place_id'] as String? ?? '';

    final geometry = details['geometry']?['location'] ??
        nearby['geometry']?['location'] ??
        {};
    final lat = (geometry['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (geometry['lng'] as num?)?.toDouble() ?? 0.0;

    final isOpen = details['opening_hours']?['open_now'] as bool? ??
        nearby['opening_hours']?['open_now'] as bool?;
    final rating = (details['rating'] as num?)?.toDouble() ??
        (nearby['rating'] as num?)?.toDouble();

    final name = details['name'] as String? ??
        nearby['name'] as String? ??
        'EV Charging Station';
    final address = details['formatted_address'] as String? ??
        nearby['vicinity'] as String?;

    final overview = _editorialOverview(details);
    final commentParts = <String>[];
    if (rating != null) commentParts.add('Google rating: $rating/5');
    if (overview != null && overview.trim().isNotEmpty) {
      commentParts.add(overview.trim());
    }

    return ChargingStation(
      id: placeId.hashCode.abs(),
      uuid: placeId,
      name: name,
      latitude: lat,
      longitude: lng,
      address: address,
      isOperational: isOpen,
      statusType: isOpen == true ? 'Operational' : null,
      operatorName: name,
      generalComments:
          commentParts.isEmpty ? null : commentParts.join(' — '),
      dataSource: 'google',
    );
  }
}
