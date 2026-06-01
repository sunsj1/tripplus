import 'package:tripplus/core/utils/polyline_decoder.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/alerts/domain/alert_engine_input.dart';
import 'package:tripplus/features/alerts/domain/alert_route_utils.dart';
import 'package:tripplus/features/alerts/domain/ghat_dataset.dart';
import 'package:tripplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:uuid/uuid.dart';

/// **P2-002 — Ghat / risk alert.**
///
/// Warns the driver when the route is about to enter a known ghat (mountain
/// pass) section. Matches against the static [kGhatSections] dataset: a ghat
/// counts if the route polyline passes within its radius and the ghat lies
/// ahead within the engine's upcoming window.
class GhatRule extends AlertRule {
  const GhatRule();

  @override
  List<Alert> evaluate(AlertEngineInput input, double currentKm) {
    final polyline = input.activeRoute.polylinePoints;
    if (polyline.length < 2) return const [];

    final window = input.upcomingWindowKm;

    GhatSection? nearest;
    double? nearestAheadKm;

    for (final ghat in kGhatSections) {
      final centre = LatLng(ghat.lat, ghat.lng);

      // Does the route actually pass through this ghat?
      final perp = AlertRouteUtils.nearestApproachKm(polyline, centre);
      if (perp > ghat.radiusKm) continue;

      // Is it ahead of us and within the lookahead window?
      final alongKm = AlertRouteUtils.distanceAlongRoute(polyline, centre);
      final aheadKm = alongKm - currentKm;
      if (aheadKm <= 0 || aheadKm > window) continue;

      if (nearestAheadKm == null || aheadKm < nearestAheadKm) {
        nearestAheadKm = aheadKm;
        nearest = ghat;
      }
    }

    if (nearest == null || nearestAheadKm == null) return const [];

    return [
      Alert(
        id: const Uuid().v4(),
        type: AlertType.ghat,
        severity: AlertSeverity.warning,
        message:
            '${nearest.name} in ${nearestAheadKm.round()} km — '
            '~${nearest.lengthKm.round()} km of winding ghat road. '
            'Drive slow, use lower gears on descents.',
        distanceKm: nearestAheadKm,
        triggeredAt: input.evaluatedAt ?? DateTime.now(),
      ),
    ];
  }
}
