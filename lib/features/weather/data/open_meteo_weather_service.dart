import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';
import 'package:tripplus/features/weather/domain/route_weather_segment.dart';

/// P2-040 — Lightweight wrapper around Open-Meteo's free current-weather API.
///
/// No key, no auth, no quotas to worry about for our sample-and-forget use.
/// We hit the endpoint up to 4 times per plan (one per sample point) and
/// return a list aligned to those points; failures degrade silently to an
/// empty list rather than blocking the route render.
class OpenMeteoWeatherService {
  OpenMeteoWeatherService(this._dio);

  static const _base = 'https://api.open-meteo.com/v1/forecast';
  static const _maxSamples = 4;

  final Dio _dio;
  final _logger = Logger();

  /// Sample evenly along [polylinePoints] and fetch current weather for each.
  /// [totalDistanceKm] is used purely for the per-segment `distanceAlongRouteKm`
  /// label; geometry is read off the polyline.
  Future<List<RouteWeatherSegment>> sampleAlongRoute({
    required List<LatLng> polylinePoints,
    required double totalDistanceKm,
  }) async {
    if (polylinePoints.length < 2) return const [];

    final samples = _sample(polylinePoints, totalDistanceKm);
    final futures = samples.map((s) => _fetch(s.point, s.label, s.km));
    final results = await Future.wait(futures);

    return results.whereType<RouteWeatherSegment>().toList()
      ..sort((a, b) =>
          a.distanceAlongRouteKm.compareTo(b.distanceAlongRouteKm));
  }

  // ── Internals ────────────────────────────────────────────────────────────

  /// Picks origin · midway · destination (+ optional quarter point for long
  /// routes) so the weather strip has enough granularity without spamming
  /// the API.
  List<({LatLng point, String label, double km})> _sample(
    List<LatLng> polyline,
    double totalKm,
  ) {
    final samples = <({LatLng point, String label, double km})>[];
    samples.add((point: polyline.first, label: 'Origin', km: 0));

    if (totalKm > 250 && polyline.length > 4) {
      // Long route — also sample at ~1/3.
      final third = polyline[(polyline.length / 3).floor()];
      samples.add((point: third, label: 'Early', km: totalKm / 3));
    }

    final mid = polyline[polyline.length ~/ 2];
    samples.add((point: mid, label: 'Midway', km: totalKm / 2));

    samples.add((point: polyline.last, label: 'Destination', km: totalKm));

    // Cap to _maxSamples in case the long-route branch ran.
    return samples.length > _maxSamples
        ? samples.sublist(0, _maxSamples)
        : samples;
  }

  Future<RouteWeatherSegment?> _fetch(
    LatLng point,
    String label,
    double km,
  ) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        _base,
        queryParameters: {
          'latitude': point.latitude,
          'longitude': point.longitude,
          'current':
              'temperature_2m,weather_code,precipitation,wind_speed_10m',
          'wind_speed_unit': 'kmh',
          'timezone': 'auto',
        },
      );

      final current = res.data?['current'] as Map<String, dynamic>?;
      if (current == null) return null;

      return RouteWeatherSegment(
        label: label,
        distanceAlongRouteKm: km,
        temperatureC: (current['temperature_2m'] as num?)?.toDouble() ?? 0,
        weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
        precipitationMm:
            (current['precipitation'] as num?)?.toDouble() ?? 0,
        windKph: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0,
      );
    } catch (e) {
      _logger.w('Open-Meteo sample failed for ${point.latitude},'
          '${point.longitude}: $e');
      return null;
    }
  }
}
