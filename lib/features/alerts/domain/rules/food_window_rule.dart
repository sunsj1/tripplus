import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/alerts/domain/alert_engine_input.dart';
import 'package:tripplus/features/alerts/domain/alert_route_utils.dart';
import 'package:tripplus/features/alerts/domain/rules/alert_rule.dart';
import 'package:uuid/uuid.dart';

/// **Food window** — surfaces when the next highly rated meal stop (honouring
/// [UserPreferences.pureVeg]) is farther than the food lookahead threshold.
class FoodWindowRule extends AlertRule {
  const FoodWindowRule();

  static const double foodLookaheadKm = 50;
  static const _minRating = 4.0;
  static const _minReviews = 3;

  @override
  List<Alert> evaluate(AlertEngineInput input, double currentKm) {
    final candidates = _mealCandidates(input);
    final ahead = AlertRouteUtils.poisAhead(candidates, currentKm);
    final rated = ahead.where(_isHighlyRated).toList();

    if (rated.isEmpty) {
      if (ahead.isEmpty) return const [];
      final next = ahead.first;
      final dist = (next.distanceAlongRouteKm ?? currentKm) - currentKm;
      if (dist <= foodLookaheadKm) return const [];
      return [
        _alert(
          message: _message(input, dist, next.name, highlyRated: false),
          distanceKm: dist,
          relatedPoiId: next.id,
          evaluatedAt: input.evaluatedAt,
        ),
      ];
    }

    final next = rated.first;
    final dist = (next.distanceAlongRouteKm ?? currentKm) - currentKm;
    if (dist <= foodLookaheadKm) return const [];

    return [
      _alert(
        message: _message(input, dist, next.name, highlyRated: true),
        distanceKm: dist,
        relatedPoiId: next.id,
        evaluatedAt: input.evaluatedAt,
      ),
    ];
  }

  List<Poi> _mealCandidates(AlertEngineInput input) {
    if (input.preferences.pureVeg) {
      final veg = input.poisFor(PoiCategory.pureVeg);
      if (veg.isNotEmpty) return veg;
    }
    final restaurants = input.poisFor(PoiCategory.restaurant);
    if (!input.preferences.pureVeg) return restaurants;
    return restaurants
        .where(
          (p) =>
              p.name.toLowerCase().contains('veg') ||
              p.category == PoiCategory.pureVeg,
        )
        .toList();
  }

  bool _isHighlyRated(Poi poi) =>
      poi.rating >= _minRating && poi.reviewCount >= _minReviews;

  String _message(
    AlertEngineInput input,
    double distKm,
    String name, {
    required bool highlyRated,
  }) {
    final veg = input.preferences.pureVeg ? 'pure veg ' : '';
    if (highlyRated) {
      return 'Next highly rated $veg meal stop in ${distKm.round()} km — $name';
    }
    return 'Next $veg food stop in ${distKm.round()} km — $name (limited ratings)';
  }

  Alert _alert({
    required String message,
    required double distanceKm,
    String? relatedPoiId,
    DateTime? evaluatedAt,
  }) {
    return Alert(
      id: const Uuid().v4(),
      type: AlertType.foodWindow,
      severity: AlertSeverity.info,
      message: message,
      distanceKm: distanceKm,
      triggeredAt: evaluatedAt ?? DateTime.now(),
      relatedPoiId: relatedPoiId,
    );
  }
}
