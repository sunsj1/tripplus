import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/weather/data/open_meteo_weather_service.dart';
import 'package:journeyplus/features/weather/domain/route_weather_segment.dart';

/// P2-040 — Dedicated Dio for Open-Meteo. Open-Meteo doesn't accept the
/// browser-style query strings our Google Dio uses; keep them separate.
final _weatherDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));
});

final openMeteoWeatherServiceProvider = Provider<OpenMeteoWeatherService>(
  (ref) => OpenMeteoWeatherService(ref.watch(_weatherDioProvider)),
);

/// Cached per-plan weather samples. Keyed on the plan's encoded polyline so
/// it auto-invalidates when the plan changes; autoDispose so we don't hold
/// stale data forever.
final routeWeatherProvider = FutureProvider.autoDispose
    .family<List<RouteWeatherSegment>, PlanResult>((ref, plan) async {
  final encoded = plan.encodedRoutePolyline;
  if (encoded == null || encoded.isEmpty) return const [];

  final points = PolylineDecoder.decode(encoded);
  if (points.length < 2) return const [];

  return ref.watch(openMeteoWeatherServiceProvider).sampleAlongRoute(
        polylinePoints: points,
        totalDistanceKm: plan.totalDistanceKm,
      );
});
