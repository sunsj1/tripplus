import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/alerts/domain/alert_engine_input.dart';
import 'package:tripplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:uuid/uuid.dart';

/// **P2-004 — Fatigue alert.**
///
/// Reminds the driver to take a break every [_intervalMinutes] of continuous
/// driving. Because rules are pure/stateless, "every 3 hours" is expressed as a
/// narrow band just after each 3-hour boundary; the notifier's per-type cooldown
/// collapses the band's multiple ticks into a single delivery, and the next
/// boundary is far enough away that the cooldown has expired by then.
///
/// [AlertEngineInput.drivingDuration] already excludes paused time, so taking a
/// break (pausing the trip) naturally pushes the next reminder out.
class FatigueRule extends AlertRule {
  const FatigueRule();

  static const _intervalMinutes = 180; // 3 hours
  static const _bandMinutes = 5; // fire within this band after each boundary

  @override
  List<Alert> evaluate(AlertEngineInput input, double currentKm) {
    final driving = input.drivingDuration;
    if (driving == null) return const [];

    final mins = driving.inMinutes;
    if (mins < _intervalMinutes) return const [];

    // Only fire in the short band just after each 3-hour mark.
    if (mins % _intervalMinutes >= _bandMinutes) return const [];

    final hours = mins ~/ 60;
    return [
      Alert(
        id: const Uuid().v4(),
        type: AlertType.fatigue,
        severity: AlertSeverity.warning,
        message:
            "You've been driving ~${hours}h. Take a 15-minute break — "
            'stretch, hydrate, and refocus before continuing.',
        // Fatigue is time-based, not location-based.
        triggeredAt: input.evaluatedAt ?? DateTime.now(),
      ),
    ];
  }
}
