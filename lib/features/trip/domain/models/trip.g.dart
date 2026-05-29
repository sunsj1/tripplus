// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
  id: json['id'] as String,
  from: json['from'] as String,
  to: json['to'] as String,
  vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
  status:
      $enumDecodeNullable(_$TripStatusEnumMap, json['status']) ??
      TripStatus.notStarted,
  totalDistanceKm: (json['totalDistanceKm'] as num).toDouble(),
  drivingMinutes: (json['drivingMinutes'] as num).toInt(),
  etaMinutes: (json['etaMinutes'] as num?)?.toInt(),
  tollsEstimate: (json['tollsEstimate'] as num?)?.toDouble(),
  tripCostEstimate: (json['tripCostEstimate'] as num?)?.toDouble(),
  isCostCharging: json['isCostCharging'] as bool? ?? false,
  stationCount: (json['stationCount'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  pausedAt: json['pausedAt'] == null
      ? null
      : DateTime.parse(json['pausedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  elapsedPausedMs: (json['elapsedPausedMs'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'to': instance.to,
      'vehicle': instance.vehicle,
      'status': _$TripStatusEnumMap[instance.status]!,
      'totalDistanceKm': instance.totalDistanceKm,
      'drivingMinutes': instance.drivingMinutes,
      'etaMinutes': instance.etaMinutes,
      'tollsEstimate': instance.tollsEstimate,
      'tripCostEstimate': instance.tripCostEstimate,
      'isCostCharging': instance.isCostCharging,
      'stationCount': instance.stationCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'pausedAt': instance.pausedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'elapsedPausedMs': instance.elapsedPausedMs,
    };

const _$TripStatusEnumMap = {
  TripStatus.notStarted: 'notStarted',
  TripStatus.active: 'active',
  TripStatus.paused: 'paused',
  TripStatus.completed: 'completed',
};
