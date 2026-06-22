import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journeyplus/features/community/domain/community_target_type.dart';
import 'package:journeyplus/features/community/domain/models/station_community_report.dart';
import 'package:journeyplus/features/community/domain/models/station_community_submit_input.dart';

/// Maps Firestore documents ↔ domain models for community reports.
/// Schema evolves additively (`P1-050`) — old docs without `targetType` /
/// `targetKey` still parse, and `targetKey` falls back to `stationKey`.
class StationCommunityReportDto {
  const StationCommunityReportDto._();

  static StationCommunityReport fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    final created = d['createdAt'];
    DateTime createdAt;
    if (created is Timestamp) {
      createdAt = created.toDate();
    } else {
      createdAt = DateTime.fromMillisecondsSinceEpoch(0);
    }
    final stationKey = d['stationKey'] as String? ?? '';
    final targetKeyRaw = d['targetKey'] as String?;
    return StationCommunityReport(
      id: doc.id,
      stationKey: stationKey,
      stationNameSnapshot: d['stationNameSnapshot'] as String? ?? '',
      reporterUserId: d['reporterUserId'] as String? ?? '',
      reporterDisplayName: d['reporterDisplayName'] as String?,
      rating: (d['rating'] as num?)?.toInt() ?? 0,
      condition: d['condition'] as String? ?? 'working',
      availableAmenityLabels: (d['availableAmenityLabels'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      washroomAvailable: d['washroomAvailable'] as bool?,
      washroomClean: d['washroomClean'] as bool?,
      womenFriendlyWashroom: d['womenFriendlyWashroom'] as bool?,
      photoBase64: d['photoBase64'] as String?,
      comment: d['comment'] as String?,
      costPerKwh: d['costPerKwh'] as String?,
      fastChargerAvailable: d['fastChargerAvailable'] as bool? ?? false,
      chargeSuccessful: d['chargeSuccessful'] as bool?,
      createdAt: createdAt,
      targetType: CommunityTargetTypeX.fromWire(d['targetType'] as String?),
      targetKey: (targetKeyRaw != null && targetKeyRaw.isNotEmpty)
          ? targetKeyRaw
          : (stationKey.isNotEmpty ? stationKey : null),
      // P2-023 — tags; missing on legacy docs → null (treated as unanswered).
      babyFriendly: d['babyFriendly'] as bool?,
      womenSafe: d['womenSafe'] as bool?,
      hygienic: d['hygienic'] as bool?,
      // P2-043 — Road condition tag (good / rough / construction). Optional.
      roadCondition: d['roadCondition'] as String?,
    );
  }

  static Map<String, dynamic> toCreateMap(StationCommunitySubmitInput input) {
    // For station targets we mirror `stationKey` into `targetKey` so a single
    // query on `targetKey` can serve both target types — required by `P1-051`.
    final effectiveTargetKey = input.targetKey ?? input.stationKey;
    return {
      'stationKey': input.stationKey,
      'stationNameSnapshot': input.stationNameSnapshot,
      'reporterUserId': input.reporterUserId,
      'reporterDisplayName': input.reporterDisplayName,
      'rating': input.rating,
      'condition': input.condition,
      'availableAmenityLabels': input.availableAmenityLabels,
      'washroomAvailable': input.washroomAvailable,
      'washroomClean': input.washroomClean,
      'womenFriendlyWashroom': input.womenFriendlyWashroom,
      'photoBase64': input.photoBase64,
      'comment': input.comment,
      'costPerKwh': input.costPerKwh,
      'fastChargerAvailable': input.fastChargerAvailable,
      'chargeSuccessful': input.chargeSuccessful,
      'targetType': input.targetType.wireValue,
      'targetKey': effectiveTargetKey,
      'createdAt': FieldValue.serverTimestamp(),
      // P2-023 — only write non-null tags so we don't bloat docs with null fields.
      if (input.babyFriendly != null) 'babyFriendly': input.babyFriendly,
      if (input.womenSafe != null) 'womenSafe': input.womenSafe,
      if (input.hygienic != null) 'hygienic': input.hygienic,
      // P2-043 — Road condition: only persist if the user picked one.
      if (input.roadCondition != null) 'roadCondition': input.roadCondition,
    };
  }
}
