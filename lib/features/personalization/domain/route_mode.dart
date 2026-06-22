import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/poi.dart';

/// P2-020 / P2-021 / P2-022 — Trip "mode" overlay.
///
/// A single, mutually-exclusive lens applied on top of personalized ranking.
/// Each mode filters category lists, highlights matching POIs with a badge,
/// and (for Bike) reorders the relevant POI categories.
///
/// `off` is the default — no overlay, lists rank purely by the user's
/// long-lived profile preferences.
enum RouteMode {
  off,
  family,
  womenSafe,
  bike;

  String get label {
    switch (this) {
      case RouteMode.off:
        return 'Standard';
      case RouteMode.family:
        return 'Family';
      case RouteMode.womenSafe:
        return 'Women-Safe';
      case RouteMode.bike:
        return 'Bike';
    }
  }

  IconData get icon {
    switch (this) {
      case RouteMode.off:
        return Icons.tune_outlined;
      case RouteMode.family:
        return Icons.family_restroom_outlined;
      case RouteMode.womenSafe:
        return Icons.shield_outlined;
      case RouteMode.bike:
        return Icons.two_wheeler_outlined;
    }
  }

  /// Color used for the mode's badge / chip when active.
  Color get accent {
    switch (this) {
      case RouteMode.off:
        return const Color(0xFF9E9E9E);
      case RouteMode.family:
        return const Color(0xFFE8762D); // warm amber
      case RouteMode.womenSafe:
        return const Color(0xFF7C3AED); // shield purple
      case RouteMode.bike:
        return const Color(0xFF0F766E); // teal-deep
    }
  }
}

extension RouteModeFilters on RouteMode {
  /// Categories that are *always* relevant for this mode, used both to keep
  /// safety-critical categories visible and to bias Discovery in [bike] mode.
  Set<PoiCategory> get focusedCategories {
    switch (this) {
      case RouteMode.off:
        return const {};
      case RouteMode.family:
        return const {
          PoiCategory.hotel,
          PoiCategory.restaurant,
          PoiCategory.pureVeg,
          PoiCategory.washroom,
          PoiCategory.medical,
          PoiCategory.kidsStop,
          PoiCategory.scenic,
          PoiCategory.temple,
          PoiCategory.fuel,
        };
      case RouteMode.womenSafe:
        return const {
          PoiCategory.hotel,
          PoiCategory.fuel,
          PoiCategory.police,
          PoiCategory.medical,
          PoiCategory.washroom,
          PoiCategory.restaurant,
        };
      case RouteMode.bike:
        return const {
          PoiCategory.mechanic,
          PoiCategory.fuel,
          PoiCategory.medical,
          PoiCategory.washroom,
          PoiCategory.parking,
          PoiCategory.hotel,
          PoiCategory.cafe,
        };
    }
  }

  /// POI attribute keys whose presence/truth qualifies a POI for this mode.
  /// Empty for [off].
  List<String> get attributeKeys {
    switch (this) {
      case RouteMode.off:
        return const [];
      case RouteMode.family:
        return const ['family_friendly', 'family', 'kids', 'baby_friendly'];
      case RouteMode.womenSafe:
        return const ['women_safe', 'women_friendly'];
      case RouteMode.bike:
        return const ['bike_friendly', 'two_wheeler'];
    }
  }
}
