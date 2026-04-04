// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charging_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargingDtoImpl _$$ChargingDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ChargingDtoImpl(
  id: (json['ID'] as num).toInt(),
  uuid: json['UUID'] as String?,
  addressInfo: json['AddressInfo'] == null
      ? null
      : AddressInfoDto.fromJson(json['AddressInfo'] as Map<String, dynamic>),
  connections: (json['Connections'] as List<dynamic>?)
      ?.map((e) => ConnectionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  numberOfPoints: (json['NumberOfPoints'] as num?)?.toInt(),
  usageType: json['UsageType'] == null
      ? null
      : UsageTypeDto.fromJson(json['UsageType'] as Map<String, dynamic>),
  usageTypeId: (json['UsageTypeID'] as num?)?.toInt(),
  usageCost: json['UsageCost'] as String?,
  statusType: json['StatusType'] == null
      ? null
      : StatusTypeDto.fromJson(json['StatusType'] as Map<String, dynamic>),
  statusTypeId: (json['StatusTypeID'] as num?)?.toInt(),
  operatorInfo: json['OperatorInfo'] == null
      ? null
      : OperatorInfoDto.fromJson(json['OperatorInfo'] as Map<String, dynamic>),
  operatorId: (json['OperatorID'] as num?)?.toInt(),
  generalComments: json['GeneralComments'] as String?,
  dateLastVerified: json['DateLastVerified'] as String?,
  dateLastStatusUpdate: json['DateLastStatusUpdate'] as String?,
  isRecentlyVerified: json['IsRecentlyVerified'] as bool?,
);

Map<String, dynamic> _$$ChargingDtoImplToJson(_$ChargingDtoImpl instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'UUID': instance.uuid,
      'AddressInfo': instance.addressInfo,
      'Connections': instance.connections,
      'NumberOfPoints': instance.numberOfPoints,
      'UsageType': instance.usageType,
      'UsageTypeID': instance.usageTypeId,
      'UsageCost': instance.usageCost,
      'StatusType': instance.statusType,
      'StatusTypeID': instance.statusTypeId,
      'OperatorInfo': instance.operatorInfo,
      'OperatorID': instance.operatorId,
      'GeneralComments': instance.generalComments,
      'DateLastVerified': instance.dateLastVerified,
      'DateLastStatusUpdate': instance.dateLastStatusUpdate,
      'IsRecentlyVerified': instance.isRecentlyVerified,
    };

_$AddressInfoDtoImpl _$$AddressInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$AddressInfoDtoImpl(
      id: (json['ID'] as num?)?.toInt(),
      title: json['Title'] as String?,
      addressLine1: json['AddressLine1'] as String?,
      addressLine2: json['AddressLine2'] as String?,
      town: json['Town'] as String?,
      stateOrProvince: json['StateOrProvince'] as String?,
      postcode: json['Postcode'] as String?,
      latitude: (json['Latitude'] as num?)?.toDouble(),
      longitude: (json['Longitude'] as num?)?.toDouble(),
      distance: (json['Distance'] as num?)?.toDouble(),
      distanceUnit: (json['DistanceUnit'] as num?)?.toInt(),
      country: json['Country'] == null
          ? null
          : CountryDto.fromJson(json['Country'] as Map<String, dynamic>),
      accessComments: json['AccessComments'] as String?,
      contactTelephone1: json['ContactTelephone1'] as String?,
      relatedUrl: json['RelatedURL'] as String?,
    );

Map<String, dynamic> _$$AddressInfoDtoImplToJson(
  _$AddressInfoDtoImpl instance,
) => <String, dynamic>{
  'ID': instance.id,
  'Title': instance.title,
  'AddressLine1': instance.addressLine1,
  'AddressLine2': instance.addressLine2,
  'Town': instance.town,
  'StateOrProvince': instance.stateOrProvince,
  'Postcode': instance.postcode,
  'Latitude': instance.latitude,
  'Longitude': instance.longitude,
  'Distance': instance.distance,
  'DistanceUnit': instance.distanceUnit,
  'Country': instance.country,
  'AccessComments': instance.accessComments,
  'ContactTelephone1': instance.contactTelephone1,
  'RelatedURL': instance.relatedUrl,
};

_$CountryDtoImpl _$$CountryDtoImplFromJson(Map<String, dynamic> json) =>
    _$CountryDtoImpl(
      id: (json['ID'] as num?)?.toInt(),
      title: json['Title'] as String?,
      isoCode: json['ISOCode'] as String?,
      continentCode: json['ContinentCode'] as String?,
    );

Map<String, dynamic> _$$CountryDtoImplToJson(_$CountryDtoImpl instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Title': instance.title,
      'ISOCode': instance.isoCode,
      'ContinentCode': instance.continentCode,
    };

_$ConnectionDtoImpl _$$ConnectionDtoImplFromJson(Map<String, dynamic> json) =>
    _$ConnectionDtoImpl(
      id: (json['ID'] as num?)?.toInt(),
      connectionTypeId: (json['ConnectionTypeID'] as num?)?.toInt(),
      connectionType: json['ConnectionType'] == null
          ? null
          : ConnectionTypeDto.fromJson(
              json['ConnectionType'] as Map<String, dynamic>,
            ),
      statusTypeId: (json['StatusTypeID'] as num?)?.toInt(),
      statusType: json['StatusType'] == null
          ? null
          : StatusTypeDto.fromJson(json['StatusType'] as Map<String, dynamic>),
      levelId: (json['LevelID'] as num?)?.toInt(),
      level: json['Level'] == null
          ? null
          : ChargingLevelDto.fromJson(json['Level'] as Map<String, dynamic>),
      powerKw: (json['PowerKW'] as num?)?.toDouble(),
      amps: (json['Amps'] as num?)?.toInt(),
      voltage: (json['Voltage'] as num?)?.toInt(),
      currentTypeId: (json['CurrentTypeID'] as num?)?.toInt(),
      currentType: json['CurrentType'] == null
          ? null
          : CurrentTypeDto.fromJson(
              json['CurrentType'] as Map<String, dynamic>,
            ),
      quantity: (json['Quantity'] as num?)?.toInt(),
      comments: json['Comments'] as String?,
    );

Map<String, dynamic> _$$ConnectionDtoImplToJson(_$ConnectionDtoImpl instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'ConnectionTypeID': instance.connectionTypeId,
      'ConnectionType': instance.connectionType,
      'StatusTypeID': instance.statusTypeId,
      'StatusType': instance.statusType,
      'LevelID': instance.levelId,
      'Level': instance.level,
      'PowerKW': instance.powerKw,
      'Amps': instance.amps,
      'Voltage': instance.voltage,
      'CurrentTypeID': instance.currentTypeId,
      'CurrentType': instance.currentType,
      'Quantity': instance.quantity,
      'Comments': instance.comments,
    };

_$ConnectionTypeDtoImpl _$$ConnectionTypeDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ConnectionTypeDtoImpl(
  id: (json['ID'] as num?)?.toInt(),
  title: json['Title'] as String?,
  formalName: json['FormalName'] as String?,
  isDiscontinued: json['IsDiscontinued'] as bool?,
  isObsolete: json['IsObsolete'] as bool?,
);

Map<String, dynamic> _$$ConnectionTypeDtoImplToJson(
  _$ConnectionTypeDtoImpl instance,
) => <String, dynamic>{
  'ID': instance.id,
  'Title': instance.title,
  'FormalName': instance.formalName,
  'IsDiscontinued': instance.isDiscontinued,
  'IsObsolete': instance.isObsolete,
};

_$ChargingLevelDtoImpl _$$ChargingLevelDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ChargingLevelDtoImpl(
  id: (json['ID'] as num?)?.toInt(),
  title: json['Title'] as String?,
  comments: json['Comments'] as String?,
  isFastChargeCapable: json['IsFastChargeCapable'] as bool?,
);

Map<String, dynamic> _$$ChargingLevelDtoImplToJson(
  _$ChargingLevelDtoImpl instance,
) => <String, dynamic>{
  'ID': instance.id,
  'Title': instance.title,
  'Comments': instance.comments,
  'IsFastChargeCapable': instance.isFastChargeCapable,
};

_$CurrentTypeDtoImpl _$$CurrentTypeDtoImplFromJson(Map<String, dynamic> json) =>
    _$CurrentTypeDtoImpl(
      id: (json['ID'] as num?)?.toInt(),
      title: json['Title'] as String?,
      description: json['Description'] as String?,
    );

Map<String, dynamic> _$$CurrentTypeDtoImplToJson(
  _$CurrentTypeDtoImpl instance,
) => <String, dynamic>{
  'ID': instance.id,
  'Title': instance.title,
  'Description': instance.description,
};

_$UsageTypeDtoImpl _$$UsageTypeDtoImplFromJson(Map<String, dynamic> json) =>
    _$UsageTypeDtoImpl(
      id: (json['ID'] as num?)?.toInt(),
      title: json['Title'] as String?,
      isPayAtLocation: json['IsPayAtLocation'] as bool?,
      isMembershipRequired: json['IsMembershipRequired'] as bool?,
      isAccessKeyRequired: json['IsAccessKeyRequired'] as bool?,
    );

Map<String, dynamic> _$$UsageTypeDtoImplToJson(_$UsageTypeDtoImpl instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Title': instance.title,
      'IsPayAtLocation': instance.isPayAtLocation,
      'IsMembershipRequired': instance.isMembershipRequired,
      'IsAccessKeyRequired': instance.isAccessKeyRequired,
    };

_$StatusTypeDtoImpl _$$StatusTypeDtoImplFromJson(Map<String, dynamic> json) =>
    _$StatusTypeDtoImpl(
      id: (json['ID'] as num?)?.toInt(),
      title: json['Title'] as String?,
      isOperational: json['IsOperational'] as bool?,
      isUserSelectable: json['IsUserSelectable'] as bool?,
    );

Map<String, dynamic> _$$StatusTypeDtoImplToJson(_$StatusTypeDtoImpl instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Title': instance.title,
      'IsOperational': instance.isOperational,
      'IsUserSelectable': instance.isUserSelectable,
    };

_$OperatorInfoDtoImpl _$$OperatorInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OperatorInfoDtoImpl(
  id: (json['ID'] as num?)?.toInt(),
  title: json['Title'] as String?,
  websiteUrl: json['WebsiteURL'] as String?,
  phonePrimaryContact: json['PhonePrimaryContact'] as String?,
  contactEmail: json['ContactEmail'] as String?,
  isPrivateIndividual: json['IsPrivateIndividual'] as bool?,
);

Map<String, dynamic> _$$OperatorInfoDtoImplToJson(
  _$OperatorInfoDtoImpl instance,
) => <String, dynamic>{
  'ID': instance.id,
  'Title': instance.title,
  'WebsiteURL': instance.websiteUrl,
  'PhonePrimaryContact': instance.phonePrimaryContact,
  'ContactEmail': instance.contactEmail,
  'IsPrivateIndividual': instance.isPrivateIndividual,
};
