import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:journeyplus/core/domain/fuel_brand.dart';

/// P2-013 — Hive-backed score map for fuel-brand affinity.
///
/// Stores a `Map<wireValue, double>` under [_key] so the schema can grow
/// brands without migration. Pure local state — no cloud sync, no PII.
class BrandAffinityBox {
  static const boxName = 'brand_affinity';
  static const _key = 'scores';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  static Map<FuelBrand, double> read() {
    final raw = _box.get(_key);
    if (raw is! String || raw.isEmpty) return const {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final out = <FuelBrand, double>{};
      for (final entry in map.entries) {
        final brand = FuelBrandX.tryParse(entry.key);
        final value = (entry.value as num?)?.toDouble() ?? 0.0;
        if (brand != null && value > 0) out[brand] = value;
      }
      return out;
    } catch (_) {
      return const {};
    }
  }

  static Future<void> save(Map<FuelBrand, double> scores) async {
    final encoded = <String, double>{
      for (final entry in scores.entries) entry.key.wireValue: entry.value,
    };
    await _box.put(_key, jsonEncode(encoded));
  }
}
