import 'package:tripplus/core/domain/poi.dart';

/// Stable identity for a [Poi] in the community-reports collection. The same
/// physical POI shares pulses across users and route variations.
///
/// Format: `poi_<sanitized poi.id>`. The `poi_` prefix prevents collisions
/// with station keys (which use `u_…` / `ocm_…` / `sid_…`).
///
/// Used as the `targetKey` field on community reports when
/// `targetType == CommunityTargetType.poi` (see `P1-010`, ADR-005).
String communityPoiKey(Poi poi) {
  if (poi.id.trim().isNotEmpty) {
    return _sanitize('poi_${poi.id}');
  }
  // Defensive fallback: should never trigger because [Poi.id] is required,
  // but if a future source skips id generation we still emit a stable key
  // from coordinates + category.
  final lat = poi.latitude.toStringAsFixed(5);
  final lng = poi.longitude.toStringAsFixed(5);
  return _sanitize('poi_${poi.category.wireValue}_${lat}_$lng');
}

String _sanitize(String raw) {
  var s = raw.replaceAll(RegExp(r'[/\s.]'), '_');
  if (s.length > 800) s = s.substring(0, 800);
  return s;
}
