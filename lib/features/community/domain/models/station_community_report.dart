import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_community_report.freezed.dart';

/// One community report for a charging station (Firestore-backed).
@freezed
class StationCommunityReport with _$StationCommunityReport {
  const factory StationCommunityReport({
    required String id,
    required String stationKey,
    required String stationNameSnapshot,
    required String reporterUserId,
    String? reporterDisplayName,
    /// 1–5 stars
    required int rating,
    required String condition,
    @Default(<String>[]) List<String> availableAmenityLabels,
    bool? washroomAvailable,
    bool? washroomClean,
    bool? womenFriendlyWashroom,
    /// JPEG base64, optional (kept small for Firestore document limits).
    String? photoBase64,
    String? comment,
    String? costPerKwh,
    @Default(false) bool fastChargerAvailable,
    bool? chargeSuccessful,
    required DateTime createdAt,
  }) = _StationCommunityReport;
}
