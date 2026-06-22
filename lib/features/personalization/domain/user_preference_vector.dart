import 'package:journeyplus/core/domain/fuel_brand.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';

/// P2-010 — Numeric ranking weights derived from a user's [UserPreferences].
///
/// This is the bridge between *explicit* toggles (pure veg, family mode, …) and
/// the [PoiRanker]'s scoring math. Each weight says "how much does this signal
/// matter when ranking a POI". Base weights (quality/proximity/openness) are
/// always on; preference weights are zero unless the user opted in.
///
/// [brandWeights] and the `behavioral*` hooks leave room for P2-013
/// (brand-affinity learning) to blend learned weights on top without changing
/// the ranker.
class UserPreferenceVector {
  const UserPreferenceVector({
    required this.qualityWeight,
    required this.proximityWeight,
    required this.opennessWeight,
    required this.dietaryWeight,
    required this.familyWeight,
    required this.womenSafeWeight,
    required this.budgetWeight,
    required this.petWeight,
    required this.scenicWeight,
    required this.brandWeights,
    required this.budgetTier,
  });

  // ── Base signals (always active) ───────────────────────────────────────────
  final double qualityWeight;
  final double proximityWeight;
  final double opennessWeight;

  // ── Preference-gated signals (zero when the toggle is off) ─────────────────
  final double dietaryWeight; // pure veg
  final double familyWeight;
  final double womenSafeWeight;
  final double budgetWeight;
  final double petWeight;
  final double scenicWeight;

  /// Per-brand affinity for fuel POIs. Explicit selections seed this; P2-013
  /// will add learned weights.
  final Map<FuelBrand, double> brandWeights;

  /// Target budget tier for price-level matching.
  final BudgetTier budgetTier;

  /// True if any preference-gated signal is active — lets callers show a
  /// "personalized" affordance only when it actually changes the order.
  bool get hasActivePreferences =>
      dietaryWeight > 0 ||
      familyWeight > 0 ||
      womenSafeWeight > 0 ||
      petWeight > 0 ||
      scenicWeight > 0 ||
      brandWeights.isNotEmpty;

  factory UserPreferenceVector.fromPreferences(UserPreferences p) {
    return UserPreferenceVector(
      qualityWeight: 1.0,
      proximityWeight: 1.0,
      opennessWeight: 0.5,
      dietaryWeight: p.pureVeg ? 2.0 : 0.0,
      familyWeight: p.familyMode ? 1.5 : 0.0,
      womenSafeWeight: p.womenSafe ? 2.0 : 0.0,
      budgetWeight: 0.8,
      petWeight: p.petFriendly ? 1.5 : 0.0,
      scenicWeight: p.scenicRoute ? 1.0 : 0.0,
      brandWeights: {
        for (final b in p.selectedFuelBrands) b: 2.0,
      },
      budgetTier: p.budgetTier,
    );
  }
}
