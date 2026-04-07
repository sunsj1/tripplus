import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/features/community/domain/models/station_community_report.dart';

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
}
