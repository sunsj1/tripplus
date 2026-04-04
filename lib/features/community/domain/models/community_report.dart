import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_report.freezed.dart';
part 'community_report.g.dart';

@freezed
abstract class CommunityReport with _$CommunityReport {
  const factory CommunityReport({
    required String stationId,
    required String condition,
    String? costPerKwh,
    @Default(false) bool fastChargerAvailable,
    String? comments,
    required int reportedAtMs,
  }) = _CommunityReport;

  factory CommunityReport.fromJson(Map<String, dynamic> json) =>
      _$CommunityReportFromJson(json);
}
