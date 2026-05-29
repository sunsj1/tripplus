import 'dart:math';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/constants/api_constants.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';

class RouteInfo {
  final LatLng origin;
  final LatLng destination;
  final double distanceKm;
  final int durationMinutes;
  final List<LatLng> polylinePoints;

  /// Google-encoded overview polyline when sourced from Directions API.
  final String? encodedPolyline;

  const RouteInfo({
    required this.origin,
    required this.destination,
    required this.distanceKm,
    required this.durationMinutes,
    required this.polylinePoints,
    this.encodedPolyline,
  });
}

class DirectionsService {
  final Dio _dio;
  final _logger = Logger();

  DirectionsService(this._dio);

  /// Returns the driving route between [origin] and [destination].
  /// Falls back to straight-line interpolation if Google Directions API
  /// is unavailable.
  Future<RouteInfo> getRoute(LatLng origin, LatLng destination) async {
    if (ApiConstants.isGoogleMapsKeyConfigured) {
      try {
        return await _getGoogleRoute(origin, destination);
      } catch (e) {
        _logger.w('Google Directions failed ($e), using straight-line fallback');
      }
    }
    return _straightLineFallback(origin, destination);
  }

  Future<RouteInfo> _getGoogleRoute(LatLng origin, LatLng destination) async {
    _logger.d('Fetching route via Google Directions');

    final response = await _dio.get<Map<String, dynamic>>(
      'https://maps.googleapis.com/maps/api/directions/json',
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode': 'driving',
        'key': ApiConstants.googleMapsApiKey,
      },
    );

    final data = response.data;
    if (data == null || data['status'] != 'OK') {
      final status = data?['status'] ?? 'UNKNOWN';
      throw DirectionsException('Directions API: $status');
    }

    final routes = data['routes'] as List;
    if (routes.isEmpty) {
      throw DirectionsException('No route found between the locations.');
    }

    final route = routes[0] as Map<String, dynamic>;
    final leg = (route['legs'] as List)[0] as Map<String, dynamic>;
    final distanceMeters = leg['distance']['value'] as int;
    final durationSeconds = leg['duration']['value'] as int;
    final encodedPolyline =
        route['overview_polyline']['points'] as String;

    final polylinePoints = PolylineDecoder.decode(encodedPolyline);
    final distanceKm = distanceMeters / 1000.0;

    _logger.i(
      'Route: ${distanceKm.round()} km, '
      '${(durationSeconds / 60).round()} min, '
      '${polylinePoints.length} polyline points',
    );

    return RouteInfo(
      origin: origin,
      destination: destination,
      distanceKm: distanceKm,
      durationMinutes: (durationSeconds / 60).round(),
      polylinePoints: polylinePoints,
      encodedPolyline: encodedPolyline,
    );
  }

  /// Generates a straight-line route when Directions API is unavailable.
  RouteInfo _straightLineFallback(LatLng origin, LatLng destination) {
    final distanceKm = _haversine(origin, destination);
    final estimatedMinutes = (distanceKm / 80 * 60).round();

    final pointCount = max(2, (distanceKm / 50).round());
    final points =
        PolylineDecoder.interpolate(origin, destination, pointCount);

    _logger.i(
      'Straight-line fallback: ${distanceKm.round()} km, '
      '$pointCount sample points',
    );

    return RouteInfo(
      origin: origin,
      destination: destination,
      distanceKm: distanceKm,
      durationMinutes: estimatedMinutes,
      polylinePoints: points,
    );
  }

  static double _haversine(LatLng a, LatLng b) {
    const r = 6371.0;
    final dLat = _rad(b.latitude - a.latitude);
    final dLng = _rad(b.longitude - a.longitude);
    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(a.latitude)) *
            cos(_rad(b.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return 2 * r * asin(sqrt(h));
  }

  static double _rad(double deg) => deg * pi / 180;
}

class DirectionsException implements Exception {
  final String message;
  const DirectionsException(this.message);

  @override
  String toString() => message;
}
