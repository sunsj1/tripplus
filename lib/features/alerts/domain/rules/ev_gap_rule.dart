import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';
import 'package:journeyplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:uuid/uuid.dart';

/// **EV Gap** — next fast charger (or any charger) is farther than the corridor
/// gap threshold, or there is a >40 km dead zone between chargers ahead.
class EvGapRule extends AlertRule {
  const EvGapRule();

  @override
  List<Alert> evaluate(AlertEngineInput input, double currentKm) {
    if (!input.vehicle.isElectric) return const [];

    var evPois = input.poisFor(PoiCategory.ev);
    if (input.vehicle.fastChargeOnly) {
      evPois = evPois.where(_isFastCharger).toList();
    }

    final ahead = AlertRouteUtils.poisAhead(evPois, currentKm);
    final routeEnd = input.activeRoute.distanceKm;

    if (ahead.isEmpty) {
      final remaining = routeEnd - currentKm;
      if (remaining <= AlertRouteUtils.gapThresholdKm) return const [];
      return [
        _alert(
          message:
              'No ${input.vehicle.fastChargeOnly ? "fast " : ""}chargers ahead for ${remaining.round()} km — check range',
          distanceKm: remaining,
          severity: AlertSeverity.critical,
          evaluatedAt: input.evaluatedAt,
        ),
      ];
    }

    final next = ahead.first;
    final distToNext =
        (next.distanceAlongRouteKm ?? currentKm) - currentKm;

    final corridorGap = AlertRouteUtils.largestGapAhead(
      ahead,
      currentKm,
      routeEnd,
    );

    final gapKm = corridorGap != null && corridorGap > distToNext
        ? corridorGap
        : distToNext;

    if (gapKm <= AlertRouteUtils.gapThresholdKm) return const [];

    final label = input.vehicle.fastChargeOnly ? 'fast charger' : 'charger';
    return [
      _alert(
        message: gapKm == distToNext
            ? 'Next $label is ${gapKm.round()} km away — ${next.name}'
            : '${gapKm.round()} km charging gap ahead — next stop: ${next.name}',
        distanceKm: gapKm,
        severity:
            gapKm > 80 ? AlertSeverity.critical : AlertSeverity.warning,
        relatedPoiId: next.id,
        evaluatedAt: input.evaluatedAt,
      ),
    ];
  }

  bool _isFastCharger(Poi poi) {
    final connections = poi.attributes['connections'];
    if (connections is List) {
      for (final c in connections) {
        if (c is Map && c['isFast'] == true) return true;
        if (c is Map) {
          final power = c['powerKw'];
          if (power is num && power >= 50) return true;
        }
      }
    }
    return poi.attributes['is_fast'] == true;
  }

  Alert _alert({
    required String message,
    required double distanceKm,
    required AlertSeverity severity,
    String? relatedPoiId,
    DateTime? evaluatedAt,
  }) {
    return Alert(
      id: const Uuid().v4(),
      type: AlertType.evGap,
      severity: severity,
      message: message,
      distanceKm: distanceKm,
      triggeredAt: evaluatedAt ?? DateTime.now(),
      relatedPoiId: relatedPoiId,
    );
  }
}
