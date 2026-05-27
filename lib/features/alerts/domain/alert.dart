import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

/// All rule categories the Alert Engine can fire.
/// Phase 1 wires `fuelLow`, `evGap`, `foodWindow`. Phase 2 adds the rest.
enum AlertType {
  @JsonValue('fuel_low')
  fuelLow,
  @JsonValue('ev_gap')
  evGap,
  @JsonValue('food_window')
  foodWindow,
  @JsonValue('ghat')
  ghat,
  @JsonValue('night')
  night,
  @JsonValue('fatigue')
  fatigue,
  @JsonValue('weather')
  weather,
}

extension AlertTypeX on AlertType {
  String get label {
    switch (this) {
      case AlertType.fuelLow:
        return 'Fuel low';
      case AlertType.evGap:
        return 'Charger gap';
      case AlertType.foodWindow:
        return 'Food window';
      case AlertType.ghat:
        return 'Ghat ahead';
      case AlertType.night:
        return 'Night driving';
      case AlertType.fatigue:
        return 'Fatigue';
      case AlertType.weather:
        return 'Weather';
    }
  }
}

enum AlertSeverity {
  @JsonValue('info')
  info,
  @JsonValue('warning')
  warning,
  @JsonValue('critical')
  critical,
}

/// One firing of the alert engine. Persisted with the active trip so history
/// is recoverable, and surfaced to the user via banner + local notification.
@freezed
abstract class Alert with _$Alert {
  const Alert._();

  const factory Alert({
    required String id,
    required AlertType type,
    required AlertSeverity severity,
    required String message,
    /// Distance ahead on the current route where the trigger applies.
    /// Null when the alert is location-independent (e.g. fatigue timer).
    double? distanceKm,
    required DateTime triggeredAt,
    String? relatedPoiId,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}
