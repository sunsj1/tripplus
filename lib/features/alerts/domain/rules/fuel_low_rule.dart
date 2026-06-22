import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';
import 'package:journeyplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:uuid/uuid.dart';

/// **Fuel Low** — warns when the next community-trusted fuel stop is more than
/// [AlertRouteUtils.gapThresholdKm] away ahead on the corridor.
class FuelLowRule extends AlertRule {
  const FuelLowRule();

  static const _minRating = 3.5;
  static const _minReviews = 1;
  static const _minReliabilityScore = 75;

  @override
  List<Alert> evaluate(AlertEngineInput input, double currentKm) {
    if (!input.vehicle.burnsFuel) return const [];

    final fuelPois = input.poisFor(PoiCategory.fuel);
    final ahead = AlertRouteUtils.poisAhead(fuelPois, currentKm);
    if (ahead.isEmpty) {
      final remaining = input.activeRoute.distanceKm - currentKm;
      if (remaining <= AlertRouteUtils.gapThresholdKm) return const [];
      return [
        _alert(
          message:
              'No fuel stops mapped ahead for the next ${remaining.round()} km — plan a refill soon',
          distanceKm: remaining,
          severity: AlertSeverity.critical,
          evaluatedAt: input.evaluatedAt,
        ),
      ];
    }

    final trusted = ahead.where(_isTrustedFuel).toList();
    if (trusted.isEmpty) {
      final next = ahead.first;
      final dist = (next.distanceAlongRouteKm ?? currentKm) - currentKm;
      if (dist <= AlertRouteUtils.gapThresholdKm) return const [];
      return [
        _alert(
          message:
              'No highly trusted fuel stop soon — next pump in ${dist.round()} km (${next.name})',
          distanceKm: dist,
          severity: AlertSeverity.warning,
          relatedPoiId: next.id,
          evaluatedAt: input.evaluatedAt,
        ),
      ];
    }

    final nextTrusted = trusted.first;
    final distKm =
        (nextTrusted.distanceAlongRouteKm ?? currentKm) - currentKm;
    if (distKm <= AlertRouteUtils.gapThresholdKm) return const [];

    return [
      _alert(
        message:
            'Last trusted fuel for the next ${distKm.round()} km — ${nextTrusted.name}',
        distanceKm: distKm,
        severity:
            distKm > 80 ? AlertSeverity.critical : AlertSeverity.warning,
        relatedPoiId: nextTrusted.id,
        evaluatedAt: input.evaluatedAt,
      ),
    ];
  }

  bool _isTrustedFuel(Poi poi) {
    final reliability = poi.attributes['reliabilityScore'];
    if (reliability is num && reliability >= _minReliabilityScore) {
      return true;
    }
    return poi.rating >= _minRating && poi.reviewCount >= _minReviews;
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
      type: AlertType.fuelLow,
      severity: severity,
      message: message,
      distanceKm: distanceKm,
      triggeredAt: evaluatedAt ?? DateTime.now(),
      relatedPoiId: relatedPoiId,
    );
  }
}
