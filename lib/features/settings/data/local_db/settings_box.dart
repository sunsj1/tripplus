import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:journeyplus/features/settings/domain/app_settings.dart';

/// P2-053 — Hive persistence wrapper for [AppSettings].
///
/// One document, JSON-encoded under [_key]. Mirrors the pattern used by
/// [TripBox] / [CorridorCacheBox] so the file reads consistently.
class SettingsBox {
  static const boxName = 'app_settings';
  static const _key = 'current';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  static AppSettings read() {
    final raw = _box.get(_key);
    if (raw == null) return const AppSettings();
    try {
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      return AppSettings.fromJson(map);
    } catch (_) {
      return const AppSettings();
    }
  }

  static Future<void> save(AppSettings settings) async {
    await _box.put(_key, jsonEncode(settings.toJson()));
  }
}
