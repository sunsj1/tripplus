import 'package:journeyplus/core/domain/route_option.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';

/// Matches a GPS position to the closest driving alternative polyline.
class RouteOptionMatcher {
  const RouteOptionMatcher._();

  /// Max perpendicular distance (km) to trust a GPS → route match.
  static const double maxGpsMatchDistanceKm = 2.0;

  /// Index of the route whose polyline is closest to [position].
  static int nearestIndexToPosition(
    LatLng position,
    List<RouteOption> options,
  ) {
    if (options.isEmpty) return 0;
    var bestIdx = 0;
    var bestDist = double.infinity;
    for (var i = 0; i < options.length; i++) {
      final dist = nearestApproachKm(options[i], position);
      if (dist < bestDist) {
        bestDist = dist;
        bestIdx = i;
      }
    }
    return bestIdx;
  }

  /// Shortest perpendicular distance from [point] to [option]'s polyline (km).
  static double nearestApproachKm(RouteOption option, LatLng point) {
    final polyline = _polylineFor(option);
    if (polyline.length < 2) return double.infinity;
    return AlertRouteUtils.nearestApproachKm(polyline, point);
  }

  /// True when [point] is within [maxKm] of the route corridor.
  static bool isOnRouteCorridor(
    RouteOption option,
    LatLng point, {
    double maxKm = maxGpsMatchDistanceKm,
  }) {
    return nearestApproachKm(option, point) <= maxKm;
  }

  static List<LatLng> _polylineFor(RouteOption option) {
    if (option.polylinePoints.isNotEmpty) return option.polylinePoints;
    if (option.encodedPolyline.isEmpty) return const [];
    return PolylineDecoder.decode(option.encodedPolyline);
  }
}
