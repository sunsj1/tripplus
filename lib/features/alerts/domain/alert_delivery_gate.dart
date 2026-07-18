import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/settings/domain/app_settings.dart';

/// Pure mute + cooldown gate shared by the notifier and unit tests.
class AlertDeliveryGate {
  const AlertDeliveryGate._();

  /// Default gap between two firings of the same [AlertType].
  static const cooldown = Duration(minutes: 20);

  /// Whether the alert may be delivered (banner and/or system notification).
  static bool shouldDeliver({
    required AppSettings settings,
    required AlertType type,
    required Map<AlertType, DateTime> lastFiredAt,
    required DateTime now,
    Duration cooldown = AlertDeliveryGate.cooldown,
  }) {
    if (settings.isMuted(type)) return false;
    final lastFired = lastFiredAt[type];
    if (lastFired != null && now.difference(lastFired) < cooldown) {
      return false;
    }
    return true;
  }

  /// Whether the OS tray notification should fire in addition to the banner.
  static bool shouldShowSystemNotification(AppSettings settings) {
    return settings.systemNotificationsEnabled;
  }
}
