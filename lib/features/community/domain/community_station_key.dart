import 'package:tripplus/features/charging/domain/models/charging_station.dart';

/// Stable key so the same physical station shares community data across users,
/// routes, and list/detail screens.
///
/// - Prefer OCM/Google [ChargingStation.uuid] when non-empty.
/// - Otherwise fall back to OCM numeric id + rounded geo (handles duplicate names).
String communityStationKey(ChargingStation station) {
  final u = station.uuid?.trim();
  if (u != null && u.isNotEmpty) {
    return _sanitizeKey('u_$u');
  }
  final lat = station.latitude.toStringAsFixed(5);
  final lng = station.longitude.toStringAsFixed(5);
  return _sanitizeKey('ocm_${station.id}_${lat}_$lng');
}

String _sanitizeKey(String raw) {
  var s = raw.replaceAll(RegExp(r'[/\s.]'), '_');
  if (s.length > 800) s = s.substring(0, 800);
  return s;
}
