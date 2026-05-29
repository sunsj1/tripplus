import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/core/services/directions_service.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';

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
  });

  final RouteInfo activeRoute;
  final LatLng currentLocation;
  final Vehicle vehicle;
  final UserPreferences preferences;

  /// Route-aware POIs keyed by category (may be empty lists).
  final Map<PoiCategory, List<Poi>> upcomingPois;

  /// When null, derived from [currentLocation] + [activeRoute.polylinePoints].
  final double? currentDistanceAlongRouteKm;

  final DateTime? evaluatedAt;

  List<Poi> poisFor(PoiCategory category) =>
      upcomingPois[category] ?? const <Poi>[];
}
