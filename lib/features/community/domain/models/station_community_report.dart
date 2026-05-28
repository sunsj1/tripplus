import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/features/community/domain/community_target_type.dart';

part 'station_community_report.freezed.dart';

/// One community report (Firestore-backed). Despite the legacy class name,
/// pulses can attach to any POI category from `P1-050` onwards — see
/// [targetType] / [targetKey].
///
/// Schema invariants:
/// - `stationKey` stays the back-compat key for station reports (write it
///   on every station pulse so existing queries keep working).
/// - `targetKey` is the generic identity; for POIs use `poi_<…>`, for
///   stations it equals `stationKey`.
/// - `targetType` discriminates ([CommunityTargetType.station] | `.poi`).
@freezed
class StationCommunityReport with _$StationCommunityReport {
  const StationCommunityReport._();

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
    @Default(CommunityTargetType.station) CommunityTargetType targetType,
    String? targetKey,
  }) = _StationCommunityReport;

  /// Generic identity. Old reports written before `P1-050` only have
  /// `stationKey` — this getter falls back so queries keyed by `targetKey`
  /// still find them.
  String get effectiveTargetKey =>
      (targetKey != null && targetKey!.isNotEmpty) ? targetKey! : stationKey;
}
