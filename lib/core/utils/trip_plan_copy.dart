import 'package:flutter/material.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';

/// User-facing strings and icons that depend on [VehicleType].
class TripPlanCopy {
  TripPlanCopy._();

  static bool isEv(VehicleType? type) => type == VehicleType.ev;

  static String planSubtitle(VehicleType? type) {
    switch (type) {
      case VehicleType.ev:
        return 'Plan your EV journey with charging stops\nand corridor-aware alerts along the route.';
      case VehicleType.bike:
        return 'Plan a bike-friendly highway route with stops\nthat match your food and safety preferences.';
      case VehicleType.diesel:
        return 'Plan your diesel trip with fuel stops, tolls,\nand stops that match your preferences.';
      case VehicleType.petrol:
      case null:
        return 'Plan your road trip with fuel stops, tolls,\nand stops that match your preferences.';
    }
  }

  static String howItWorksStep3Title(VehicleType? type) {
    if (isEv(type)) return 'Find\nChargers';
    if (type == VehicleType.bike) return 'Pick\nStops';
    return 'Find\nStops';
  }

  static IconData howItWorksStep3Icon(VehicleType? type) {
    if (isEv(type)) return Icons.ev_station_outlined;
    return Icons.place_outlined;
  }

  static String calculatingTitle(VehicleType? type) {
    if (isEv(type)) return 'Analyzing route for\ncharging coverage…';
    return 'Building your\ncorridor plan…';
  }

  static String calculatingSubtitle(VehicleType? type, String from, String to) {
    if (isEv(type)) {
      return 'Finding chargers between $from and $to';
    }
    return 'Mapping $from → $to with your trip preferences';
  }

  static String summaryStopsLabel(VehicleType? type, int count) {
    if (!isEv(type)) return '$count suggested stops';
    return '$count chargers';
  }

  static IconData summaryStopsIcon(VehicleType? type) {
    if (isEv(type)) return Icons.ev_station_outlined;
    return Icons.place_outlined;
  }
}

/// One active trip preference shown on the route timeline.
class PreferenceTimelineItem {
  const PreferenceTimelineItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.accent,
    required this.hint,
    this.searchCategory,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color accent;
  final String hint;

  /// Primary POI category searched along the route corridor (5 km). Null when
  /// counts come from the EV station list instead (fast chargers).
  final PoiCategory? searchCategory;
}

extension UserPreferencesTimelineX on UserPreferences {
  /// Active preferences for timeline chips — excludes EV-only flags when [forEv] is false.
  List<PreferenceTimelineItem> timelineItems({required bool forEv}) {
    final items = <PreferenceTimelineItem>[];
    if (pureVeg) {
      items.add(
        const PreferenceTimelineItem(
          id: 'pure_veg',
          label: 'Pure veg',
          icon: Icons.eco,
          accent: Color(0xFF2E7D32),
          hint: 'Pure-veg food stops near your corridor',
          searchCategory: PoiCategory.pureVeg,
        ),
      );
    }
    if (familyMode) {
      items.add(
        const PreferenceTimelineItem(
          id: 'family',
          label: 'Family friendly',
          icon: Icons.family_restroom,
          accent: Color(0xFF1565C0),
          hint: 'Kid-friendly stops, seating & washrooms',
          searchCategory: PoiCategory.kidsStop,
        ),
      );
    }
    if (womenSafe) {
      items.add(
        const PreferenceTimelineItem(
          id: 'women_safe',
          label: 'Women safe',
          icon: Icons.shield_outlined,
          accent: Color(0xFF6A1B9A),
          hint: 'Hotels & staffed stops with safer access',
          searchCategory: PoiCategory.hotel,
        ),
      );
    }
    if (forEv && fastChargersOnly) {
      items.add(
        const PreferenceTimelineItem(
          id: 'fast_chargers',
          label: 'Fast chargers',
          icon: Icons.bolt,
          accent: Color(0xFFF57F17),
          hint: 'DC fast-charge options on this corridor',
        ),
      );
    }
    if (nightSafe) {
      items.add(
        const PreferenceTimelineItem(
          id: 'night_safe',
          label: 'Night safe',
          icon: Icons.nightlight_round,
          accent: Color(0xFF283593),
          hint: 'Lit stops & hotels for night breaks',
          searchCategory: PoiCategory.hotel,
        ),
      );
    }
    if (scenicRoute) {
      items.add(
        const PreferenceTimelineItem(
          id: 'scenic',
          label: 'Scenic',
          icon: Icons.landscape,
          accent: Color(0xFF00695C),
          hint: 'Viewpoints & photo-friendly breaks',
          searchCategory: PoiCategory.scenic,
        ),
      );
    }
    if (petFriendly) {
      items.add(
        const PreferenceTimelineItem(
          id: 'pet_friendly',
          label: 'Pet friendly',
          icon: Icons.pets,
          accent: Color(0xFF5D4037),
          hint: 'Pet-tolerant cafes & rest stops',
          searchCategory: PoiCategory.restaurant,
        ),
      );
    }
    return items;
  }
}
