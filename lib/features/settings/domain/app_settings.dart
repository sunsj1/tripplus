import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// P2-053 — Distance/speed display preference.
enum DistanceUnit {
  @JsonValue('km')
  km,
  @JsonValue('mi')
  miles;

  String get label => this == DistanceUnit.km ? 'Kilometres' : 'Miles';
}

/// P2-053 — App-wide settings persisted in Hive.
///
/// Only behavioural / display knobs live here. Vehicle and trip preferences
/// stay on the user's profile (see `UserPreferences`). This split keeps
/// per-device toggles like "mute night alerts on this phone" from polluting
/// the cloud-synced profile.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(DistanceUnit.km) DistanceUnit distanceUnit,

    /// Master switch — when false, no banners, no system notifications.
    @Default(true) bool alertsEnabled,

    /// Per-type mute set (wire values from [AlertType]). Listed types are
    /// suppressed even when [alertsEnabled] is true.
    @Default(<String>[]) List<String> mutedAlertTypes,

    /// Whether system notifications (in addition to in-app banners) fire.
    @Default(true) bool systemNotificationsEnabled,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

extension AppSettingsX on AppSettings {
  bool isMuted(AlertType type) {
    if (!alertsEnabled) return true;
    final wire = _alertTypeWire(type);
    return mutedAlertTypes.contains(wire);
  }

  AppSettings toggleMute(AlertType type) {
    final wire = _alertTypeWire(type);
    final next = List<String>.from(mutedAlertTypes);
    if (next.contains(wire)) {
      next.remove(wire);
    } else {
      next.add(wire);
    }
    return copyWith(mutedAlertTypes: next);
  }
}

/// Mirror of [AlertType] JsonValue strings. Kept private so callers go through
/// [AppSettingsX] rather than handling raw wire values.
String _alertTypeWire(AlertType t) {
  switch (t) {
    case AlertType.fuelLow:
      return 'fuel_low';
    case AlertType.evGap:
      return 'ev_gap';
    case AlertType.foodWindow:
      return 'food_window';
    case AlertType.ghat:
      return 'ghat';
    case AlertType.night:
      return 'night';
    case AlertType.fatigue:
      return 'fatigue';
    case AlertType.weather:
      return 'weather';
  }
}
