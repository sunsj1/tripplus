import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/alerts/domain/alert_engine_input.dart';
import 'package:tripplus/features/alerts/domain/alert_route_utils.dart';
import 'package:tripplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/ev_gap_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/fatigue_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/food_window_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/fuel_low_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/ghat_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/night_rule.dart';
import 'package:tripplus/features/alerts/domain/rules/weather_rule.dart';

/// Pure-Dart rule evaluator for predictive corridor alerts.
///
/// P2-001: Before passing the input to any rule, the engine pre-filters
/// [AlertEngineInput.upcomingPois] to only POIs within
/// [AlertEngineInput.upcomingWindowKm] ahead of the current position.
/// This makes every rule — present and future — automatically window-aware.
class AlertEngine {
  AlertEngine({List<AlertRule>? rules})
      : _rules = rules ??
            const [
              FuelLowRule(),
              EvGapRule(),
              FoodWindowRule(),
              GhatRule(),     // P2-002
              NightRule(),    // P2-003
              FatigueRule(),  // P2-004
              WeatherRule(),  // P2-005
            ];

  final List<AlertRule> _rules;

  /// Evaluates all applicable rules against the upcoming corridor window and
  /// returns deduplicated alerts (one per [AlertType], highest severity wins).
  List<Alert> evaluate(AlertEngineInput input) {
    final evaluatedAt = input.evaluatedAt ?? DateTime.now();

    // Resolve current distance once so all rules share the same value.
    final currentKm = input.currentDistanceAlongRouteKm ??
        AlertRouteUtils.distanceAlongRoute(
          input.activeRoute.polylinePoints,
          input.currentLocation,
        );

    // P2-001 — Pre-filter every category to [upcomingWindowKm] ahead.
    // Rules never need to know about the window — they see a pre-trimmed map.
    final windowedPois = <PoiCategory, List<Poi>>{
      for (final entry in input.upcomingPois.entries)
        entry.key: AlertRouteUtils.poisInWindow(
          entry.value,
          currentKm,
          input.upcomingWindowKm,
        ),
    };

    final windowed = AlertEngineInput(
      activeRoute: input.activeRoute,
      currentLocation: input.currentLocation,
      vehicle: input.vehicle,
      preferences: input.preferences,
      upcomingPois: windowedPois,
      currentDistanceAlongRouteKm: currentKm,
      evaluatedAt: evaluatedAt,
      upcomingWindowKm: input.upcomingWindowKm,
      drivingDuration: input.drivingDuration,
      upcomingWeather: input.upcomingWeather,
    );

    final byType = <AlertType, Alert>{};

    for (final rule in _rules) {
      for (final alert in rule.evaluate(windowed, currentKm)) {
        final existing = byType[alert.type];
        if (existing == null ||
            _severityRank(alert.severity) > _severityRank(existing.severity)) {
          byType[alert.type] = alert;
        }
      }
    }

    return byType.values.toList()
      ..sort(
          (a, b) => _severityRank(b.severity).compareTo(_severityRank(a.severity)));
  }

  int _severityRank(AlertSeverity s) => switch (s) {
        AlertSeverity.info => 0,
        AlertSeverity.warning => 1,
        AlertSeverity.critical => 2,
      };
}
