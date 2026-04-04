// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityReportImpl _$$CommunityReportImplFromJson(
  Map<String, dynamic> json,
) => _$CommunityReportImpl(
  stationId: json['stationId'] as String,
  condition: json['condition'] as String,
  costPerKwh: json['costPerKwh'] as String?,
  fastChargerAvailable: json['fastChargerAvailable'] as bool? ?? false,
  comments: json['comments'] as String?,
  reportedAtMs: (json['reportedAtMs'] as num).toInt(),
);

Map<String, dynamic> _$$CommunityReportImplToJson(
  _$CommunityReportImpl instance,
) => <String, dynamic>{
  'stationId': instance.stationId,
  'condition': instance.condition,
  'costPerKwh': instance.costPerKwh,
  'fastChargerAvailable': instance.fastChargerAvailable,
  'comments': instance.comments,
  'reportedAtMs': instance.reportedAtMs,
};
