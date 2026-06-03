import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/fuel_brand.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/features/personalization/data/brand_affinity_box.dart';

/// P2-013 — Learned affinity weights for fuel brands.
///
/// We bump a brand's score every time the user takes an action that signals
/// preference for it: opening its POI detail sheet (`view`) or submitting a
/// community pulse on it (`pulse`). The score then feeds [UserPreferenceVector]
/// on the next rebuild, so the Best-Match sort surfaces those brands first.
class BrandAffinityController extends StateNotifier<Map<FuelBrand, double>> {
  BrandAffinityController() : super(BrandAffinityBox.read());

  /// Score bump per signal type. Tuned so a single submission outweighs ~5
  /// idle views — pulses are deliberate signal, views can be accidental.
  static const _viewWeight = 1.0;
  static const _pulseWeight = 5.0;

  /// Soft ceiling so a runaway brand can't drown out everything else.
  static const _maxScore = 50.0;

  /// Records an interaction. `signal == 'view'` or `'pulse'`. Anything else is
  /// ignored to keep callers honest.
  Future<void> registerInteraction({
    required Poi poi,
    required String signal,
  }) async {
    if (poi.category != PoiCategory.fuel) return;
    final brand = _detectBrand(poi);
    if (brand == null) return;

    final delta = switch (signal) {
      'view' => _viewWeight,
      'pulse' => _pulseWeight,
      _ => 0.0,
    };
    if (delta == 0) return;

    final next = Map<FuelBrand, double>.from(state);
    final current = next[brand] ?? 0.0;
    final updated = (current + delta).clamp(0.0, _maxScore);
    next[brand] = updated;

    state = next;
    await BrandAffinityBox.save(next);
  }

  /// Heuristic — Google Places rarely sets a structured brand on fuel POIs, so
  /// fall back to a case-insensitive name contains.
  static FuelBrand? _detectBrand(Poi poi) {
    final lower = poi.name.toLowerCase();
    for (final b in FuelBrand.values) {
      if (lower.contains(b.label.toLowerCase())) return b;
    }
    return null;
  }
}

final brandAffinityControllerProvider =
    StateNotifierProvider<BrandAffinityController, Map<FuelBrand, double>>(
  (ref) => BrandAffinityController(),
);
