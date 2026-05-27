// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      type: $enumDecode(_$VehicleTypeEnumMap, json['type']),
      nickname: json['nickname'] as String?,
      fuelEfficiencyKmpl: (json['fuelEfficiencyKmpl'] as num?)?.toDouble(),
      batteryKwh: (json['batteryKwh'] as num?)?.toDouble(),
      connectorTypes:
          (json['connectorTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      fastChargeOnly: json['fastChargeOnly'] as bool? ?? false,
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'type': _$VehicleTypeEnumMap[instance.type]!,
      'nickname': instance.nickname,
      'fuelEfficiencyKmpl': instance.fuelEfficiencyKmpl,
      'batteryKwh': instance.batteryKwh,
      'connectorTypes': instance.connectorTypes,
      'fastChargeOnly': instance.fastChargeOnly,
    };

const _$VehicleTypeEnumMap = {
  VehicleType.petrol: 'petrol',
  VehicleType.diesel: 'diesel',
  VehicleType.ev: 'ev',
  VehicleType.bike: 'bike',
};
