import 'package:journeyplus/features/community/domain/models/station_community_report.dart';

/// P2-023 — Aggregates the mode-relevant boolean tags (baby-friendly,
/// women-safe, hygienic) across a list of community reports.
///
/// Tags are tri-state in the data layer (null = unanswered) so a single
/// "no opinion" report doesn't drag down the signal. We count "yes" and
/// "answered" (yes + no) separately to derive a confidence-weighted percent.
class CommunityTagAggregation {
  const CommunityTagAggregation({
    required this.babyFriendlyYes,
    required this.babyFriendlyAnswered,
    required this.womenSafeYes,
    required this.womenSafeAnswered,
    required this.hygienicYes,
    required this.hygienicAnswered,
  });

  factory CommunityTagAggregation.empty() =>
      const CommunityTagAggregation(
        babyFriendlyYes: 0,
        babyFriendlyAnswered: 0,
        womenSafeYes: 0,
        womenSafeAnswered: 0,
        hygienicYes: 0,
        hygienicAnswered: 0,
      );

  factory CommunityTagAggregation.from(List<StationCommunityReport> reports) {
    var babyYes = 0, babyAns = 0;
    var safeYes = 0, safeAns = 0;
    var hygYes = 0, hygAns = 0;
    for (final r in reports) {
      if (r.babyFriendly != null) {
        babyAns++;
        if (r.babyFriendly!) babyYes++;
      }
      if (r.womenSafe != null) {
        safeAns++;
        if (r.womenSafe!) safeYes++;
      }
      if (r.hygienic != null) {
        hygAns++;
        if (r.hygienic!) hygYes++;
      }
    }
    return CommunityTagAggregation(
      babyFriendlyYes: babyYes,
      babyFriendlyAnswered: babyAns,
      womenSafeYes: safeYes,
      womenSafeAnswered: safeAns,
      hygienicYes: hygYes,
      hygienicAnswered: hygAns,
    );
  }

  final int babyFriendlyYes;
  final int babyFriendlyAnswered;
  final int womenSafeYes;
  final int womenSafeAnswered;
  final int hygienicYes;
  final int hygienicAnswered;

  // Minimum signal before we trust a tag aggregation.
  static const _minAnswers = 2;
  static const _threshold = 0.5;

  double get babyFriendlyPercent => babyFriendlyAnswered == 0
      ? 0
      : babyFriendlyYes / babyFriendlyAnswered;

  double get womenSafePercent => womenSafeAnswered == 0
      ? 0
      : womenSafeYes / womenSafeAnswered;

  double get hygienicPercent =>
      hygienicAnswered == 0 ? 0 : hygienicYes / hygienicAnswered;

  /// Qualifies for the Family Mode filter / "Family-friendly" badge.
  bool get qualifiesFamily =>
      babyFriendlyAnswered >= _minAnswers &&
      babyFriendlyPercent >= _threshold;

  /// Qualifies for the Women-Safe Mode filter / badge.
  bool get qualifiesWomenSafe =>
      womenSafeAnswered >= _minAnswers && womenSafePercent >= _threshold;

  /// Qualifies for a "Clean" hygiene badge.
  bool get qualifiesHygienic =>
      hygienicAnswered >= _minAnswers && hygienicPercent >= _threshold;

  bool get hasAnyAnswered =>
      babyFriendlyAnswered > 0 ||
      womenSafeAnswered > 0 ||
      hygienicAnswered > 0;
}
