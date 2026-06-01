import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/features/personalization/domain/poi_ranker.dart';
import 'package:tripplus/features/personalization/domain/user_preference_vector.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_providers.dart';

/// P2-010 — Live preference vector derived from the saved profile.
/// Rebuilds whenever the user's preferences change.
final userPreferenceVectorProvider = Provider<UserPreferenceVector>((ref) {
  final prefs = ref.watch(profileControllerProvider).data.preferences;
  return UserPreferenceVector.fromPreferences(prefs);
});

/// P2-011 — Stateless ranker singleton.
final poiRankerProvider = Provider<PoiRanker>((ref) => const PoiRanker());
