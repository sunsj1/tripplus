import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';

/// One distance-based alert rule. Implementations are pure Dart.
abstract class AlertRule {
  const AlertRule();

  /// Returns zero or one alert for this evaluation tick.
  List<Alert> evaluate(AlertEngineInput input, double currentKm);
}
