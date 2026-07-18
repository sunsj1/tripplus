import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/utils/corridor_ahead.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';
import 'package:journeyplus/features/hidden_gems/data/hidden_gem_dataset.dart';
import 'package:journeyplus/features/hidden_gems/domain/hidden_gem.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

/// P2-060 — Raw curated dataset, loaded once from asset.
final hiddenGemCorridorsProvider =
    FutureProvider<List<HiddenGemCorridor>>((ref) {
  return HiddenGemDataset.load();
});

/// Result of matching a [PlanResult] to a curated corridor. Null when there's
/// no active plan or no corridor matched.
class CorridorMatch {
  const CorridorMatch({
    required this.corridor,
    required this.gems,
    this.waitingForGps = false,
    this.aheadOnly = false,
  });

  final HiddenGemCorridor corridor;
  final List<HiddenGem> gems;
  final bool waitingForGps;
  final bool aheadOnly;
}

/// P2-061 — Gems to surface for the active plan, sorted by distance along
/// the route. Returns null when no curated corridor matches (the carousel
/// then hides itself).
///
/// While a trip is running with GPS, gems clearly behind the driver are hidden.
final activeCorridorGemsProvider =
    FutureProvider<CorridorMatch?>((ref) async {
  final planState = ref.watch(planControllerProvider);
  if (planState is! PlanResult) return null;
  final encoded = planState.encodedRoutePolyline;
  if (encoded == null || encoded.isEmpty) return null;

  final polyline = PolylineDecoder.decode(encoded);
  if (polyline.length < 2) return null;

  final corridors = await ref.watch(hiddenGemCorridorsProvider.future);

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

  final withKm = [
    for (final gem in best.gems)
      (
        gem: gem,
        km: AlertRouteUtils.distanceAlongRoute(
          polyline,
          LatLng(gem.lat, gem.lng),
        ),
      ),
  ]..sort((a, b) => a.km.compareTo(b.km));

  final progress = ref.watch(tripCorridorProgressProvider);
  if (!progress.tripRunning) {
    return CorridorMatch(
      corridor: best,
      gems: [for (final e in withKm) e.gem],
    );
  }

  if (!progress.canFilterAhead) {
    return CorridorMatch(
      corridor: best,
      gems: [for (final e in withKm) e.gem],
      waitingForGps: true,
    );
  }

  final ahead = CorridorAhead.filterByKm(
    withKm,
    (e) => e.km,
    progress.currentKm!,
  );

  return CorridorMatch(
    corridor: best,
    gems: [for (final e in ahead) e.gem],
    aheadOnly: true,
  );
});
