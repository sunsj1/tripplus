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
  if (station.id > 0) {
    return _sanitizeKey('ocm_${station.id}_${lat}_$lng');
  }

  // Fallback for stations with missing ids: normalized identity components
  // reduce accidental key drift across source variations.
  final name = _normalize(station.name);
  final operator = _normalize(station.operatorName ?? '');
  return _sanitizeKey('sid_${name}_${operator}_${lat}_$lng');
}

String _sanitizeKey(String raw) {
  var s = raw.replaceAll(RegExp(r'[/\s.]'), '_');
  if (s.length > 800) s = s.substring(0, 800);
  return s;
}

String _normalize(String input) {
  return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').trim();
}
