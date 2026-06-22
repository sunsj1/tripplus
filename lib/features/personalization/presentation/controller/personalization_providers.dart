import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/fuel_brand.dart';
import 'package:journeyplus/features/personalization/domain/poi_ranker.dart';
import 'package:journeyplus/features/personalization/domain/user_preference_vector.dart';
import 'package:journeyplus/features/personalization/presentation/controller/brand_affinity_controller.dart';
import 'package:journeyplus/features/profile/presentation/controller/profile_providers.dart';

/// P2-010 — Live preference vector derived from the saved profile.
///
/// P2-013 — Blends in learned brand-affinity weights on top of the user's
/// explicit selections. Explicit > learned (cap multiplier at 1.5x) so a brand
/// the user *chose* always outranks one we only learned they tap a lot.
final userPreferenceVectorProvider = Provider<UserPreferenceVector>((ref) {
  final prefs = ref.watch(profileControllerProvider).data.preferences;
  final learned = ref.watch(brandAffinityControllerProvider);
  final base = UserPreferenceVector.fromPreferences(prefs);

  if (learned.isEmpty) return base;

  // Normalise learned scores to [0, 1.5] so they sit alongside the 2.0 weight
  // explicit selections get without overshadowing them.
  final maxLearned = learned.values.fold<double>(0, (a, b) => b > a ? b : a);
  final scale = maxLearned <= 0 ? 0.0 : 1.5 / maxLearned;
  final learnedWeights = <FuelBrand, double>{
    for (final entry in learned.entries) entry.key: entry.value * scale,
  };

  final mergedBrandWeights = <FuelBrand, double>{...base.brandWeights};
  for (final entry in learnedWeights.entries) {
    final existing = mergedBrandWeights[entry.key] ?? 0;
    if (entry.value > existing) {
      mergedBrandWeights[entry.key] = entry.value;
    }
  }

  return UserPreferenceVector(
    qualityWeight: base.qualityWeight,
    proximityWeight: base.proximityWeight,
    opennessWeight: base.opennessWeight,
    dietaryWeight: base.dietaryWeight,
    familyWeight: base.familyWeight,
    womenSafeWeight: base.womenSafeWeight,
    budgetWeight: base.budgetWeight,
    petWeight: base.petWeight,
    scenicWeight: base.scenicWeight,
    brandWeights: mergedBrandWeights,
    budgetTier: base.budgetTier,
  );
});

/// P2-011 — Stateless ranker singleton.
final poiRankerProvider = Provider<PoiRanker>((ref) => const PoiRanker());
