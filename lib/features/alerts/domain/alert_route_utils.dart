import 'dart:math';

import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/utils/location_helper.dart';
import 'package:tripplus/core/utils/polyline_decoder.dart';

/// Shared geometry helpers for distance-based alert rules.
class AlertRouteUtils {
  AlertRouteUtils._();

  /// Minimum gap (km) before fuel / EV gap rules fire — matches
  /// [RouteStationService] corridor gap detection.
  static const double gapThresholdKm = 40;

  /// Approximate distance from route start to [point] by projecting onto the
  /// polyline (same algorithm as [RouteStationService._distanceAlongRoute]).
  static double distanceAlongRoute(List<LatLng> polyline, LatLng point) {
    if (polyline.length < 2) {
      return LocationHelper.distanceInKm(
        polyline.first.latitude,
        polyline.first.longitude,
        point.latitude,
        point.longitude,
      );
    }

    double cumulativeKm = 0;
    double bestProjection = 0;
    double bestPerpendicularDist = double.infinity;

    for (var i = 0; i < polyline.length - 1; i++) {
      final segLen = _haversine(polyline[i], polyline[i + 1]);
      final dToPoint = _haversine(polyline[i], point);
      final dFromEnd = _haversine(point, polyline[i + 1]);

      if (segLen > 0) {
        final t = ((dToPoint * dToPoint -
                    dFromEnd * dFromEnd +
                    segLen * segLen) /
                (2 * segLen))
            .clamp(0.0, segLen);
        final perpDist = sqrt(max(0, dToPoint * dToPoint - t * t));

        if (perpDist < bestPerpendicularDist) {
          bestPerpendicularDist = perpDist;
          bestProjection = cumulativeKm + t;
        }
      }

      cumulativeKm += segLen;
    }

    return bestProjection;
  }

  /// P2-002 — Shortest perpendicular distance (km) from [point] to the route
  /// polyline. Used by the ghat rule to decide whether the route actually
  /// passes through a known ghat section (vs. one merely near the corridor).
  static double nearestApproachKm(List<LatLng> polyline, LatLng point) {
    if (polyline.length < 2) {
      return _haversine(polyline.first, point);
    }

    double best = double.infinity;
    for (var i = 0; i < polyline.length - 1; i++) {
      final segLen = _haversine(polyline[i], polyline[i + 1]);
      final dStart = _haversine(polyline[i], point);
      final dEnd = _haversine(point, polyline[i + 1]);

      double perp;
      if (segLen <= 0) {
        perp = dStart;
      } else {
        final t = ((dStart * dStart - dEnd * dEnd + segLen * segLen) /
                (2 * segLen))
            .clamp(0.0, segLen);
        perp = sqrt(max(0, dStart * dStart - t * t));
      }
      if (perp < best) best = perp;
    }
    return best;
  }

  /// POIs strictly ahead of [currentKm] on the route, sorted by distance.
  static List<Poi> poisAhead(List<Poi> pois, double currentKm) {
    return pois
        .where((p) => (p.distanceAlongRouteKm ?? -1) > currentKm)
        .toList()
      ..sort(
        (a, b) => (a.distanceAlongRouteKm ?? 0)
            .compareTo(b.distanceAlongRouteKm ?? 0),
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
    return pois
        .where((p) {
          final km = p.distanceAlongRouteKm;
          return km != null && km > currentKm && km <= cutoff;
        })
        .toList()
      ..sort(
        (a, b) => (a.distanceAlongRouteKm ?? 0)
            .compareTo(b.distanceAlongRouteKm ?? 0),
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

  static double _haversine(LatLng a, LatLng b) {
    return LocationHelper.distanceInKm(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    );
  }
}
