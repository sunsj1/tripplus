import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/features/community/domain/community_condition.dart';
import 'package:tripplus/features/community/domain/models/station_community_report.dart';
import 'package:tripplus/features/community/domain/trust_level.dart';

part 'station_community_ui_state.freezed.dart';

@freezed
class StationCommunityUiState with _$StationCommunityUiState {
  const factory StationCommunityUiState({
    @Default(true) bool loading,
    @Default(false) bool submitting,
    String? errorMessage,
    @Default(<StationCommunityReport>[]) List<StationCommunityReport> reports,
  }) = _StationCommunityUiState;
}

extension StationCommunityUiStateX on StationCommunityUiState {
  double? get averageRating {
    if (reports.isEmpty) return null;
    final sum = reports.fold<int>(0, (a, r) => a + r.rating);
    return sum / reports.length;
  }

  DateTime? get lastUpdatedAt =>
      reports.isEmpty ? null : reports.first.createdAt;

  bool get lowConfidence {
    if (reports.length < 3) return true;
    final t = lastUpdatedAt;
    if (t == null) return true;
    return DateTime.now().difference(t).inHours > 24;
  }

  String get freshnessLabel {
    final t = lastUpdatedAt;
    if (t == null) return 'No recent activity';
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'updated just now';
    if (diff.inMinutes < 60) return 'updated ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'updated ${diff.inHours}h ago';
    return 'updated ${diff.inDays}d ago';
  }

  /// Weighted reliability score (0-100) using recency + condition quality.
  int get reliabilityScore {
    if (reports.isEmpty) return 0;
    double weighted = 0;
    double totalW = 0;
    for (final r in reports.take(20)) {
      final ageH = DateTime.now().difference(r.createdAt).inHours;
      final recencyW = ageH <= 6
          ? 1.0
          : ageH <= 24
              ? 0.85
              : ageH <= 72
                  ? 0.65
                  : 0.45;
      // P2-030 — generalized: handles EV (working/issues/down) AND
      // POI (good/fair/poor) condition vocabularies.
      final conditionScore = conditionQuality(r.condition);
      final successBoost = r.chargeSuccessful == true
          ? 0.08
          : r.chargeSuccessful == false
              ? -0.08
              : 0.0;
      final ratingNorm = (r.rating / 5).clamp(0.2, 1.0);
      final sample = (conditionScore + successBoost) * 0.6 + ratingNorm * 0.4;
      weighted += sample * recencyW;
      totalW += recencyW;
    }
    if (totalW == 0) return 0;
    final normalized = (weighted / totalW).clamp(0, 1.0);
    return (normalized * 100).round();
  }

  bool get hasConflictInRecent {
    final recent = reports.take(6).toList();
    if (recent.isEmpty) return false;
    // P2-030 — recognise both vocabularies.
    final hasNegative = recent.any((r) => isNegativeCondition(r.condition));
    final hasPositive = recent.any(
      (r) => isPositiveCondition(r.condition) || r.chargeSuccessful == true,
    );
    return hasNegative && hasPositive;
  }

  /// P2-030 — Coarse trust tier from score + report count.
  TrustLevel get trustLevel =>
      TrustLevel.fromScore(reliabilityScore, reports.length);

  DateTime? get latestSuccessfulChargeAt {
    for (final r in reports) {
      if (r.chargeSuccessful == true) return r.createdAt;
    }
    return null;
  }
}
