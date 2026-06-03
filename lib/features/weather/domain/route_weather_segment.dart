/// P2-040 — Weather snapshot for one sample point along the active route.
///
/// We sample 3–4 evenly spaced points (origin, intermediate, destination)
/// rather than every km — the user only needs a coarse picture, and Open-Meteo
/// quotas appreciate the restraint. `distanceAlongRouteKm` lets the timeline
/// align each segment to its position on the journey.
class RouteWeatherSegment {
  const RouteWeatherSegment({
    required this.label,
    required this.distanceAlongRouteKm,
    required this.temperatureC,
    required this.weatherCode,
    required this.precipitationMm,
    required this.windKph,
  });

  /// Human label for the sample point ("Origin", "Midway", "Destination").
  final String label;

  /// Position along the route polyline (km). `0` = origin.
  final double distanceAlongRouteKm;

  /// Current temperature in °C.
  final double temperatureC;

  /// WMO weather code (Open-Meteo encoding).
  /// 0=clear · 1–3=partly cloudy · 45/48=fog · 51–57=drizzle · 61–67=rain ·
  /// 71–77=snow · 80–82=showers · 95–99=thunderstorm.
  final int weatherCode;

  /// Precipitation in mm (last hour).
  final double precipitationMm;

  /// Wind speed (km/h).
  final double windKph;

  // ── Presentation helpers ───────────────────────────────────────────────────

  /// Short human-readable label ("Clear", "Light rain", "Thunderstorm"…).
  String get conditionLabel {
    if (weatherCode == 0) return 'Clear';
    if (weatherCode <= 3) return 'Cloudy';
    if (weatherCode == 45 || weatherCode == 48) return 'Foggy';
    if (weatherCode >= 51 && weatherCode <= 57) return 'Drizzle';
    if (weatherCode >= 61 && weatherCode <= 67) return 'Rain';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Snow';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Showers';
    if (weatherCode >= 95) return 'Thunderstorm';
    return 'Mixed';
  }

  /// True for conditions that meaningfully affect driving (rain ≥ light,
  /// thunderstorm, snow, fog with low visibility, severe winds).
  bool get isDrivingHazard {
    if (weatherCode == 45 || weatherCode == 48) return true;
    if (weatherCode >= 61 && weatherCode <= 67) return true;
    if (weatherCode >= 71 && weatherCode <= 77) return true;
    if (weatherCode >= 80) return true;
    if (windKph >= 40) return true;
    return false;
  }
}
