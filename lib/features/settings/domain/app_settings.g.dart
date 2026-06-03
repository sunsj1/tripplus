// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      distanceUnit:
          $enumDecodeNullable(_$DistanceUnitEnumMap, json['distanceUnit']) ??
          DistanceUnit.km,
      alertsEnabled: json['alertsEnabled'] as bool? ?? true,
      mutedAlertTypes:
          (json['mutedAlertTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      systemNotificationsEnabled:
          json['systemNotificationsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit]!,
      'alertsEnabled': instance.alertsEnabled,
      'mutedAlertTypes': instance.mutedAlertTypes,
      'systemNotificationsEnabled': instance.systemNotificationsEnabled,
    };

const _$DistanceUnitEnumMap = {DistanceUnit.km: 'km', DistanceUnit.miles: 'mi'};
