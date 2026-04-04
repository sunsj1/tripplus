// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charging_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargingStationImpl _$$ChargingStationImplFromJson(
  Map<String, dynamic> json,
) => _$ChargingStationImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  uuid: json['uuid'] as String?,
  address: json['address'] as String?,
  addressLine2: json['addressLine2'] as String?,
  town: json['town'] as String?,
  stateOrProvince: json['stateOrProvince'] as String?,
  country: json['country'] as String?,
  countryCode: json['countryCode'] as String?,
  postcode: json['postcode'] as String?,
  numberOfPoints: (json['numberOfPoints'] as num?)?.toInt(),
  usageType: json['usageType'] as String?,
  usageCost: json['usageCost'] as String?,
  statusType: json['statusType'] as String?,
  isOperational: json['isOperational'] as bool?,
  operatorName: json['operatorName'] as String?,
  operatorWebsite: json['operatorWebsite'] as String?,
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  generalComments: json['generalComments'] as String?,
  accessComments: json['accessComments'] as String?,
  contactPhone: json['contactPhone'] as String?,
  dateLastVerified: json['dateLastVerified'] as String?,
  isRecentlyVerified: json['isRecentlyVerified'] as bool?,
  connections:
      (json['connections'] as List<dynamic>?)
          ?.map((e) => Connection.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  dataSource: json['dataSource'] as String? ?? 'ocm',
);

Map<String, dynamic> _$$ChargingStationImplToJson(
  _$ChargingStationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'uuid': instance.uuid,
  'address': instance.address,
  'addressLine2': instance.addressLine2,
  'town': instance.town,
  'stateOrProvince': instance.stateOrProvince,
  'country': instance.country,
  'countryCode': instance.countryCode,
  'postcode': instance.postcode,
  'numberOfPoints': instance.numberOfPoints,
  'usageType': instance.usageType,
  'usageCost': instance.usageCost,
  'statusType': instance.statusType,
  'isOperational': instance.isOperational,
  'operatorName': instance.operatorName,
  'operatorWebsite': instance.operatorWebsite,
  'distanceKm': instance.distanceKm,
  'generalComments': instance.generalComments,
  'accessComments': instance.accessComments,
  'contactPhone': instance.contactPhone,
  'dateLastVerified': instance.dateLastVerified,
  'isRecentlyVerified': instance.isRecentlyVerified,
  'connections': instance.connections,
  'dataSource': instance.dataSource,
};

_$ConnectionImpl _$$ConnectionImplFromJson(Map<String, dynamic> json) =>
    _$ConnectionImpl(
      id: (json['id'] as num?)?.toInt(),
      connectionType: json['connectionType'] as String?,
      formalName: json['formalName'] as String?,
      level: json['level'] as String?,
      isFastCharge: json['isFastCharge'] as bool?,
      powerKw: (json['powerKw'] as num?)?.toDouble(),
      amps: (json['amps'] as num?)?.toInt(),
      voltage: (json['voltage'] as num?)?.toInt(),
      currentType: json['currentType'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      statusType: json['statusType'] as String?,
      isOperational: json['isOperational'] as bool?,
    );

Map<String, dynamic> _$$ConnectionImplToJson(_$ConnectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'connectionType': instance.connectionType,
      'formalName': instance.formalName,
      'level': instance.level,
      'isFastCharge': instance.isFastCharge,
      'powerKw': instance.powerKw,
      'amps': instance.amps,
      'voltage': instance.voltage,
      'currentType': instance.currentType,
      'quantity': instance.quantity,
      'statusType': instance.statusType,
      'isOperational': instance.isOperational,
    };
