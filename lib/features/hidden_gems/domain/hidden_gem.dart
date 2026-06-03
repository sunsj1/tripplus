import 'package:flutter/material.dart';

/// P2-062 — Coarse classification for a hidden gem.
///
/// Tags overlay categories: a gem can be both `scenic` and `underrated`, but
/// it has exactly one [HiddenGemCategory].
enum HiddenGemCategory {
  food,
  scenic,
  specialty,
  other;

  static HiddenGemCategory fromWire(String? wire) {
    switch (wire) {
      case 'food':
        return HiddenGemCategory.food;
      case 'scenic':
        return HiddenGemCategory.scenic;
      case 'specialty':
        return HiddenGemCategory.specialty;
      default:
        return HiddenGemCategory.other;
    }
  }

  String get label {
    switch (this) {
      case HiddenGemCategory.food:
        return 'Food';
      case HiddenGemCategory.scenic:
        return 'Scenic';
      case HiddenGemCategory.specialty:
        return 'Specialty';
      case HiddenGemCategory.other:
        return 'Stop';
    }
  }

  IconData get icon {
    switch (this) {
      case HiddenGemCategory.food:
        return Icons.restaurant_outlined;
      case HiddenGemCategory.scenic:
        return Icons.landscape_outlined;
      case HiddenGemCategory.specialty:
        return Icons.auto_awesome_outlined;
      case HiddenGemCategory.other:
        return Icons.place_outlined;
    }
  }

  Color get accent {
    switch (this) {
      case HiddenGemCategory.food:
        return const Color(0xFFE8762D);
      case HiddenGemCategory.scenic:
        return const Color(0xFF1B5E20);
      case HiddenGemCategory.specialty:
        return const Color(0xFF7C3AED);
      case HiddenGemCategory.other:
        return const Color(0xFF607D8B);
    }
  }
}

/// P2-062 — Layered tags. A gem can carry multiple.
enum HiddenGemTag {
  food,
  scenic,
  specialty,
  underrated;

  static HiddenGemTag? tryParse(String wire) {
    for (final t in HiddenGemTag.values) {
      if (t.name == wire) return t;
    }
    return null;
  }

  String get label {
    switch (this) {
      case HiddenGemTag.food:
        return 'Food';
      case HiddenGemTag.scenic:
        return 'Scenic';
      case HiddenGemTag.specialty:
        return 'Specialty';
      case HiddenGemTag.underrated:
        return 'Underrated';
    }
  }
}

/// P2-060 — One curated gem entry parsed from `assets/hidden_gems/...`.
class HiddenGem {
  const HiddenGem({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.category,
    required this.description,
    required this.tags,
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
  final HiddenGemCategory category;
  final String description;
  final List<HiddenGemTag> tags;

  factory HiddenGem.fromJson(Map<String, dynamic> json) {
    final rawTags = (json['tags'] as List<dynamic>? ?? const []);
    return HiddenGem(
      id: json['id'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      category: HiddenGemCategory.fromWire(json['category'] as String?),
      description: json['description'] as String? ?? '',
      tags: rawTags
          .map((e) => HiddenGemTag.tryParse(e.toString()))
          .whereType<HiddenGemTag>()
          .toList(),
    );
  }
}

/// P2-060 — One curated corridor with waypoints (for matching) and gems.
class HiddenGemCorridor {
  const HiddenGemCorridor({
    required this.name,
    required this.waypoints,
    required this.gems,
    this.matchRadiusKm = 15,
  });

  final String name;
  final List<({double lat, double lng})> waypoints;
  final List<HiddenGem> gems;

  /// Max perpendicular distance from the route polyline for a waypoint to
  /// count as a "hit". Slightly more generous than [TollCorridor]'s 12 km —
  /// gems may be a short detour from the highway proper.
  final double matchRadiusKm;

  factory HiddenGemCorridor.fromJson(Map<String, dynamic> json) {
    return HiddenGemCorridor(
      name: json['name'] as String,
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((w) => (
                lat: (w['lat'] as num).toDouble(),
                lng: (w['lng'] as num).toDouble(),
              ))
          .toList(),
      gems: (json['gems'] as List<dynamic>)
          .map((g) => HiddenGem.fromJson(g as Map<String, dynamic>))
          .toList(),
    );
  }
}
