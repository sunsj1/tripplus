import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';
import 'package:journeyplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:uuid/uuid.dart';

/// **P2-004 / HA-040 — Fatigue alert.**
///
/// Reminds the driver to take a break every [_intervalMinutes] of continuous
/// driving. Once past a 3-hour boundary the rule stays eligible; the notifier's
/// per-type cooldown collapses repeated ticks into one delivery. This avoids
/// missing the old 5-minute band when a poll/tick lands slightly late.
///
/// [AlertEngineInput.drivingDuration] already excludes paused time, so taking a
/// break (pausing the trip) naturally pushes the next reminder out.
class FatigueRule extends AlertRule {
  const FatigueRule();

  static const intervalMinutes = 180; // 3 hours

  @override
  List<Alert> evaluate(AlertEngineInput input, double currentKm) {
    final driving = input.drivingDuration;
    if (driving == null) return const [];

    final mins = driving.inMinutes;
    if (mins < intervalMinutes) return const [];

    final hours = mins ~/ 60;
    return [
      Alert(
        id: const Uuid().v4(),
        type: AlertType.fatigue,
        severity: AlertSeverity.warning,
        message:
            "You've been driving ~${hours}h. Take a 15-minute break — "
            'stretch, hydrate, and refocus before continuing.',
        triggeredAt: input.evaluatedAt ?? DateTime.now(),
      ),
    ];
  }
}
