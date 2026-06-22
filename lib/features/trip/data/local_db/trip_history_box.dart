import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';

/// Local-only archive of completed trips. Stores route labels, estimates, and
/// timestamps — never GPS coordinates or location trails.
class TripHistoryBox {
  TripHistoryBox._();

  static const String boxName = 'trip_history';
  static const String _listKey = 'entries';
  static const int _maxEntries = 100;

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  static List<Trip> readAll() {
    final raw = _box.get(_listKey);
    if (raw is! List) return [];
    final trips = <Trip>[];
    for (final item in raw) {
      try {
        final map = item is String
            ? jsonDecode(item) as Map<String, dynamic>
            : Map<String, dynamic>.from(item as Map);
        trips.add(Trip.fromJson(map));
      } catch (_) {
        // skip corrupt entry
      }
    }
    trips.sort(
      (a, b) => (b.completedAt ?? b.createdAt)
          .compareTo(a.completedAt ?? a.createdAt),
    );
    return trips;
  }

  static Future<void> append(Trip completedTrip) async {
    final existing = readAll();
    final next = [completedTrip, ...existing.where((t) => t.id != completedTrip.id)]
        .take(_maxEntries)
        .toList();
    await _box.put(
      _listKey,
      next.map((t) => jsonEncode(t.toJson())).toList(),
    );
  }

  static Future<void> clearAll() => _box.delete(_listKey);
}
