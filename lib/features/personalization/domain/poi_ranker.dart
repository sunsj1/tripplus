import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/fuel_brand.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/features/personalization/domain/ranking_explanation.dart';
import 'package:journeyplus/features/personalization/domain/user_preference_vector.dart';

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
  }) =>
      _evaluate(poi, v, currentPositionKm: currentPositionKm).totalScore;

  /// P2-033 — Structured explanation of how the score was built. Used by the
  /// "Why we recommend this" chip on POI tiles and detail sheets.
  RankingExplanation explain(
    Poi poi,
    UserPreferenceVector v, {
    double? currentPositionKm,
  }) =>
      _evaluate(poi, v, currentPositionKm: currentPositionKm);

  // ── Single source of truth for both score() and explain() ──────────────────

  RankingExplanation _evaluate(
    Poi poi,
    UserPreferenceVector v, {
    double? currentPositionKm,
  }) {
    var total = 0.0;
    final reasons = <RankingReason>[];

    // Quality — rating (0–1) × confidence (saturating with review count).
    final ratingNorm = (poi.rating / 5.0).clamp(0.0, 1.0);
    final confidence = poi.reviewCount / (poi.reviewCount + 20);
    final qualityScore =
        v.qualityWeight * ratingNorm * (0.5 + 0.5 * confidence);
    total += qualityScore;
    // Only call out quality as a *reason* when it's actually high — a 2-star
    // place getting a 0.3 quality contribution shouldn't explain itself as
    // "highly rated".
    if (poi.rating >= 4.0 && qualityScore > 0.5) {
      reasons.add(RankingReason(
        kind: RankingReasonKind.quality,
        label: '${poi.rating.toStringAsFixed(1)}★ '
            '${poi.reviewCount > 0 ? "from ${poi.reviewCount} reviews" : ""}'
                .trim(),
        weight: qualityScore,
        icon: Icons.star_rounded,
      ));
    }

    // Proximity — smooth decay over ~25 km of "ahead" distance.
    final d = poi.distanceAlongRouteKm;
    if (d != null) {
      final ahead = currentPositionKm != null ? d - currentPositionKm : d;
      if (ahead >= 0) {
        final proximityScore =
            v.proximityWeight * (1.0 / (1.0 + ahead / 25.0));
        total += proximityScore;
        if (ahead <= 30) {
          reasons.add(RankingReason(
            kind: RankingReasonKind.proximity,
            label: '${ahead.toStringAsFixed(1)} km away on your route',
            weight: proximityScore,
            icon: Icons.route_outlined,
          ));
        }
      }
    }

    // Openness.
    if (poi.openNow == true) {
      total += v.opennessWeight;
      reasons.add(RankingReason(
        kind: RankingReasonKind.openNow,
        label: 'Open now',
        weight: v.opennessWeight,
        icon: Icons.schedule_outlined,
      ));
    }

    // Dietary (pure veg).
    if (v.dietaryWeight > 0 && _isVeg(poi)) {
      total += v.dietaryWeight;
      reasons.add(RankingReason(
        kind: RankingReasonKind.dietary,
        label: 'Pure veg',
        weight: v.dietaryWeight,
        icon: Icons.eco_outlined,
      ));
    }

    // Family-friendly.
    if (v.familyWeight > 0 &&
        _attrTrue(poi, const ['family_friendly', 'family', 'kids'])) {
      total += v.familyWeight;
      reasons.add(RankingReason(
        kind: RankingReasonKind.family,
        label: 'Family-friendly',
        weight: v.familyWeight,
        icon: Icons.family_restroom_outlined,
      ));
    }

    // Women-safe.
    if (v.womenSafeWeight > 0 &&
        _attrTrue(poi, const ['women_safe', 'women_friendly'])) {
      total += v.womenSafeWeight;
      reasons.add(RankingReason(
        kind: RankingReasonKind.womenSafe,
        label: 'Reported women-safe',
        weight: v.womenSafeWeight,
        icon: Icons.shield_outlined,
      ));
    }

    // Pet-friendly.
    if (v.petWeight > 0 && _attrTrue(poi, const ['pet_friendly', 'pets'])) {
      total += v.petWeight;
      reasons.add(RankingReason(
        kind: RankingReasonKind.pet,
        label: 'Pet-friendly',
        weight: v.petWeight,
        icon: Icons.pets_outlined,
      ));
    }

    // Scenic / tourist categories.
    if (v.scenicWeight > 0 &&
        (poi.category == PoiCategory.scenic ||
            poi.category == PoiCategory.tourist)) {
      total += v.scenicWeight;
      reasons.add(RankingReason(
        kind: RankingReasonKind.scenic,
        label: 'Scenic spot',
        weight: v.scenicWeight,
        icon: Icons.landscape_outlined,
      ));
    }

    // Budget match via Google price level.
    final budgetScore = v.budgetWeight * _budgetMatch(poi, v);
    total += budgetScore;
    if (budgetScore > 0.4) {
      reasons.add(RankingReason(
        kind: RankingReasonKind.budget,
        label: 'Matches your ${v.budgetTier.label.toLowerCase()} budget',
        weight: budgetScore,
        icon: Icons.payments_outlined,
      ));
    }

    // Fuel-brand affinity (fuel POIs only).
    if (poi.category == PoiCategory.fuel && v.brandWeights.isNotEmpty) {
      final lowerName = poi.name.toLowerCase();
      for (final entry in v.brandWeights.entries) {
        if (lowerName.contains(entry.key.label.toLowerCase())) {
          total += entry.value;
          reasons.add(RankingReason(
            kind: RankingReasonKind.fuelBrand,
            label: 'You prefer ${entry.key.label}',
            weight: entry.value,
            icon: Icons.local_gas_station_outlined,
          ));
          break;
        }
      }
    }

    return RankingExplanation(totalScore: total, reasons: reasons);
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
