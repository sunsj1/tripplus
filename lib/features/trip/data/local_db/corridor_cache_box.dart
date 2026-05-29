import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripplus/features/trip/domain/models/corridor_cache.dart';

/// P1-043 — Hive persistence wrapper for [CorridorCache].
///
/// Stores exactly one entry per box (key: [_key]).  The caller is responsible
/// for opening the box before first use (done in [main.dart]).
class CorridorCacheBox {
  static const boxName = 'corridor_cache';
  static const _key = 'current';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// Returns the cached corridor, or null if nothing is saved or the JSON
  /// cannot be decoded.
  static CorridorCache? read() {
    final raw = _box.get(_key);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      return CorridorCache.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  static Future<void> save(CorridorCache cache) async {
    await _box.put(_key, jsonEncode(cache.toJson()));
  }

  // ---------------------------------------------------------------------------
  // Delete
  // ---------------------------------------------------------------------------

  static Future<void> clear() => _box.delete(_key);

  // ---------------------------------------------------------------------------
  // Staleness eviction
  // ---------------------------------------------------------------------------

  /// Evicts the stored entry if it is older than [CorridorCache._maxAgeHours].
  static Future<void> evictIfStale() async {
    final cache = read();
    if (cache != null && cache.isStale) await clear();
  }
}
