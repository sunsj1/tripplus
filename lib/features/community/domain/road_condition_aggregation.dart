import 'package:journeyplus/features/community/domain/models/station_community_report.dart';

/// P2-043 — Aggregated road-condition signal for the road near a POI.
///
/// Three buckets (`good` / `rough` / `construction`). We surface the dominant
/// non-good signal when at least 2 reports answered and a clear majority
/// agrees, so a single bad report doesn't slap a "rough road" badge on a
/// well-maintained corridor.
class RoadConditionAggregation {
  const RoadConditionAggregation({
    required this.goodCount,
    required this.roughCount,
    required this.constructionCount,
    required this.answered,
  });

  factory RoadConditionAggregation.from(List<StationCommunityReport> reports) {
    var good = 0, rough = 0, construction = 0, answered = 0;
    for (final r in reports) {
      final v = r.roadCondition;
      if (v == null) continue;
      answered++;
      switch (v) {
        case 'good':
          good++;
        case 'rough':
          rough++;
        case 'construction':
          construction++;
      }
    }
    return RoadConditionAggregation(
      goodCount: good,
      roughCount: rough,
      constructionCount: construction,
      answered: answered,
    );
  }

  final int goodCount;
  final int roughCount;
  final int constructionCount;
  final int answered;

  static const _minAnswers = 2;
  static const _dominanceThreshold = 0.5;

  /// Worst recent road condition, or null if we don't have enough signal.
  ///
  /// Priority: construction → rough → good → null. Construction wins over
  /// rough even at lower share because it's the more actionable warning.
  String? get dominantCondition {
    if (answered < _minAnswers) return null;
    if (constructionCount / answered >= 0.3) return 'construction';
    if (roughCount / answered >= _dominanceThreshold) return 'rough';
    if (goodCount / answered >= _dominanceThreshold) return 'good';
    return null;
  }

  /// True when the road needs a heads-up (rough or construction).
  bool get hasAdvisory =>
      dominantCondition == 'rough' || dominantCondition == 'construction';

  /// User-facing copy for the dominant condition (or empty when none).
  String get advisoryLabel {
    switch (dominantCondition) {
      case 'rough':
        return 'Rough road';
      case 'construction':
        return 'Road work';
      case 'good':
        return 'Smooth road';
      default:
        return '';
    }
  }
}
