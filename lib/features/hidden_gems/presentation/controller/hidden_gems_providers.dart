import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';
import 'package:journeyplus/features/hidden_gems/data/hidden_gem_dataset.dart';
import 'package:journeyplus/features/hidden_gems/domain/hidden_gem.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';

/// P2-060 — Raw curated dataset, loaded once from asset.
final hiddenGemCorridorsProvider =
    FutureProvider<List<HiddenGemCorridor>>((ref) {
  return HiddenGemDataset.load();
});

/// Result of matching a [PlanResult] to a curated corridor. Null when there's
/// no active plan or no corridor matched.
class CorridorMatch {
  const CorridorMatch({required this.corridor, required this.gems});
  final HiddenGemCorridor corridor;
  final List<HiddenGem> gems;
}

/// P2-061 — Gems to surface for the active plan, sorted by distance along
/// the route. Returns null when no curated corridor matches (the carousel
/// then hides itself).
final activeCorridorGemsProvider =
    FutureProvider<CorridorMatch?>((ref) async {
  final planState = ref.watch(planControllerProvider);
  if (planState is! PlanResult) return null;
  final encoded = planState.encodedRoutePolyline;
  if (encoded == null || encoded.isEmpty) return null;

  final polyline = PolylineDecoder.decode(encoded);
  if (polyline.length < 2) return null;

  final corridors = await ref.watch(hiddenGemCorridorsProvider.future);

  // Same waypoint-hit heuristic as the toll estimator: pick the corridor whose
  // waypoints most often fall close to the route polyline. Require at least
  // 50% of the corridor's waypoints inside `matchRadiusKm`.
  HiddenGemCorridor? best;
  var bestHits = 0;

  for (final c in corridors) {
    var hits = 0;
    for (final wp in c.waypoints) {
      final perp = AlertRouteUtils.nearestApproachKm(
        polyline,
        LatLng(wp.lat, wp.lng),
      );
      if (perp <= c.matchRadiusKm) hits++;
    }
    final fraction = hits / c.waypoints.length;
    if (fraction >= 0.5 && hits > bestHits) {
      best = c;
      bestHits = hits;
    }
  }

  if (best == null) return null;

  // Sort gems by where they fall along the route — closest first for the
  // direction of travel.
  final sorted = [...best.gems]..sort((a, b) {
      final da = AlertRouteUtils.distanceAlongRoute(
          polyline, LatLng(a.lat, a.lng));
      final db = AlertRouteUtils.distanceAlongRoute(
          polyline, LatLng(b.lat, b.lng));
      return da.compareTo(db);
    });

  return CorridorMatch(corridor: best, gems: sorted);
});
