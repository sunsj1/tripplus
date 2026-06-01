import 'package:tripplus/core/domain/fuel_brand.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/features/personalization/domain/user_preference_vector.dart';

/// P2-011 — Pure scoring function that ranks POIs against a
/// [UserPreferenceVector]. Higher score = better match. No I/O, fully testable.
///
/// Score = Σ (signal value × weight). Signals:
/// - **Quality** — rating normalized 0–1, dampened by review-count confidence.
/// - **Proximity** — closer ahead on the route scores higher (smooth decay).
/// - **Openness** — flat bonus when `openNow == true`.
/// - **Preference matches** — dietary / family / women-safe / pet / scenic /
///   budget / fuel-brand, each gated by its weight (0 when the user didn't opt in).
class PoiRanker {
  const PoiRanker();

  /// Returns a new list sorted by descending personalized score.
  /// Ties fall back to ascending route distance, then descending rating.
  List<Poi> rank(
    List<Poi> pois,
    UserPreferenceVector vector, {
    double? currentPositionKm,
  }) {
    final scored = [
      for (final p in pois)
        (poi: p, score: score(p, vector, currentPositionKm: currentPositionKm)),
    ]..sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        if (byScore != 0) return byScore;
        final da = a.poi.distanceAlongRouteKm ?? double.infinity;
        final db = b.poi.distanceAlongRouteKm ?? double.infinity;
        final byDist = da.compareTo(db);
        if (byDist != 0) return byDist;
        return b.poi.rating.compareTo(a.poi.rating);
      });
    return [for (final s in scored) s.poi];
  }

  /// Personalized score for a single POI.
  double score(
    Poi poi,
    UserPreferenceVector v, {
    double? currentPositionKm,
  }) {
    var s = 0.0;

    // Quality — rating (0–1) × confidence (saturating with review count).
    final ratingNorm = (poi.rating / 5.0).clamp(0.0, 1.0);
    final confidence = poi.reviewCount / (poi.reviewCount + 20);
    s += v.qualityWeight * ratingNorm * (0.5 + 0.5 * confidence);

    // Proximity — smooth decay over ~25 km of "ahead" distance.
    final d = poi.distanceAlongRouteKm;
    if (d != null) {
      final ahead = currentPositionKm != null ? d - currentPositionKm : d;
      if (ahead >= 0) {
        s += v.proximityWeight * (1.0 / (1.0 + ahead / 25.0));
      }
    }

    // Openness.
    if (poi.openNow == true) s += v.opennessWeight;

    // Dietary (pure veg).
    if (v.dietaryWeight > 0 && _isVeg(poi)) s += v.dietaryWeight;

    // Family-friendly.
    if (v.familyWeight > 0 &&
        _attrTrue(poi, const ['family_friendly', 'family', 'kids'])) {
      s += v.familyWeight;
    }

    // Women-safe.
    if (v.womenSafeWeight > 0 &&
        _attrTrue(poi, const ['women_safe', 'women_friendly'])) {
      s += v.womenSafeWeight;
    }

    // Pet-friendly.
    if (v.petWeight > 0 && _attrTrue(poi, const ['pet_friendly', 'pets'])) {
      s += v.petWeight;
    }

    // Scenic / tourist categories.
    if (v.scenicWeight > 0 &&
        (poi.category == PoiCategory.scenic ||
            poi.category == PoiCategory.tourist)) {
      s += v.scenicWeight;
    }

    // Budget match via Google price level.
    s += v.budgetWeight * _budgetMatch(poi, v);

    // Fuel-brand affinity (fuel POIs only).
    if (poi.category == PoiCategory.fuel && v.brandWeights.isNotEmpty) {
      final lowerName = poi.name.toLowerCase();
      for (final entry in v.brandWeights.entries) {
        if (lowerName.contains(entry.key.label.toLowerCase())) {
          s += entry.value;
          break;
        }
      }
    }

    return s;
  }

  // ── Signal helpers ─────────────────────────────────────────────────────────

  bool _isVeg(Poi poi) {
    if (poi.category == PoiCategory.pureVeg) return true;
    final lower = poi.name.toLowerCase();
    if (lower.contains('pure veg') || lower.contains('veg ')) return true;
    final diet = poi.attributes['dietary'];
    if (diet is List && diet.any((e) => '$e'.toLowerCase().contains('veg'))) {
      return true;
    }
    return poi.attributes['pure_veg'] == true;
  }

  bool _attrTrue(Poi poi, List<String> keys) {
    for (final k in keys) {
      if (poi.attributes[k] == true) return true;
    }
    return false;
  }

  /// Returns 1.0 for an exact budget match, 0.5 for adjacent, 0 for null/none.
  double _budgetMatch(Poi poi, UserPreferenceVector v) {
    final price = poi.priceLevel; // Google: 0 (free) … 4 (very expensive)
    if (price == null) return 0.0;

    final target = switch (v.budgetTier) {
      BudgetTier.low => 1,
      BudgetTier.mid => 2,
      BudgetTier.high => 3,
    };
    final diff = (price - target).abs();
    if (diff == 0) return 1.0;
    if (diff == 1) return 0.5;
    return 0.0;
  }
}
