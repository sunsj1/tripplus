import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';

/// The type of a single stop on the Smart Trip Timeline.
enum TimelineStopType {
  origin,
  preference,
  chargingStation,
  fuelStation,
  destination,
}

/// A single node on the Smart Trip Timeline.
///
/// Deliberately a plain Dart class (not Freezed) — this is UI-only state
/// that is rebuilt from [PlanResult] on every hot-reload and never persisted.
class TimelineStop {
  const TimelineStop({
    required this.type,
    required this.label,
    required this.distanceFromStartKm,
    this.distanceToNextKm,
    this.subtitle,
    this.pinned = true,
    this.connectorCount,
    this.hasFastCharge,
    this.accentColor,
    this.iconOverride,
  });

  final TimelineStopType type;

  /// Primary display label (station name, "Mumbai", "Pune", etc.).
  final String label;

  /// Cumulative distance from origin (km).
  final double distanceFromStartKm;

  /// Distance to the next stop (km). Null for destination.
  final double? distanceToNextKm;

  /// Optional secondary line (e.g. "CCS2 · Fast" or address snippet).
  final String? subtitle;

  /// Whether this stop is pinned (user-required) or just a suggestion.
  ///
  /// Origin and destination are always pinned and the toggle is disabled.
  final bool pinned;

  /// For charging/fuel stops — number of connectors / pumps.
  final int? connectorCount;

  /// Fast-charge capable (EV stations only).
  final bool? hasFastCharge;

  /// Optional per-stop accent (preferences use distinct colors).
  final Color? accentColor;
  final IconData? iconOverride;

  // ---------------------------------------------------------------------------
  // Presentation helpers
  // ---------------------------------------------------------------------------

  IconData get icon => iconOverride ?? switch (type) {
        TimelineStopType.origin => Icons.trip_origin,
        TimelineStopType.preference => Icons.bookmark_outline,
        TimelineStopType.chargingStation => Icons.ev_station,
        TimelineStopType.fuelStation => Icons.local_gas_station,
        TimelineStopType.destination => Icons.flag_rounded,
      };

  Color iconColor(Color primary, Color success, Color warning) {
    if (accentColor != null) return accentColor!;
    return switch (type) {
      TimelineStopType.origin => primary,
      TimelineStopType.preference => AppColors.accentBlue,
      TimelineStopType.chargingStation => success,
      TimelineStopType.fuelStation => AppColors.accentAmber,
      TimelineStopType.destination => warning,
    };
  }

  bool get isEndpoint =>
      type == TimelineStopType.origin ||
      type == TimelineStopType.destination;

  TimelineStop copyWith({bool? pinned}) => TimelineStop(
        type: type,
        label: label,
        distanceFromStartKm: distanceFromStartKm,
        distanceToNextKm: distanceToNextKm,
        subtitle: subtitle,
        pinned: pinned ?? this.pinned,
        connectorCount: connectorCount,
        hasFastCharge: hasFastCharge,
        accentColor: accentColor,
        iconOverride: iconOverride,
      );
}
