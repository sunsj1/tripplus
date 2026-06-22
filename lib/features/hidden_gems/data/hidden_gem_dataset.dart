import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:journeyplus/features/hidden_gems/domain/hidden_gem.dart';

/// P2-060 — Loads the bundled `corridor_gems.json` asset and parses it into a
/// list of [HiddenGemCorridor]s. Cached in-memory after the first load — the
/// dataset doesn't change at runtime.
class HiddenGemDataset {
  HiddenGemDataset._();

  static const _assetPath = 'assets/hidden_gems/corridor_gems.json';

  static List<HiddenGemCorridor>? _cache;

  static Future<List<HiddenGemCorridor>> load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['corridors'] as List<dynamic>? ?? const [])
        .map((c) => HiddenGemCorridor.fromJson(c as Map<String, dynamic>))
        .toList();
    _cache = list;
    return list;
  }
}
