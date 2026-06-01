import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/alerts/domain/alert_engine_input.dart';
import 'package:tripplus/features/alerts/domain/alert_route_utils.dart';
import 'package:tripplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:uuid/uuid.dart';

/// **P2-003 — Night driving alert with safe-stop suggestion.**
///
/// Fires while driving during night hours and there is an actionable rest stop
/// ahead (hotel preferred, fuel station as fallback). Staying quiet when no
/// good stop is nearby avoids spamming the driver across a long dark stretch —
/// the cooldown in the notifier governs repeat frequency.
class NightRule extends AlertRule {
  const NightRule();

  /// Night window: 22:00 (inclusive) → 05:00 (exclusive), local time.
  static const _nightStartHour = 22;
  static const _nightEndHour = 5;

  /// Only suggest a stop that is genuinely reachable soon.
  static const _suggestionRangeKm = 45.0;

  @override
  List<Alert> evaluate(AlertEngineInput input, double currentKm) {
    final now = input.evaluatedAt ?? DateTime.now();
    final hour = now.hour;
    final isNight = hour >= _nightStartHour || hour < _nightEndHour;
    if (!isNight) return const [];

    // Prefer a hotel; fall back to a fuel station (usually lit + open late).
    final stop = _firstAheadInRange(
          input.poisFor(PoiCategory.hotel),
          currentKm,
        ) ??
        _firstAheadInRange(
          input.poisFor(PoiCategory.fuel),
          currentKm,
        );

    if (stop == null) return const [];

    final aheadKm = (stop.distanceAlongRouteKm ?? currentKm) - currentKm;

    return [
      Alert(
        id: const Uuid().v4(),
        type: AlertType.night,
        severity: AlertSeverity.warning,
        message:
            'Driving late — consider a rest. ${stop.name} is '
            '${aheadKm.round()} km ahead.',
        distanceKm: aheadKm,
        relatedPoiId: stop.id,
        triggeredAt: now,
      ),
    ];
  }

  Poi? _firstAheadInRange(List<Poi> pois, double currentKm) {
    final ahead = AlertRouteUtils.poisAhead(pois, currentKm);
    for (final p in ahead) {
      final d = (p.distanceAlongRouteKm ?? currentKm) - currentKm;
      if (d > 0 && d <= _suggestionRangeKm) return p;
    }
    return null;
  }
}
