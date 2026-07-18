import 'dart:math';

import 'package:journeyplus/core/utils/location_helper.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';

/// Canonical route-polyline projection used across stations, POIs, and alerts.
class CorridorGeometry {
  const CorridorGeometry._();

  /// Approximate distance from route start to [point].
  static double distanceAlongRoute(List<LatLng> polyline, LatLng point) {
    if (polyline.isEmpty) return 0;
    if (polyline.length == 1) return _haversine(polyline.first, point);

    var cumulativeKm = 0.0;
    var bestProjection = 0.0;
    var bestPerpendicularDistance = double.infinity;

    for (var i = 0; i < polyline.length - 1; i++) {
      final segmentLength = _haversine(polyline[i], polyline[i + 1]);
      final distanceToPoint = _haversine(polyline[i], point);
      final distanceFromEnd = _haversine(point, polyline[i + 1]);

      if (segmentLength > 0) {
        final projection =
            ((distanceToPoint * distanceToPoint -
                        distanceFromEnd * distanceFromEnd +
                        segmentLength * segmentLength) /
                    (2 * segmentLength))
                .clamp(0.0, segmentLength);
        final perpendicularDistance = sqrt(
          max(0, distanceToPoint * distanceToPoint - projection * projection),
        );

        if (perpendicularDistance < bestPerpendicularDistance) {
          bestPerpendicularDistance = perpendicularDistance;
          bestProjection = cumulativeKm + projection;
        }
      }

      cumulativeKm += segmentLength;
    }

    return bestProjection;
  }

  /// Shortest perpendicular distance from [point] to [polyline].
  static double nearestApproachKm(List<LatLng> polyline, LatLng point) {
    if (polyline.isEmpty) return double.infinity;
    if (polyline.length == 1) return _haversine(polyline.first, point);

    var best = double.infinity;
    for (var i = 0; i < polyline.length - 1; i++) {
      final segmentLength = _haversine(polyline[i], polyline[i + 1]);
      final distanceFromStart = _haversine(polyline[i], point);
      final distanceFromEnd = _haversine(point, polyline[i + 1]);

      final perpendicular = segmentLength <= 0
          ? distanceFromStart
          : sqrt(
              max(
                0,
                distanceFromStart * distanceFromStart -
                    pow(
                      ((distanceFromStart * distanceFromStart -
                                  distanceFromEnd * distanceFromEnd +
                                  segmentLength * segmentLength) /
                              (2 * segmentLength))
                          .clamp(0.0, segmentLength),
                      2,
                    ),
              ),
            );
      if (perpendicular < best) best = perpendicular;
    }
    return best;
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
