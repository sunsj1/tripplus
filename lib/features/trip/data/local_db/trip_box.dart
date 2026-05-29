import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripplus/features/trip/domain/models/trip.dart';

/// Thin wrapper around the Hive `active_trip` box.
///
/// We store at most one trip at a time under the key [_key].
/// The value is a JSON-encoded [Trip] stored as a dynamic map.
class TripBox {
  TripBox._();

  static const String boxName = 'active_trip';
  static const String _key = 'current';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  /// Reads the persisted trip. Returns null if the box is empty.
  static Trip? read() {
    final raw = _box.get(_key);
    if (raw == null) return null;
    try {
      final map = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : Map<String, dynamic>.from(raw as Map);
      return Trip.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Persists [trip] to Hive.
  static Future<void> save(Trip trip) =>
      _box.put(_key, jsonEncode(trip.toJson()));

  /// Clears any stored trip.
  static Future<void> clear() => _box.delete(_key);
}
