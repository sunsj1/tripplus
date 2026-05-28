import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/features/community/domain/community_target_type.dart';

part 'station_community_submit_input.freezed.dart';

/// Payload collected in the report wizard before Firestore create.
@freezed
class StationCommunitySubmitInput with _$StationCommunitySubmitInput {
  const factory StationCommunitySubmitInput({
    required String stationKey,
    required String stationNameSnapshot,
    required String reporterUserId,
    String? reporterDisplayName,
    required int rating,
    required String condition,
    @Default(<String>[]) List<String> availableAmenityLabels,
    bool? washroomAvailable,
    bool? washroomClean,
    bool? womenFriendlyWashroom,
    String? photoBase64,
    String? comment,
    String? costPerKwh,
    @Default(false) bool fastChargerAvailable,
    bool? chargeSuccessful,
    @Default(CommunityTargetType.station) CommunityTargetType targetType,
    String? targetKey,
  }) = _StationCommunitySubmitInput;
}
