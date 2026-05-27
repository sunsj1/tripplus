// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertImpl _$$AlertImplFromJson(Map<String, dynamic> json) => _$AlertImpl(
  id: json['id'] as String,
  type: $enumDecode(_$AlertTypeEnumMap, json['type']),
  severity: $enumDecode(_$AlertSeverityEnumMap, json['severity']),
  message: json['message'] as String,
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  triggeredAt: DateTime.parse(json['triggeredAt'] as String),
  relatedPoiId: json['relatedPoiId'] as String?,
);

Map<String, dynamic> _$$AlertImplToJson(_$AlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'severity': _$AlertSeverityEnumMap[instance.severity]!,
      'message': instance.message,
      'distanceKm': instance.distanceKm,
      'triggeredAt': instance.triggeredAt.toIso8601String(),
      'relatedPoiId': instance.relatedPoiId,
    };

const _$AlertTypeEnumMap = {
  AlertType.fuelLow: 'fuel_low',
  AlertType.evGap: 'ev_gap',
  AlertType.foodWindow: 'food_window',
  AlertType.ghat: 'ghat',
  AlertType.night: 'night',
  AlertType.fatigue: 'fatigue',
  AlertType.weather: 'weather',
};

const _$AlertSeverityEnumMap = {
  AlertSeverity.info: 'info',
  AlertSeverity.warning: 'warning',
  AlertSeverity.critical: 'critical',
};
