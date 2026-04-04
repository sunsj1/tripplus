import 'package:freezed_annotation/freezed_annotation.dart';

part 'charging_dto.freezed.dart';
part 'charging_dto.g.dart';

@freezed
abstract class ChargingDto with _$ChargingDto {
  const factory ChargingDto({
    @JsonKey(name: 'ID') required int id,
    @JsonKey(name: 'UUID') String? uuid,
    @JsonKey(name: 'AddressInfo') AddressInfoDto? addressInfo,
    @JsonKey(name: 'Connections') List<ConnectionDto>? connections,
    @JsonKey(name: 'NumberOfPoints') int? numberOfPoints,
    @JsonKey(name: 'UsageType') UsageTypeDto? usageType,
    @JsonKey(name: 'UsageTypeID') int? usageTypeId,
    @JsonKey(name: 'UsageCost') String? usageCost,
    @JsonKey(name: 'StatusType') StatusTypeDto? statusType,
    @JsonKey(name: 'StatusTypeID') int? statusTypeId,
    @JsonKey(name: 'OperatorInfo') OperatorInfoDto? operatorInfo,
    @JsonKey(name: 'OperatorID') int? operatorId,
    @JsonKey(name: 'GeneralComments') String? generalComments,
    @JsonKey(name: 'DateLastVerified') String? dateLastVerified,
    @JsonKey(name: 'DateLastStatusUpdate') String? dateLastStatusUpdate,
    @JsonKey(name: 'IsRecentlyVerified') bool? isRecentlyVerified,
  }) = _ChargingDto;

  factory ChargingDto.fromJson(Map<String, dynamic> json) =>
      _$ChargingDtoFromJson(json);
}

@freezed
abstract class AddressInfoDto with _$AddressInfoDto {
  const factory AddressInfoDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'AddressLine1') String? addressLine1,
    @JsonKey(name: 'AddressLine2') String? addressLine2,
    @JsonKey(name: 'Town') String? town,
    @JsonKey(name: 'StateOrProvince') String? stateOrProvince,
    @JsonKey(name: 'Postcode') String? postcode,
    @JsonKey(name: 'Latitude') double? latitude,
    @JsonKey(name: 'Longitude') double? longitude,
    @JsonKey(name: 'Distance') double? distance,
    @JsonKey(name: 'DistanceUnit') int? distanceUnit,
    @JsonKey(name: 'Country') CountryDto? country,
    @JsonKey(name: 'AccessComments') String? accessComments,
    @JsonKey(name: 'ContactTelephone1') String? contactTelephone1,
    @JsonKey(name: 'RelatedURL') String? relatedUrl,
  }) = _AddressInfoDto;

  factory AddressInfoDto.fromJson(Map<String, dynamic> json) =>
      _$AddressInfoDtoFromJson(json);
}

@freezed
abstract class CountryDto with _$CountryDto {
  const factory CountryDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'ISOCode') String? isoCode,
    @JsonKey(name: 'ContinentCode') String? continentCode,
  }) = _CountryDto;

  factory CountryDto.fromJson(Map<String, dynamic> json) =>
      _$CountryDtoFromJson(json);
}

@freezed
abstract class ConnectionDto with _$ConnectionDto {
  const factory ConnectionDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'ConnectionTypeID') int? connectionTypeId,
    @JsonKey(name: 'ConnectionType') ConnectionTypeDto? connectionType,
    @JsonKey(name: 'StatusTypeID') int? statusTypeId,
    @JsonKey(name: 'StatusType') StatusTypeDto? statusType,
    @JsonKey(name: 'LevelID') int? levelId,
    @JsonKey(name: 'Level') ChargingLevelDto? level,
    @JsonKey(name: 'PowerKW') double? powerKw,
    @JsonKey(name: 'Amps') int? amps,
    @JsonKey(name: 'Voltage') int? voltage,
    @JsonKey(name: 'CurrentTypeID') int? currentTypeId,
    @JsonKey(name: 'CurrentType') CurrentTypeDto? currentType,
    @JsonKey(name: 'Quantity') int? quantity,
    @JsonKey(name: 'Comments') String? comments,
  }) = _ConnectionDto;

  factory ConnectionDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectionDtoFromJson(json);
}

@freezed
abstract class ConnectionTypeDto with _$ConnectionTypeDto {
  const factory ConnectionTypeDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'FormalName') String? formalName,
    @JsonKey(name: 'IsDiscontinued') bool? isDiscontinued,
    @JsonKey(name: 'IsObsolete') bool? isObsolete,
  }) = _ConnectionTypeDto;

  factory ConnectionTypeDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectionTypeDtoFromJson(json);
}

@freezed
abstract class ChargingLevelDto with _$ChargingLevelDto {
  const factory ChargingLevelDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'Comments') String? comments,
    @JsonKey(name: 'IsFastChargeCapable') bool? isFastChargeCapable,
  }) = _ChargingLevelDto;

  factory ChargingLevelDto.fromJson(Map<String, dynamic> json) =>
      _$ChargingLevelDtoFromJson(json);
}

@freezed
abstract class CurrentTypeDto with _$CurrentTypeDto {
  const factory CurrentTypeDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'Description') String? description,
  }) = _CurrentTypeDto;

  factory CurrentTypeDto.fromJson(Map<String, dynamic> json) =>
      _$CurrentTypeDtoFromJson(json);
}

@freezed
abstract class UsageTypeDto with _$UsageTypeDto {
  const factory UsageTypeDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'IsPayAtLocation') bool? isPayAtLocation,
    @JsonKey(name: 'IsMembershipRequired') bool? isMembershipRequired,
    @JsonKey(name: 'IsAccessKeyRequired') bool? isAccessKeyRequired,
  }) = _UsageTypeDto;

  factory UsageTypeDto.fromJson(Map<String, dynamic> json) =>
      _$UsageTypeDtoFromJson(json);
}

@freezed
abstract class StatusTypeDto with _$StatusTypeDto {
  const factory StatusTypeDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'IsOperational') bool? isOperational,
    @JsonKey(name: 'IsUserSelectable') bool? isUserSelectable,
  }) = _StatusTypeDto;

  factory StatusTypeDto.fromJson(Map<String, dynamic> json) =>
      _$StatusTypeDtoFromJson(json);
}

@freezed
abstract class OperatorInfoDto with _$OperatorInfoDto {
  const factory OperatorInfoDto({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'WebsiteURL') String? websiteUrl,
    @JsonKey(name: 'PhonePrimaryContact') String? phonePrimaryContact,
    @JsonKey(name: 'ContactEmail') String? contactEmail,
    @JsonKey(name: 'IsPrivateIndividual') bool? isPrivateIndividual,
  }) = _OperatorInfoDto;

  factory OperatorInfoDto.fromJson(Map<String, dynamic> json) =>
      _$OperatorInfoDtoFromJson(json);
}
