import 'package:journeyplus/core/domain/poi.dart';

/// Shared ahead-of-driver trim for corridor lists (POIs, stations, gems).
///
/// [hysteresisKm] keeps items just behind the projection threshold so GPS
/// jitter does not flicker the list at the pass-by boundary.
class CorridorAhead {
  CorridorAhead._();

  /// Default hysteresis — ~300 m behind still counts as “ahead” for list UX.
  static const double hysteresisKm = 0.3;

  /// POIs with a known route distance still ahead of [currentKm].
  ///
  /// Unknown-distance items are excluded from an explicit ahead list so we
  /// never label unprojected stops as “Ahead on your route”.
  static List<Poi> filterPois(
    List<Poi> pois,
    double currentKm, {
    double hysteresisKm = CorridorAhead.hysteresisKm,
  }) {
    final threshold = currentKm - hysteresisKm;
    return pois.where((p) {
      final km = p.distanceAlongRouteKm;
      return km != null && km > threshold;
    }).toList()
      ..sort(
        (a, b) => (a.distanceAlongRouteKm ?? 0).compareTo(
          b.distanceAlongRouteKm ?? 0,
        ),
      );
  }

  /// Generic filter for any item that exposes route distance in km.
  static List<T> filterByKm<T>(
    List<T> items,
    double? Function(T item) distanceKmOf,
    double currentKm, {
    double hysteresisKm = CorridorAhead.hysteresisKm,
  }) {
    final threshold = currentKm - hysteresisKm;
    final ahead = items.where((item) {
      final km = distanceKmOf(item);
      return km != null && km > threshold;
    }).toList();
    ahead.sort((a, b) {
      final da = distanceKmOf(a) ?? 0;
      final db = distanceKmOf(b) ?? 0;
      return da.compareTo(db);
    });
    return ahead;
  }

  /// Whether [itemKm] is still considered ahead of [currentKm].
  static bool isAhead(
    double itemKm,
    double currentKm, {
    double hysteresisKm = CorridorAhead.hysteresisKm,
  }) {
    return itemKm > currentKm - hysteresisKm;
  }
}
