import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/alerts/domain/alert_engine_input.dart';
import 'package:tripplus/features/alerts/domain/alert_route_utils.dart';
import 'package:tripplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/ev_gap_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/food_window_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/fuel_low_rule.dart';

/// Pure-Dart rule evaluator for predictive corridor alerts (Phase 1 MVP).
///
/// Consumes a resolved route, live position, vehicle, preferences, and
/// pre-fetched [AlertEngineInput.upcomingPois]. No network I/O — callers
/// (e.g. [AlertNotifier] in `P1-028`) supply POI lists from [RoutePoiService].
class AlertEngine {
  AlertEngine({List<AlertRule>? rules})
      : _rules = rules ??
            const [
              FuelLowRule(),
              EvGapRule(),
              FoodWindowRule(),
            ];

  final List<AlertRule> _rules;

  /// Evaluates all applicable rules and returns deduplicated alerts (one per
  /// [AlertType], keeping the highest [AlertSeverity]).
  List<Alert> evaluate(AlertEngineInput input) {
    final evaluatedAt = input.evaluatedAt ?? DateTime.now();
    final normalized = AlertEngineInput(
      activeRoute: input.activeRoute,
      currentLocation: input.currentLocation,
      vehicle: input.vehicle,
      preferences: input.preferences,
      upcomingPois: input.upcomingPois,
      currentDistanceAlongRouteKm: input.currentDistanceAlongRouteKm,
      evaluatedAt: evaluatedAt,
    );

    final currentKm = normalized.currentDistanceAlongRouteKm ??
        AlertRouteUtils.distanceAlongRoute(
          normalized.activeRoute.polylinePoints,
          normalized.currentLocation,
        );

    final byType = <AlertType, Alert>{};

    for (final rule in _rules) {
      for (final alert in rule.evaluate(normalized, currentKm)) {
        final existing = byType[alert.type];
        if (existing == null ||
            _severityRank(alert.severity) > _severityRank(existing.severity)) {
          byType[alert.type] = alert;
        }
      }
    }

    return byType.values.toList()
      ..sort((a, b) => _severityRank(b.severity).compareTo(_severityRank(a.severity)));
  }

  int _severityRank(AlertSeverity s) => switch (s) {
        AlertSeverity.info => 0,
        AlertSeverity.warning => 1,
        AlertSeverity.critical => 2,
      };
}
