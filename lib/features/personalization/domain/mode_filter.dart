import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/features/personalization/domain/route_mode.dart';

/// P2-020 / 021 / 022 — Pure filtering logic for active [RouteMode].
///
/// The filter is *intentionally permissive*: it never returns an empty list if
/// the input wasn't already empty. If no POI in the input qualifies for the
/// mode's strict criteria, we fall back to the mode's focused categories so
/// the user still sees *something* relevant. Mode-qualified POIs are still
/// returned first; the rest follow.
///
/// Strict criteria per mode:
/// - [RouteMode.family]   → attributes match OR category in focused set
/// - [RouteMode.womenSafe] → attributes match OR category in focused set
/// - [RouteMode.bike]     → attributes match OR category in focused set
/// - [RouteMode.off]      → identity (no filtering)
List<Poi> applyRouteModeFilter(List<Poi> pois, RouteMode mode) {
  if (mode == RouteMode.off || pois.isEmpty) return pois;

  final focused = mode.focusedCategories;
  final attrKeys = mode.attributeKeys;

  final qualified = <Poi>[];
  final fallback = <Poi>[];

  for (final poi in pois) {
    final attrMatch = attrKeys.any((k) => poi.attributes[k] == true);
    final categoryMatch = focused.contains(poi.category);

    if (attrMatch) {
      qualified.add(poi);
    } else if (categoryMatch) {
      fallback.add(poi);
    }
  }

  // Strict matches first, then category-only fallback. Drop POIs that didn't
  // match either — they're irrelevant to the active mode.
  return [...qualified, ...fallback];
}
