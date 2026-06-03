import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/core/services/directions_service.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';
import 'package:tripplus/features/weather/domain/route_weather_segment.dart';

/// Inputs for a single [AlertEngine.evaluate] pass.
///
/// [upcomingPois] is keyed by [PoiCategory]. Callers pre-fetch corridor POIs
/// (fuel, ev, restaurant, pureVeg, …) and pass them in; the engine stays
/// pure Dart with no I/O.
class AlertEngineInput {
  const AlertEngineInput({
    required this.activeRoute,
    required this.currentLocation,
    required this.vehicle,
    required this.preferences,
    required this.upcomingPois,
    this.currentDistanceAlongRouteKm,
    this.evaluatedAt,
    this.upcomingWindowKm = defaultWindowKm,
    this.drivingDuration,
    this.upcomingWeather = const [],
  });

  /// P2-001 — Default upcoming evaluation window (km).
  ///
  /// The engine pre-filters POIs to those within this distance ahead before
  /// passing them to individual rules.  100 km is enough lookahead for any
  /// practical Indian highway drive while avoiding false positives at the
  /// start of a long route.
  static const double defaultWindowKm = 100.0;

  final RouteInfo activeRoute;
  final LatLng currentLocation;
  final Vehicle vehicle;
  final UserPreferences preferences;

  /// Route-aware POIs keyed by category (may be empty lists).
  final Map<PoiCategory, List<Poi>> upcomingPois;

  /// When null, derived from [currentLocation] + [activeRoute.polylinePoints].
  final double? currentDistanceAlongRouteKm;

  final DateTime? evaluatedAt;

  /// P2-001 — Only evaluate POIs within this many km ahead of the current
  /// position. Prevents alerts about stops that are irrelevant (e.g. a
  /// charger 250 km away when you just started a 400 km trip).
  final double upcomingWindowKm;

  /// P2-004 — Continuous driving time since the trip started (paused time
  /// already excluded). Null when not tracking a live trip. Consumed by the
  /// fatigue rule.
  final Duration? drivingDuration;

  /// P2-005 — Per-segment weather along the route (pre-fetched by the
  /// notifier). The weather rule scans this for the nearest hazardous
  /// segment in the upcoming window.
  final List<RouteWeatherSegment> upcomingWeather;

  List<Poi> poisFor(PoiCategory category) =>
      upcomingPois[category] ?? const <Poi>[];
}
