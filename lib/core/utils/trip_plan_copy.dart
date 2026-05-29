import 'package:flutter/material.dart';
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
    required this.label,
    required this.icon,
    required this.accent,
    required this.hint,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final String hint;
}

extension UserPreferencesTimelineX on UserPreferences {
  /// Active preferences for timeline chips — excludes EV-only flags when [forEv] is false.
  List<PreferenceTimelineItem> timelineItems({required bool forEv}) {
    final items = <PreferenceTimelineItem>[];
    if (pureVeg) {
      items.add(
        const PreferenceTimelineItem(
          label: 'Pure veg',
          icon: Icons.eco,
          accent: Color(0xFF2E7D32),
          hint: 'Look for pure-veg dhabas & restaurants',
        ),
      );
    }
    if (familyMode) {
      items.add(
        const PreferenceTimelineItem(
          label: 'Family friendly',
          icon: Icons.family_restroom,
          accent: Color(0xFF1565C0),
          hint: 'Clean washrooms, seating, kid-friendly stops',
        ),
      );
    }
    if (womenSafe) {
      items.add(
        const PreferenceTimelineItem(
          label: 'Women safe',
          icon: Icons.shield_outlined,
          accent: Color(0xFF6A1B9A),
          hint: 'Well-lit, staffed stops with safer access',
        ),
      );
    }
    if (forEv && fastChargersOnly) {
      items.add(
        const PreferenceTimelineItem(
          label: 'Fast chargers',
          icon: Icons.bolt,
          accent: Color(0xFFF57F17),
          hint: 'Prioritize DC fast-charge along the corridor',
        ),
      );
    }
    if (nightSafe) {
      items.add(
        const PreferenceTimelineItem(
          label: 'Night safe',
          icon: Icons.nightlight_round,
          accent: Color(0xFF283593),
          hint: 'Prefer lit highways & trusted stop clusters',
        ),
      );
    }
    if (scenicRoute) {
      items.add(
        const PreferenceTimelineItem(
          label: 'Scenic',
          icon: Icons.landscape,
          accent: Color(0xFF00695C),
          hint: 'Scenic viewpoints & photo-friendly breaks',
        ),
      );
    }
    if (petFriendly) {
      items.add(
        const PreferenceTimelineItem(
          label: 'Pet friendly',
          icon: Icons.pets,
          accent: Color(0xFF5D4037),
          hint: 'Stops that tolerate pets on leash',
        ),
      );
    }
    return items;
  }
}
