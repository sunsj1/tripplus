import 'package:journeyplus/features/alerts/domain/alert.dart';

/// Encoded local-notification payload for trip-alert deep links.
///
/// Wire format: `jp_alert|<tripId>|<alertTypeWire>`
class AlertNotificationPayload {
  const AlertNotificationPayload({
    required this.tripId,
    required this.alertType,
  });

  static const prefix = 'jp_alert';

  final String tripId;
  final AlertType alertType;

  String encode() => '$prefix|$tripId|${_wire(alertType)}';

  static AlertNotificationPayload? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split('|');
    if (parts.length != 3 || parts[0] != prefix) return null;
    final tripId = parts[1].trim();
    if (tripId.isEmpty) return null;
    final type = _fromWire(parts[2]);
    if (type == null) return null;
    return AlertNotificationPayload(tripId: tripId, alertType: type);
  }

  static String _wire(AlertType type) => switch (type) {
    AlertType.fuelLow => 'fuel_low',
    AlertType.evGap => 'ev_gap',
    AlertType.foodWindow => 'food_window',
    AlertType.ghat => 'ghat',
    AlertType.night => 'night',
    AlertType.fatigue => 'fatigue',
    AlertType.weather => 'weather',
  };

  static AlertType? _fromWire(String wire) => switch (wire) {
    'fuel_low' => AlertType.fuelLow,
    'ev_gap' => AlertType.evGap,
    'food_window' => AlertType.foodWindow,
    'ghat' => AlertType.ghat,
    'night' => AlertType.night,
    'fatigue' => AlertType.fatigue,
    'weather' => AlertType.weather,
    _ => null,
  };
}
