import 'package:tripplus/core/utils/polyline_decoder.dart';
import 'package:tripplus/features/alerts/domain/alert_route_utils.dart';
import 'package:tripplus/features/tolls/domain/toll_corridor.dart';

/// P2-042 — Result of corridor matching for a single route.
class TollEstimate {
  const TollEstimate({
    required this.totalRupees,
    required this.matchedCorridor,
    required this.isCorridorMatch,
  });

  /// Estimated toll cost in ₹ (car class). Always > 0 for non-bike vehicles.
  final double totalRupees;

  /// Name of the matched corridor, e.g. "Mumbai–Pune Expressway". Null on
  /// fallback (flat rate, no corridor matched).
  final String? matchedCorridor;

  /// True when a corridor was matched (high-confidence estimate).
  final bool isCorridorMatch;
}

/// P2-042 — Stateless estimator. Walks every corridor in [kTollCorridors] and
/// picks the one with the most waypoints within `matchRadiusKm` of the route
/// polyline. We need at least half the corridor's waypoints to match before
/// trusting it.
class TollEstimator {
  const TollEstimator();

  /// Flat-rate fallback (legacy ₹1.5/km).
  static const _fallbackRatePerKm = 1.5;
  static const _minMatchFraction = 0.5;

  TollEstimate estimate({
    required List<LatLng> polylinePoints,
    required double totalDistanceKm,
  }) {
    if (polylinePoints.length < 2 || totalDistanceKm <= 0) {
      return TollEstimate(
        totalRupees: totalDistanceKm * _fallbackRatePerKm,
        matchedCorridor: null,
        isCorridorMatch: false,
      );
    }

    TollCorridor? best;
    int bestHits = 0;

    for (final corridor in kTollCorridors) {
      var hits = 0;
      for (final wp in corridor.waypoints) {
        final perp = AlertRouteUtils.nearestApproachKm(
          polylinePoints,
          LatLng(wp.lat, wp.lng),
        );
        if (perp <= corridor.matchRadiusKm) hits++;
      }
      final fraction = hits / corridor.waypoints.length;
      if (fraction >= _minMatchFraction && hits > bestHits) {
        best = corridor;
        bestHits = hits;
      }
    }

    if (best != null) {
      return TollEstimate(
        totalRupees: totalDistanceKm * best.ratePerKm,
        matchedCorridor: best.name,
        isCorridorMatch: true,
      );
    }

    return TollEstimate(
      totalRupees: totalDistanceKm * _fallbackRatePerKm,
      matchedCorridor: null,
      isCorridorMatch: false,
    );
  }
}
