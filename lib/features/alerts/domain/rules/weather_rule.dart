import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';
import 'package:journeyplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:journeyplus/features/weather/domain/route_weather_segment.dart';
import 'package:uuid/uuid.dart';

/// **P2-005 — Weather alert.**
///
/// Surfaces hazardous weather (rain/snow/storm/fog/high-wind) on an upcoming
/// route segment. The engine attaches the prefetched [RouteWeatherSegment]
/// list via [AlertEngineInput.upcomingWeather]; the rule picks the nearest
/// hazard within the upcoming window and emits one alert.
///
/// Severity:
/// - Thunderstorm / heavy precipitation → critical
/// - Other driving hazards → warning
class WeatherRule extends AlertRule {
  const WeatherRule();

  static const _heavyPrecipMm = 4.0; // mm in the last hour ≈ heavy

  @override
  List<Alert> evaluate(AlertEngineInput input, double currentKm) {
    final weather = input.upcomingWeather;
    if (weather.isEmpty) return const [];

    final windowEnd = currentKm + input.upcomingWindowKm;
    RouteWeatherSegment? upcoming;

    for (final seg in weather) {
      if (!seg.isDrivingHazard) continue;
      if (seg.distanceAlongRouteKm < currentKm) continue;
      if (seg.distanceAlongRouteKm > windowEnd) continue;
      upcoming = seg;
      break;
    }

    if (upcoming == null) return const [];

    final isThunder = upcoming.weatherCode >= 95;
    final isHeavy = upcoming.precipitationMm >= _heavyPrecipMm;
    final severity = (isThunder || isHeavy)
        ? AlertSeverity.critical
        : AlertSeverity.warning;

    final aheadKm =
        (upcoming.distanceAlongRouteKm - currentKm).clamp(0.0, double.infinity);

    return [
      Alert(
        id: const Uuid().v4(),
        type: AlertType.weather,
        severity: severity,
        message:
            '${upcoming.conditionLabel} ahead near ${upcoming.label} '
            '(~${aheadKm.round()} km) · ${upcoming.temperatureC.round()}°. '
            'Drive cautiously${isHeavy || isThunder ? " or wait it out" : ""}.',
        distanceKm: aheadKm,
        triggeredAt: input.evaluatedAt ?? DateTime.now(),
      ),
    ];
  }
}
