import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/domain/trip_position.dart';
import 'package:journeyplus/core/utils/corridor_geometry.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';

/// Shared geometry helpers for distance-based alert rules.
class AlertRouteUtils {
  AlertRouteUtils._();

  /// Minimum gap (km) before fuel / EV gap rules fire — matches
  /// [RouteStationService] corridor gap detection.
  static const double gapThresholdKm = 40;

  /// Driver progress along [polyline], shared by alerts and corridor lists.
  ///
  /// Returns null for a missing/invalid corridor rather than projecting against
  /// a single point. Consumers can then show an explicit degraded state.
  static double? currentDistanceAlongRouteKm(
    TripPosition position,
    List<LatLng> polyline,
  ) {
    if (polyline.length < 2) return null;
    return distanceAlongRoute(polyline, position.latLng);
  }

  /// Approximate distance from route start to [point] by projecting onto the
  /// polyline.
  static double distanceAlongRoute(List<LatLng> polyline, LatLng point) {
    return CorridorGeometry.distanceAlongRoute(polyline, point);
  }

  /// P2-002 — Shortest perpendicular distance (km) from [point] to the route
  /// polyline. Used by the ghat rule to decide whether the route actually
  /// passes through a known ghat section (vs. one merely near the corridor).
  static double nearestApproachKm(List<LatLng> polyline, LatLng point) {
    return CorridorGeometry.nearestApproachKm(polyline, point);
  }

  /// POIs strictly ahead of [currentKm] on the route, sorted by distance.
  static List<Poi> poisAhead(List<Poi> pois, double currentKm) {
    return pois
        .where((p) => (p.distanceAlongRouteKm ?? -1) > currentKm)
        .toList()
      ..sort(
        (a, b) => (a.distanceAlongRouteKm ?? 0).compareTo(
          b.distanceAlongRouteKm ?? 0,
        ),
      );
  }

  /// P2-001 — POIs within [windowKm] ahead of [currentKm], sorted by distance.
  ///
  /// Used by [AlertEngine] to restrict evaluation to the immediate upcoming
  /// corridor rather than the full remaining route, so alerts are always
  /// timely and actionable.
  static List<Poi> poisInWindow(
    List<Poi> pois,
    double currentKm,
    double windowKm,
  ) {
    final cutoff = currentKm + windowKm;
    return pois.where((p) {
      final km = p.distanceAlongRouteKm;
      return km != null && km > currentKm && km <= cutoff;
    }).toList()..sort(
      (a, b) =>
          (a.distanceAlongRouteKm ?? 0).compareTo(b.distanceAlongRouteKm ?? 0),
    );
  }

  /// Largest gap (km) between consecutive POIs from [currentKm] to route end.
  static double? largestGapAhead(
    List<Poi> sortedAhead,
    double currentKm,
    double routeEndKm,
  ) {
    if (sortedAhead.isEmpty) {
      final remaining = routeEndKm - currentKm;
      return remaining > gapThresholdKm ? remaining : null;
    }

    double? maxGap;
    var prevKm = currentKm;

    for (final poi in sortedAhead) {
      final poiKm = poi.distanceAlongRouteKm ?? prevKm;
      final gap = poiKm - prevKm;
      if (gap > gapThresholdKm && (maxGap == null || gap > maxGap)) {
        maxGap = gap;
      }
      prevKm = poiKm;
    }

    final tailGap = routeEndKm - prevKm;
    if (tailGap > gapThresholdKm && (maxGap == null || tailGap > maxGap)) {
      maxGap = tailGap;
    }

    return maxGap;
  }
}
