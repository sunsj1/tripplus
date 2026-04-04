// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charging_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChargingDto _$ChargingDtoFromJson(Map<String, dynamic> json) {
  return _ChargingDto.fromJson(json);
}

/// @nodoc
mixin _$ChargingDto {
  @JsonKey(name: 'ID')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UUID')
  String? get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'AddressInfo')
  AddressInfoDto? get addressInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'Connections')
  List<ConnectionDto>? get connections => throw _privateConstructorUsedError;
  @JsonKey(name: 'NumberOfPoints')
  int? get numberOfPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'UsageType')
  UsageTypeDto? get usageType => throw _privateConstructorUsedError;
  @JsonKey(name: 'UsageTypeID')
  int? get usageTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'UsageCost')
  String? get usageCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'StatusType')
  StatusTypeDto? get statusType => throw _privateConstructorUsedError;
  @JsonKey(name: 'StatusTypeID')
  int? get statusTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'OperatorInfo')
  OperatorInfoDto? get operatorInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'OperatorID')
  int? get operatorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'GeneralComments')
  String? get generalComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'DateLastVerified')
  String? get dateLastVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'DateLastStatusUpdate')
  String? get dateLastStatusUpdate => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsRecentlyVerified')
  bool? get isRecentlyVerified => throw _privateConstructorUsedError;

  /// Serializes this ChargingDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargingDtoCopyWith<ChargingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargingDtoCopyWith<$Res> {
  factory $ChargingDtoCopyWith(
    ChargingDto value,
    $Res Function(ChargingDto) then,
  ) = _$ChargingDtoCopyWithImpl<$Res, ChargingDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int id,
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
  });

  $AddressInfoDtoCopyWith<$Res>? get addressInfo;
  $UsageTypeDtoCopyWith<$Res>? get usageType;
  $StatusTypeDtoCopyWith<$Res>? get statusType;
  $OperatorInfoDtoCopyWith<$Res>? get operatorInfo;
}

/// @nodoc
class _$ChargingDtoCopyWithImpl<$Res, $Val extends ChargingDto>
    implements $ChargingDtoCopyWith<$Res> {
  _$ChargingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? addressInfo = freezed,
    Object? connections = freezed,
    Object? numberOfPoints = freezed,
    Object? usageType = freezed,
    Object? usageTypeId = freezed,
    Object? usageCost = freezed,
    Object? statusType = freezed,
    Object? statusTypeId = freezed,
    Object? operatorInfo = freezed,
    Object? operatorId = freezed,
    Object? generalComments = freezed,
    Object? dateLastVerified = freezed,
    Object? dateLastStatusUpdate = freezed,
    Object? isRecentlyVerified = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            uuid: freezed == uuid
                ? _value.uuid
                : uuid // ignore: cast_nullable_to_non_nullable
                      as String?,
            addressInfo: freezed == addressInfo
                ? _value.addressInfo
                : addressInfo // ignore: cast_nullable_to_non_nullable
                      as AddressInfoDto?,
            connections: freezed == connections
                ? _value.connections
                : connections // ignore: cast_nullable_to_non_nullable
                      as List<ConnectionDto>?,
            numberOfPoints: freezed == numberOfPoints
                ? _value.numberOfPoints
                : numberOfPoints // ignore: cast_nullable_to_non_nullable
                      as int?,
            usageType: freezed == usageType
                ? _value.usageType
                : usageType // ignore: cast_nullable_to_non_nullable
                      as UsageTypeDto?,
            usageTypeId: freezed == usageTypeId
                ? _value.usageTypeId
                : usageTypeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            usageCost: freezed == usageCost
                ? _value.usageCost
                : usageCost // ignore: cast_nullable_to_non_nullable
                      as String?,
            statusType: freezed == statusType
                ? _value.statusType
                : statusType // ignore: cast_nullable_to_non_nullable
                      as StatusTypeDto?,
            statusTypeId: freezed == statusTypeId
                ? _value.statusTypeId
                : statusTypeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            operatorInfo: freezed == operatorInfo
                ? _value.operatorInfo
                : operatorInfo // ignore: cast_nullable_to_non_nullable
                      as OperatorInfoDto?,
            operatorId: freezed == operatorId
                ? _value.operatorId
                : operatorId // ignore: cast_nullable_to_non_nullable
                      as int?,
            generalComments: freezed == generalComments
                ? _value.generalComments
                : generalComments // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateLastVerified: freezed == dateLastVerified
                ? _value.dateLastVerified
                : dateLastVerified // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateLastStatusUpdate: freezed == dateLastStatusUpdate
                ? _value.dateLastStatusUpdate
                : dateLastStatusUpdate // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRecentlyVerified: freezed == isRecentlyVerified
                ? _value.isRecentlyVerified
                : isRecentlyVerified // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressInfoDtoCopyWith<$Res>? get addressInfo {
    if (_value.addressInfo == null) {
      return null;
    }

    return $AddressInfoDtoCopyWith<$Res>(_value.addressInfo!, (value) {
      return _then(_value.copyWith(addressInfo: value) as $Val);
    });
  }

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageTypeDtoCopyWith<$Res>? get usageType {
    if (_value.usageType == null) {
      return null;
    }

    return $UsageTypeDtoCopyWith<$Res>(_value.usageType!, (value) {
      return _then(_value.copyWith(usageType: value) as $Val);
    });
  }

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StatusTypeDtoCopyWith<$Res>? get statusType {
    if (_value.statusType == null) {
      return null;
    }

    return $StatusTypeDtoCopyWith<$Res>(_value.statusType!, (value) {
      return _then(_value.copyWith(statusType: value) as $Val);
    });
  }

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OperatorInfoDtoCopyWith<$Res>? get operatorInfo {
    if (_value.operatorInfo == null) {
      return null;
    }

    return $OperatorInfoDtoCopyWith<$Res>(_value.operatorInfo!, (value) {
      return _then(_value.copyWith(operatorInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChargingDtoImplCopyWith<$Res>
    implements $ChargingDtoCopyWith<$Res> {
  factory _$$ChargingDtoImplCopyWith(
    _$ChargingDtoImpl value,
    $Res Function(_$ChargingDtoImpl) then,
  ) = __$$ChargingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int id,
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
  });

  @override
  $AddressInfoDtoCopyWith<$Res>? get addressInfo;
  @override
  $UsageTypeDtoCopyWith<$Res>? get usageType;
  @override
  $StatusTypeDtoCopyWith<$Res>? get statusType;
  @override
  $OperatorInfoDtoCopyWith<$Res>? get operatorInfo;
}

/// @nodoc
class __$$ChargingDtoImplCopyWithImpl<$Res>
    extends _$ChargingDtoCopyWithImpl<$Res, _$ChargingDtoImpl>
    implements _$$ChargingDtoImplCopyWith<$Res> {
  __$$ChargingDtoImplCopyWithImpl(
    _$ChargingDtoImpl _value,
    $Res Function(_$ChargingDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? addressInfo = freezed,
    Object? connections = freezed,
    Object? numberOfPoints = freezed,
    Object? usageType = freezed,
    Object? usageTypeId = freezed,
    Object? usageCost = freezed,
    Object? statusType = freezed,
    Object? statusTypeId = freezed,
    Object? operatorInfo = freezed,
    Object? operatorId = freezed,
    Object? generalComments = freezed,
    Object? dateLastVerified = freezed,
    Object? dateLastStatusUpdate = freezed,
    Object? isRecentlyVerified = freezed,
  }) {
    return _then(
      _$ChargingDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        uuid: freezed == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String?,
        addressInfo: freezed == addressInfo
            ? _value.addressInfo
            : addressInfo // ignore: cast_nullable_to_non_nullable
                  as AddressInfoDto?,
        connections: freezed == connections
            ? _value._connections
            : connections // ignore: cast_nullable_to_non_nullable
                  as List<ConnectionDto>?,
        numberOfPoints: freezed == numberOfPoints
            ? _value.numberOfPoints
            : numberOfPoints // ignore: cast_nullable_to_non_nullable
                  as int?,
        usageType: freezed == usageType
            ? _value.usageType
            : usageType // ignore: cast_nullable_to_non_nullable
                  as UsageTypeDto?,
        usageTypeId: freezed == usageTypeId
            ? _value.usageTypeId
            : usageTypeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        usageCost: freezed == usageCost
            ? _value.usageCost
            : usageCost // ignore: cast_nullable_to_non_nullable
                  as String?,
        statusType: freezed == statusType
            ? _value.statusType
            : statusType // ignore: cast_nullable_to_non_nullable
                  as StatusTypeDto?,
        statusTypeId: freezed == statusTypeId
            ? _value.statusTypeId
            : statusTypeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        operatorInfo: freezed == operatorInfo
            ? _value.operatorInfo
            : operatorInfo // ignore: cast_nullable_to_non_nullable
                  as OperatorInfoDto?,
        operatorId: freezed == operatorId
            ? _value.operatorId
            : operatorId // ignore: cast_nullable_to_non_nullable
                  as int?,
        generalComments: freezed == generalComments
            ? _value.generalComments
            : generalComments // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateLastVerified: freezed == dateLastVerified
            ? _value.dateLastVerified
            : dateLastVerified // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateLastStatusUpdate: freezed == dateLastStatusUpdate
            ? _value.dateLastStatusUpdate
            : dateLastStatusUpdate // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRecentlyVerified: freezed == isRecentlyVerified
            ? _value.isRecentlyVerified
            : isRecentlyVerified // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChargingDtoImpl implements _ChargingDto {
  const _$ChargingDtoImpl({
    @JsonKey(name: 'ID') required this.id,
    @JsonKey(name: 'UUID') this.uuid,
    @JsonKey(name: 'AddressInfo') this.addressInfo,
    @JsonKey(name: 'Connections') final List<ConnectionDto>? connections,
    @JsonKey(name: 'NumberOfPoints') this.numberOfPoints,
    @JsonKey(name: 'UsageType') this.usageType,
    @JsonKey(name: 'UsageTypeID') this.usageTypeId,
    @JsonKey(name: 'UsageCost') this.usageCost,
    @JsonKey(name: 'StatusType') this.statusType,
    @JsonKey(name: 'StatusTypeID') this.statusTypeId,
    @JsonKey(name: 'OperatorInfo') this.operatorInfo,
    @JsonKey(name: 'OperatorID') this.operatorId,
    @JsonKey(name: 'GeneralComments') this.generalComments,
    @JsonKey(name: 'DateLastVerified') this.dateLastVerified,
    @JsonKey(name: 'DateLastStatusUpdate') this.dateLastStatusUpdate,
    @JsonKey(name: 'IsRecentlyVerified') this.isRecentlyVerified,
  }) : _connections = connections;

  factory _$ChargingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargingDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int id;
  @override
  @JsonKey(name: 'UUID')
  final String? uuid;
  @override
  @JsonKey(name: 'AddressInfo')
  final AddressInfoDto? addressInfo;
  final List<ConnectionDto>? _connections;
  @override
  @JsonKey(name: 'Connections')
  List<ConnectionDto>? get connections {
    final value = _connections;
    if (value == null) return null;
    if (_connections is EqualUnmodifiableListView) return _connections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'NumberOfPoints')
  final int? numberOfPoints;
  @override
  @JsonKey(name: 'UsageType')
  final UsageTypeDto? usageType;
  @override
  @JsonKey(name: 'UsageTypeID')
  final int? usageTypeId;
  @override
  @JsonKey(name: 'UsageCost')
  final String? usageCost;
  @override
  @JsonKey(name: 'StatusType')
  final StatusTypeDto? statusType;
  @override
  @JsonKey(name: 'StatusTypeID')
  final int? statusTypeId;
  @override
  @JsonKey(name: 'OperatorInfo')
  final OperatorInfoDto? operatorInfo;
  @override
  @JsonKey(name: 'OperatorID')
  final int? operatorId;
  @override
  @JsonKey(name: 'GeneralComments')
  final String? generalComments;
  @override
  @JsonKey(name: 'DateLastVerified')
  final String? dateLastVerified;
  @override
  @JsonKey(name: 'DateLastStatusUpdate')
  final String? dateLastStatusUpdate;
  @override
  @JsonKey(name: 'IsRecentlyVerified')
  final bool? isRecentlyVerified;

  @override
  String toString() {
    return 'ChargingDto(id: $id, uuid: $uuid, addressInfo: $addressInfo, connections: $connections, numberOfPoints: $numberOfPoints, usageType: $usageType, usageTypeId: $usageTypeId, usageCost: $usageCost, statusType: $statusType, statusTypeId: $statusTypeId, operatorInfo: $operatorInfo, operatorId: $operatorId, generalComments: $generalComments, dateLastVerified: $dateLastVerified, dateLastStatusUpdate: $dateLastStatusUpdate, isRecentlyVerified: $isRecentlyVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargingDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.addressInfo, addressInfo) ||
                other.addressInfo == addressInfo) &&
            const DeepCollectionEquality().equals(
              other._connections,
              _connections,
            ) &&
            (identical(other.numberOfPoints, numberOfPoints) ||
                other.numberOfPoints == numberOfPoints) &&
            (identical(other.usageType, usageType) ||
                other.usageType == usageType) &&
            (identical(other.usageTypeId, usageTypeId) ||
                other.usageTypeId == usageTypeId) &&
            (identical(other.usageCost, usageCost) ||
                other.usageCost == usageCost) &&
            (identical(other.statusType, statusType) ||
                other.statusType == statusType) &&
            (identical(other.statusTypeId, statusTypeId) ||
                other.statusTypeId == statusTypeId) &&
            (identical(other.operatorInfo, operatorInfo) ||
                other.operatorInfo == operatorInfo) &&
            (identical(other.operatorId, operatorId) ||
                other.operatorId == operatorId) &&
            (identical(other.generalComments, generalComments) ||
                other.generalComments == generalComments) &&
            (identical(other.dateLastVerified, dateLastVerified) ||
                other.dateLastVerified == dateLastVerified) &&
            (identical(other.dateLastStatusUpdate, dateLastStatusUpdate) ||
                other.dateLastStatusUpdate == dateLastStatusUpdate) &&
            (identical(other.isRecentlyVerified, isRecentlyVerified) ||
                other.isRecentlyVerified == isRecentlyVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    uuid,
    addressInfo,
    const DeepCollectionEquality().hash(_connections),
    numberOfPoints,
    usageType,
    usageTypeId,
    usageCost,
    statusType,
    statusTypeId,
    operatorInfo,
    operatorId,
    generalComments,
    dateLastVerified,
    dateLastStatusUpdate,
    isRecentlyVerified,
  );

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargingDtoImplCopyWith<_$ChargingDtoImpl> get copyWith =>
      __$$ChargingDtoImplCopyWithImpl<_$ChargingDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargingDtoImplToJson(this);
  }
}

abstract class _ChargingDto implements ChargingDto {
  const factory _ChargingDto({
    @JsonKey(name: 'ID') required final int id,
    @JsonKey(name: 'UUID') final String? uuid,
    @JsonKey(name: 'AddressInfo') final AddressInfoDto? addressInfo,
    @JsonKey(name: 'Connections') final List<ConnectionDto>? connections,
    @JsonKey(name: 'NumberOfPoints') final int? numberOfPoints,
    @JsonKey(name: 'UsageType') final UsageTypeDto? usageType,
    @JsonKey(name: 'UsageTypeID') final int? usageTypeId,
    @JsonKey(name: 'UsageCost') final String? usageCost,
    @JsonKey(name: 'StatusType') final StatusTypeDto? statusType,
    @JsonKey(name: 'StatusTypeID') final int? statusTypeId,
    @JsonKey(name: 'OperatorInfo') final OperatorInfoDto? operatorInfo,
    @JsonKey(name: 'OperatorID') final int? operatorId,
    @JsonKey(name: 'GeneralComments') final String? generalComments,
    @JsonKey(name: 'DateLastVerified') final String? dateLastVerified,
    @JsonKey(name: 'DateLastStatusUpdate') final String? dateLastStatusUpdate,
    @JsonKey(name: 'IsRecentlyVerified') final bool? isRecentlyVerified,
  }) = _$ChargingDtoImpl;

  factory _ChargingDto.fromJson(Map<String, dynamic> json) =
      _$ChargingDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int get id;
  @override
  @JsonKey(name: 'UUID')
  String? get uuid;
  @override
  @JsonKey(name: 'AddressInfo')
  AddressInfoDto? get addressInfo;
  @override
  @JsonKey(name: 'Connections')
  List<ConnectionDto>? get connections;
  @override
  @JsonKey(name: 'NumberOfPoints')
  int? get numberOfPoints;
  @override
  @JsonKey(name: 'UsageType')
  UsageTypeDto? get usageType;
  @override
  @JsonKey(name: 'UsageTypeID')
  int? get usageTypeId;
  @override
  @JsonKey(name: 'UsageCost')
  String? get usageCost;
  @override
  @JsonKey(name: 'StatusType')
  StatusTypeDto? get statusType;
  @override
  @JsonKey(name: 'StatusTypeID')
  int? get statusTypeId;
  @override
  @JsonKey(name: 'OperatorInfo')
  OperatorInfoDto? get operatorInfo;
  @override
  @JsonKey(name: 'OperatorID')
  int? get operatorId;
  @override
  @JsonKey(name: 'GeneralComments')
  String? get generalComments;
  @override
  @JsonKey(name: 'DateLastVerified')
  String? get dateLastVerified;
  @override
  @JsonKey(name: 'DateLastStatusUpdate')
  String? get dateLastStatusUpdate;
  @override
  @JsonKey(name: 'IsRecentlyVerified')
  bool? get isRecentlyVerified;

  /// Create a copy of ChargingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargingDtoImplCopyWith<_$ChargingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressInfoDto _$AddressInfoDtoFromJson(Map<String, dynamic> json) {
  return _AddressInfoDto.fromJson(json);
}

/// @nodoc
mixin _$AddressInfoDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'AddressLine1')
  String? get addressLine1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'AddressLine2')
  String? get addressLine2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'Town')
  String? get town => throw _privateConstructorUsedError;
  @JsonKey(name: 'StateOrProvince')
  String? get stateOrProvince => throw _privateConstructorUsedError;
  @JsonKey(name: 'Postcode')
  String? get postcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'Latitude')
  double? get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'Longitude')
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'Distance')
  double? get distance => throw _privateConstructorUsedError;
  @JsonKey(name: 'DistanceUnit')
  int? get distanceUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'Country')
  CountryDto? get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'AccessComments')
  String? get accessComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'ContactTelephone1')
  String? get contactTelephone1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'RelatedURL')
  String? get relatedUrl => throw _privateConstructorUsedError;

  /// Serializes this AddressInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressInfoDtoCopyWith<AddressInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressInfoDtoCopyWith<$Res> {
  factory $AddressInfoDtoCopyWith(
    AddressInfoDto value,
    $Res Function(AddressInfoDto) then,
  ) = _$AddressInfoDtoCopyWithImpl<$Res, AddressInfoDto>;
  @useResult
  $Res call({
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
  });

  $CountryDtoCopyWith<$Res>? get country;
}

/// @nodoc
class _$AddressInfoDtoCopyWithImpl<$Res, $Val extends AddressInfoDto>
    implements $AddressInfoDtoCopyWith<$Res> {
  _$AddressInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? addressLine1 = freezed,
    Object? addressLine2 = freezed,
    Object? town = freezed,
    Object? stateOrProvince = freezed,
    Object? postcode = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? distance = freezed,
    Object? distanceUnit = freezed,
    Object? country = freezed,
    Object? accessComments = freezed,
    Object? contactTelephone1 = freezed,
    Object? relatedUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            addressLine1: freezed == addressLine1
                ? _value.addressLine1
                : addressLine1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            addressLine2: freezed == addressLine2
                ? _value.addressLine2
                : addressLine2 // ignore: cast_nullable_to_non_nullable
                      as String?,
            town: freezed == town
                ? _value.town
                : town // ignore: cast_nullable_to_non_nullable
                      as String?,
            stateOrProvince: freezed == stateOrProvince
                ? _value.stateOrProvince
                : stateOrProvince // ignore: cast_nullable_to_non_nullable
                      as String?,
            postcode: freezed == postcode
                ? _value.postcode
                : postcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            distance: freezed == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double?,
            distanceUnit: freezed == distanceUnit
                ? _value.distanceUnit
                : distanceUnit // ignore: cast_nullable_to_non_nullable
                      as int?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as CountryDto?,
            accessComments: freezed == accessComments
                ? _value.accessComments
                : accessComments // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactTelephone1: freezed == contactTelephone1
                ? _value.contactTelephone1
                : contactTelephone1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            relatedUrl: freezed == relatedUrl
                ? _value.relatedUrl
                : relatedUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of AddressInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CountryDtoCopyWith<$Res>? get country {
    if (_value.country == null) {
      return null;
    }

    return $CountryDtoCopyWith<$Res>(_value.country!, (value) {
      return _then(_value.copyWith(country: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AddressInfoDtoImplCopyWith<$Res>
    implements $AddressInfoDtoCopyWith<$Res> {
  factory _$$AddressInfoDtoImplCopyWith(
    _$AddressInfoDtoImpl value,
    $Res Function(_$AddressInfoDtoImpl) then,
  ) = __$$AddressInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
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
  });

  @override
  $CountryDtoCopyWith<$Res>? get country;
}

/// @nodoc
class __$$AddressInfoDtoImplCopyWithImpl<$Res>
    extends _$AddressInfoDtoCopyWithImpl<$Res, _$AddressInfoDtoImpl>
    implements _$$AddressInfoDtoImplCopyWith<$Res> {
  __$$AddressInfoDtoImplCopyWithImpl(
    _$AddressInfoDtoImpl _value,
    $Res Function(_$AddressInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddressInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? addressLine1 = freezed,
    Object? addressLine2 = freezed,
    Object? town = freezed,
    Object? stateOrProvince = freezed,
    Object? postcode = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? distance = freezed,
    Object? distanceUnit = freezed,
    Object? country = freezed,
    Object? accessComments = freezed,
    Object? contactTelephone1 = freezed,
    Object? relatedUrl = freezed,
  }) {
    return _then(
      _$AddressInfoDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        addressLine1: freezed == addressLine1
            ? _value.addressLine1
            : addressLine1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        addressLine2: freezed == addressLine2
            ? _value.addressLine2
            : addressLine2 // ignore: cast_nullable_to_non_nullable
                  as String?,
        town: freezed == town
            ? _value.town
            : town // ignore: cast_nullable_to_non_nullable
                  as String?,
        stateOrProvince: freezed == stateOrProvince
            ? _value.stateOrProvince
            : stateOrProvince // ignore: cast_nullable_to_non_nullable
                  as String?,
        postcode: freezed == postcode
            ? _value.postcode
            : postcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        distance: freezed == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double?,
        distanceUnit: freezed == distanceUnit
            ? _value.distanceUnit
            : distanceUnit // ignore: cast_nullable_to_non_nullable
                  as int?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as CountryDto?,
        accessComments: freezed == accessComments
            ? _value.accessComments
            : accessComments // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactTelephone1: freezed == contactTelephone1
            ? _value.contactTelephone1
            : contactTelephone1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        relatedUrl: freezed == relatedUrl
            ? _value.relatedUrl
            : relatedUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressInfoDtoImpl implements _AddressInfoDto {
  const _$AddressInfoDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'Title') this.title,
    @JsonKey(name: 'AddressLine1') this.addressLine1,
    @JsonKey(name: 'AddressLine2') this.addressLine2,
    @JsonKey(name: 'Town') this.town,
    @JsonKey(name: 'StateOrProvince') this.stateOrProvince,
    @JsonKey(name: 'Postcode') this.postcode,
    @JsonKey(name: 'Latitude') this.latitude,
    @JsonKey(name: 'Longitude') this.longitude,
    @JsonKey(name: 'Distance') this.distance,
    @JsonKey(name: 'DistanceUnit') this.distanceUnit,
    @JsonKey(name: 'Country') this.country,
    @JsonKey(name: 'AccessComments') this.accessComments,
    @JsonKey(name: 'ContactTelephone1') this.contactTelephone1,
    @JsonKey(name: 'RelatedURL') this.relatedUrl,
  });

  factory _$AddressInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'AddressLine1')
  final String? addressLine1;
  @override
  @JsonKey(name: 'AddressLine2')
  final String? addressLine2;
  @override
  @JsonKey(name: 'Town')
  final String? town;
  @override
  @JsonKey(name: 'StateOrProvince')
  final String? stateOrProvince;
  @override
  @JsonKey(name: 'Postcode')
  final String? postcode;
  @override
  @JsonKey(name: 'Latitude')
  final double? latitude;
  @override
  @JsonKey(name: 'Longitude')
  final double? longitude;
  @override
  @JsonKey(name: 'Distance')
  final double? distance;
  @override
  @JsonKey(name: 'DistanceUnit')
  final int? distanceUnit;
  @override
  @JsonKey(name: 'Country')
  final CountryDto? country;
  @override
  @JsonKey(name: 'AccessComments')
  final String? accessComments;
  @override
  @JsonKey(name: 'ContactTelephone1')
  final String? contactTelephone1;
  @override
  @JsonKey(name: 'RelatedURL')
  final String? relatedUrl;

  @override
  String toString() {
    return 'AddressInfoDto(id: $id, title: $title, addressLine1: $addressLine1, addressLine2: $addressLine2, town: $town, stateOrProvince: $stateOrProvince, postcode: $postcode, latitude: $latitude, longitude: $longitude, distance: $distance, distanceUnit: $distanceUnit, country: $country, accessComments: $accessComments, contactTelephone1: $contactTelephone1, relatedUrl: $relatedUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressInfoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.town, town) || other.town == town) &&
            (identical(other.stateOrProvince, stateOrProvince) ||
                other.stateOrProvince == stateOrProvince) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.distanceUnit, distanceUnit) ||
                other.distanceUnit == distanceUnit) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.accessComments, accessComments) ||
                other.accessComments == accessComments) &&
            (identical(other.contactTelephone1, contactTelephone1) ||
                other.contactTelephone1 == contactTelephone1) &&
            (identical(other.relatedUrl, relatedUrl) ||
                other.relatedUrl == relatedUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    addressLine1,
    addressLine2,
    town,
    stateOrProvince,
    postcode,
    latitude,
    longitude,
    distance,
    distanceUnit,
    country,
    accessComments,
    contactTelephone1,
    relatedUrl,
  );

  /// Create a copy of AddressInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressInfoDtoImplCopyWith<_$AddressInfoDtoImpl> get copyWith =>
      __$$AddressInfoDtoImplCopyWithImpl<_$AddressInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressInfoDtoImplToJson(this);
  }
}

abstract class _AddressInfoDto implements AddressInfoDto {
  const factory _AddressInfoDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'Title') final String? title,
    @JsonKey(name: 'AddressLine1') final String? addressLine1,
    @JsonKey(name: 'AddressLine2') final String? addressLine2,
    @JsonKey(name: 'Town') final String? town,
    @JsonKey(name: 'StateOrProvince') final String? stateOrProvince,
    @JsonKey(name: 'Postcode') final String? postcode,
    @JsonKey(name: 'Latitude') final double? latitude,
    @JsonKey(name: 'Longitude') final double? longitude,
    @JsonKey(name: 'Distance') final double? distance,
    @JsonKey(name: 'DistanceUnit') final int? distanceUnit,
    @JsonKey(name: 'Country') final CountryDto? country,
    @JsonKey(name: 'AccessComments') final String? accessComments,
    @JsonKey(name: 'ContactTelephone1') final String? contactTelephone1,
    @JsonKey(name: 'RelatedURL') final String? relatedUrl,
  }) = _$AddressInfoDtoImpl;

  factory _AddressInfoDto.fromJson(Map<String, dynamic> json) =
      _$AddressInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'AddressLine1')
  String? get addressLine1;
  @override
  @JsonKey(name: 'AddressLine2')
  String? get addressLine2;
  @override
  @JsonKey(name: 'Town')
  String? get town;
  @override
  @JsonKey(name: 'StateOrProvince')
  String? get stateOrProvince;
  @override
  @JsonKey(name: 'Postcode')
  String? get postcode;
  @override
  @JsonKey(name: 'Latitude')
  double? get latitude;
  @override
  @JsonKey(name: 'Longitude')
  double? get longitude;
  @override
  @JsonKey(name: 'Distance')
  double? get distance;
  @override
  @JsonKey(name: 'DistanceUnit')
  int? get distanceUnit;
  @override
  @JsonKey(name: 'Country')
  CountryDto? get country;
  @override
  @JsonKey(name: 'AccessComments')
  String? get accessComments;
  @override
  @JsonKey(name: 'ContactTelephone1')
  String? get contactTelephone1;
  @override
  @JsonKey(name: 'RelatedURL')
  String? get relatedUrl;

  /// Create a copy of AddressInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressInfoDtoImplCopyWith<_$AddressInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CountryDto _$CountryDtoFromJson(Map<String, dynamic> json) {
  return _CountryDto.fromJson(json);
}

/// @nodoc
mixin _$CountryDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'ISOCode')
  String? get isoCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'ContinentCode')
  String? get continentCode => throw _privateConstructorUsedError;

  /// Serializes this CountryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CountryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CountryDtoCopyWith<CountryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountryDtoCopyWith<$Res> {
  factory $CountryDtoCopyWith(
    CountryDto value,
    $Res Function(CountryDto) then,
  ) = _$CountryDtoCopyWithImpl<$Res, CountryDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'ISOCode') String? isoCode,
    @JsonKey(name: 'ContinentCode') String? continentCode,
  });
}

/// @nodoc
class _$CountryDtoCopyWithImpl<$Res, $Val extends CountryDto>
    implements $CountryDtoCopyWith<$Res> {
  _$CountryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CountryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? isoCode = freezed,
    Object? continentCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            isoCode: freezed == isoCode
                ? _value.isoCode
                : isoCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            continentCode: freezed == continentCode
                ? _value.continentCode
                : continentCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CountryDtoImplCopyWith<$Res>
    implements $CountryDtoCopyWith<$Res> {
  factory _$$CountryDtoImplCopyWith(
    _$CountryDtoImpl value,
    $Res Function(_$CountryDtoImpl) then,
  ) = __$$CountryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'ISOCode') String? isoCode,
    @JsonKey(name: 'ContinentCode') String? continentCode,
  });
}

/// @nodoc
class __$$CountryDtoImplCopyWithImpl<$Res>
    extends _$CountryDtoCopyWithImpl<$Res, _$CountryDtoImpl>
    implements _$$CountryDtoImplCopyWith<$Res> {
  __$$CountryDtoImplCopyWithImpl(
    _$CountryDtoImpl _value,
    $Res Function(_$CountryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CountryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? isoCode = freezed,
    Object? continentCode = freezed,
  }) {
    return _then(
      _$CountryDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        isoCode: freezed == isoCode
            ? _value.isoCode
            : isoCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        continentCode: freezed == continentCode
            ? _value.continentCode
            : continentCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CountryDtoImpl implements _CountryDto {
  const _$CountryDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'Title') this.title,
    @JsonKey(name: 'ISOCode') this.isoCode,
    @JsonKey(name: 'ContinentCode') this.continentCode,
  });

  factory _$CountryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CountryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'ISOCode')
  final String? isoCode;
  @override
  @JsonKey(name: 'ContinentCode')
  final String? continentCode;

  @override
  String toString() {
    return 'CountryDto(id: $id, title: $title, isoCode: $isoCode, continentCode: $continentCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isoCode, isoCode) || other.isoCode == isoCode) &&
            (identical(other.continentCode, continentCode) ||
                other.continentCode == continentCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, isoCode, continentCode);

  /// Create a copy of CountryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CountryDtoImplCopyWith<_$CountryDtoImpl> get copyWith =>
      __$$CountryDtoImplCopyWithImpl<_$CountryDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CountryDtoImplToJson(this);
  }
}

abstract class _CountryDto implements CountryDto {
  const factory _CountryDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'Title') final String? title,
    @JsonKey(name: 'ISOCode') final String? isoCode,
    @JsonKey(name: 'ContinentCode') final String? continentCode,
  }) = _$CountryDtoImpl;

  factory _CountryDto.fromJson(Map<String, dynamic> json) =
      _$CountryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'ISOCode')
  String? get isoCode;
  @override
  @JsonKey(name: 'ContinentCode')
  String? get continentCode;

  /// Create a copy of CountryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CountryDtoImplCopyWith<_$CountryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectionDto _$ConnectionDtoFromJson(Map<String, dynamic> json) {
  return _ConnectionDto.fromJson(json);
}

/// @nodoc
mixin _$ConnectionDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConnectionTypeID')
  int? get connectionTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConnectionType')
  ConnectionTypeDto? get connectionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'StatusTypeID')
  int? get statusTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'StatusType')
  StatusTypeDto? get statusType => throw _privateConstructorUsedError;
  @JsonKey(name: 'LevelID')
  int? get levelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Level')
  ChargingLevelDto? get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'PowerKW')
  double? get powerKw => throw _privateConstructorUsedError;
  @JsonKey(name: 'Amps')
  int? get amps => throw _privateConstructorUsedError;
  @JsonKey(name: 'Voltage')
  int? get voltage => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentTypeID')
  int? get currentTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentType')
  CurrentTypeDto? get currentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity')
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'Comments')
  String? get comments => throw _privateConstructorUsedError;

  /// Serializes this ConnectionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionDtoCopyWith<ConnectionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionDtoCopyWith<$Res> {
  factory $ConnectionDtoCopyWith(
    ConnectionDto value,
    $Res Function(ConnectionDto) then,
  ) = _$ConnectionDtoCopyWithImpl<$Res, ConnectionDto>;
  @useResult
  $Res call({
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
  });

  $ConnectionTypeDtoCopyWith<$Res>? get connectionType;
  $StatusTypeDtoCopyWith<$Res>? get statusType;
  $ChargingLevelDtoCopyWith<$Res>? get level;
  $CurrentTypeDtoCopyWith<$Res>? get currentType;
}

/// @nodoc
class _$ConnectionDtoCopyWithImpl<$Res, $Val extends ConnectionDto>
    implements $ConnectionDtoCopyWith<$Res> {
  _$ConnectionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? connectionTypeId = freezed,
    Object? connectionType = freezed,
    Object? statusTypeId = freezed,
    Object? statusType = freezed,
    Object? levelId = freezed,
    Object? level = freezed,
    Object? powerKw = freezed,
    Object? amps = freezed,
    Object? voltage = freezed,
    Object? currentTypeId = freezed,
    Object? currentType = freezed,
    Object? quantity = freezed,
    Object? comments = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            connectionTypeId: freezed == connectionTypeId
                ? _value.connectionTypeId
                : connectionTypeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            connectionType: freezed == connectionType
                ? _value.connectionType
                : connectionType // ignore: cast_nullable_to_non_nullable
                      as ConnectionTypeDto?,
            statusTypeId: freezed == statusTypeId
                ? _value.statusTypeId
                : statusTypeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            statusType: freezed == statusType
                ? _value.statusType
                : statusType // ignore: cast_nullable_to_non_nullable
                      as StatusTypeDto?,
            levelId: freezed == levelId
                ? _value.levelId
                : levelId // ignore: cast_nullable_to_non_nullable
                      as int?,
            level: freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as ChargingLevelDto?,
            powerKw: freezed == powerKw
                ? _value.powerKw
                : powerKw // ignore: cast_nullable_to_non_nullable
                      as double?,
            amps: freezed == amps
                ? _value.amps
                : amps // ignore: cast_nullable_to_non_nullable
                      as int?,
            voltage: freezed == voltage
                ? _value.voltage
                : voltage // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentTypeId: freezed == currentTypeId
                ? _value.currentTypeId
                : currentTypeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentType: freezed == currentType
                ? _value.currentType
                : currentType // ignore: cast_nullable_to_non_nullable
                      as CurrentTypeDto?,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConnectionTypeDtoCopyWith<$Res>? get connectionType {
    if (_value.connectionType == null) {
      return null;
    }

    return $ConnectionTypeDtoCopyWith<$Res>(_value.connectionType!, (value) {
      return _then(_value.copyWith(connectionType: value) as $Val);
    });
  }

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StatusTypeDtoCopyWith<$Res>? get statusType {
    if (_value.statusType == null) {
      return null;
    }

    return $StatusTypeDtoCopyWith<$Res>(_value.statusType!, (value) {
      return _then(_value.copyWith(statusType: value) as $Val);
    });
  }

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChargingLevelDtoCopyWith<$Res>? get level {
    if (_value.level == null) {
      return null;
    }

    return $ChargingLevelDtoCopyWith<$Res>(_value.level!, (value) {
      return _then(_value.copyWith(level: value) as $Val);
    });
  }

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrentTypeDtoCopyWith<$Res>? get currentType {
    if (_value.currentType == null) {
      return null;
    }

    return $CurrentTypeDtoCopyWith<$Res>(_value.currentType!, (value) {
      return _then(_value.copyWith(currentType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConnectionDtoImplCopyWith<$Res>
    implements $ConnectionDtoCopyWith<$Res> {
  factory _$$ConnectionDtoImplCopyWith(
    _$ConnectionDtoImpl value,
    $Res Function(_$ConnectionDtoImpl) then,
  ) = __$$ConnectionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
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
  });

  @override
  $ConnectionTypeDtoCopyWith<$Res>? get connectionType;
  @override
  $StatusTypeDtoCopyWith<$Res>? get statusType;
  @override
  $ChargingLevelDtoCopyWith<$Res>? get level;
  @override
  $CurrentTypeDtoCopyWith<$Res>? get currentType;
}

/// @nodoc
class __$$ConnectionDtoImplCopyWithImpl<$Res>
    extends _$ConnectionDtoCopyWithImpl<$Res, _$ConnectionDtoImpl>
    implements _$$ConnectionDtoImplCopyWith<$Res> {
  __$$ConnectionDtoImplCopyWithImpl(
    _$ConnectionDtoImpl _value,
    $Res Function(_$ConnectionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? connectionTypeId = freezed,
    Object? connectionType = freezed,
    Object? statusTypeId = freezed,
    Object? statusType = freezed,
    Object? levelId = freezed,
    Object? level = freezed,
    Object? powerKw = freezed,
    Object? amps = freezed,
    Object? voltage = freezed,
    Object? currentTypeId = freezed,
    Object? currentType = freezed,
    Object? quantity = freezed,
    Object? comments = freezed,
  }) {
    return _then(
      _$ConnectionDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        connectionTypeId: freezed == connectionTypeId
            ? _value.connectionTypeId
            : connectionTypeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        connectionType: freezed == connectionType
            ? _value.connectionType
            : connectionType // ignore: cast_nullable_to_non_nullable
                  as ConnectionTypeDto?,
        statusTypeId: freezed == statusTypeId
            ? _value.statusTypeId
            : statusTypeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        statusType: freezed == statusType
            ? _value.statusType
            : statusType // ignore: cast_nullable_to_non_nullable
                  as StatusTypeDto?,
        levelId: freezed == levelId
            ? _value.levelId
            : levelId // ignore: cast_nullable_to_non_nullable
                  as int?,
        level: freezed == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as ChargingLevelDto?,
        powerKw: freezed == powerKw
            ? _value.powerKw
            : powerKw // ignore: cast_nullable_to_non_nullable
                  as double?,
        amps: freezed == amps
            ? _value.amps
            : amps // ignore: cast_nullable_to_non_nullable
                  as int?,
        voltage: freezed == voltage
            ? _value.voltage
            : voltage // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentTypeId: freezed == currentTypeId
            ? _value.currentTypeId
            : currentTypeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentType: freezed == currentType
            ? _value.currentType
            : currentType // ignore: cast_nullable_to_non_nullable
                  as CurrentTypeDto?,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionDtoImpl implements _ConnectionDto {
  const _$ConnectionDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'ConnectionTypeID') this.connectionTypeId,
    @JsonKey(name: 'ConnectionType') this.connectionType,
    @JsonKey(name: 'StatusTypeID') this.statusTypeId,
    @JsonKey(name: 'StatusType') this.statusType,
    @JsonKey(name: 'LevelID') this.levelId,
    @JsonKey(name: 'Level') this.level,
    @JsonKey(name: 'PowerKW') this.powerKw,
    @JsonKey(name: 'Amps') this.amps,
    @JsonKey(name: 'Voltage') this.voltage,
    @JsonKey(name: 'CurrentTypeID') this.currentTypeId,
    @JsonKey(name: 'CurrentType') this.currentType,
    @JsonKey(name: 'Quantity') this.quantity,
    @JsonKey(name: 'Comments') this.comments,
  });

  factory _$ConnectionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'ConnectionTypeID')
  final int? connectionTypeId;
  @override
  @JsonKey(name: 'ConnectionType')
  final ConnectionTypeDto? connectionType;
  @override
  @JsonKey(name: 'StatusTypeID')
  final int? statusTypeId;
  @override
  @JsonKey(name: 'StatusType')
  final StatusTypeDto? statusType;
  @override
  @JsonKey(name: 'LevelID')
  final int? levelId;
  @override
  @JsonKey(name: 'Level')
  final ChargingLevelDto? level;
  @override
  @JsonKey(name: 'PowerKW')
  final double? powerKw;
  @override
  @JsonKey(name: 'Amps')
  final int? amps;
  @override
  @JsonKey(name: 'Voltage')
  final int? voltage;
  @override
  @JsonKey(name: 'CurrentTypeID')
  final int? currentTypeId;
  @override
  @JsonKey(name: 'CurrentType')
  final CurrentTypeDto? currentType;
  @override
  @JsonKey(name: 'Quantity')
  final int? quantity;
  @override
  @JsonKey(name: 'Comments')
  final String? comments;

  @override
  String toString() {
    return 'ConnectionDto(id: $id, connectionTypeId: $connectionTypeId, connectionType: $connectionType, statusTypeId: $statusTypeId, statusType: $statusType, levelId: $levelId, level: $level, powerKw: $powerKw, amps: $amps, voltage: $voltage, currentTypeId: $currentTypeId, currentType: $currentType, quantity: $quantity, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.connectionTypeId, connectionTypeId) ||
                other.connectionTypeId == connectionTypeId) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.statusTypeId, statusTypeId) ||
                other.statusTypeId == statusTypeId) &&
            (identical(other.statusType, statusType) ||
                other.statusType == statusType) &&
            (identical(other.levelId, levelId) || other.levelId == levelId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.powerKw, powerKw) || other.powerKw == powerKw) &&
            (identical(other.amps, amps) || other.amps == amps) &&
            (identical(other.voltage, voltage) || other.voltage == voltage) &&
            (identical(other.currentTypeId, currentTypeId) ||
                other.currentTypeId == currentTypeId) &&
            (identical(other.currentType, currentType) ||
                other.currentType == currentType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.comments, comments) ||
                other.comments == comments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    connectionTypeId,
    connectionType,
    statusTypeId,
    statusType,
    levelId,
    level,
    powerKw,
    amps,
    voltage,
    currentTypeId,
    currentType,
    quantity,
    comments,
  );

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionDtoImplCopyWith<_$ConnectionDtoImpl> get copyWith =>
      __$$ConnectionDtoImplCopyWithImpl<_$ConnectionDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionDtoImplToJson(this);
  }
}

abstract class _ConnectionDto implements ConnectionDto {
  const factory _ConnectionDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'ConnectionTypeID') final int? connectionTypeId,
    @JsonKey(name: 'ConnectionType') final ConnectionTypeDto? connectionType,
    @JsonKey(name: 'StatusTypeID') final int? statusTypeId,
    @JsonKey(name: 'StatusType') final StatusTypeDto? statusType,
    @JsonKey(name: 'LevelID') final int? levelId,
    @JsonKey(name: 'Level') final ChargingLevelDto? level,
    @JsonKey(name: 'PowerKW') final double? powerKw,
    @JsonKey(name: 'Amps') final int? amps,
    @JsonKey(name: 'Voltage') final int? voltage,
    @JsonKey(name: 'CurrentTypeID') final int? currentTypeId,
    @JsonKey(name: 'CurrentType') final CurrentTypeDto? currentType,
    @JsonKey(name: 'Quantity') final int? quantity,
    @JsonKey(name: 'Comments') final String? comments,
  }) = _$ConnectionDtoImpl;

  factory _ConnectionDto.fromJson(Map<String, dynamic> json) =
      _$ConnectionDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'ConnectionTypeID')
  int? get connectionTypeId;
  @override
  @JsonKey(name: 'ConnectionType')
  ConnectionTypeDto? get connectionType;
  @override
  @JsonKey(name: 'StatusTypeID')
  int? get statusTypeId;
  @override
  @JsonKey(name: 'StatusType')
  StatusTypeDto? get statusType;
  @override
  @JsonKey(name: 'LevelID')
  int? get levelId;
  @override
  @JsonKey(name: 'Level')
  ChargingLevelDto? get level;
  @override
  @JsonKey(name: 'PowerKW')
  double? get powerKw;
  @override
  @JsonKey(name: 'Amps')
  int? get amps;
  @override
  @JsonKey(name: 'Voltage')
  int? get voltage;
  @override
  @JsonKey(name: 'CurrentTypeID')
  int? get currentTypeId;
  @override
  @JsonKey(name: 'CurrentType')
  CurrentTypeDto? get currentType;
  @override
  @JsonKey(name: 'Quantity')
  int? get quantity;
  @override
  @JsonKey(name: 'Comments')
  String? get comments;

  /// Create a copy of ConnectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionDtoImplCopyWith<_$ConnectionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectionTypeDto _$ConnectionTypeDtoFromJson(Map<String, dynamic> json) {
  return _ConnectionTypeDto.fromJson(json);
}

/// @nodoc
mixin _$ConnectionTypeDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'FormalName')
  String? get formalName => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsDiscontinued')
  bool? get isDiscontinued => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsObsolete')
  bool? get isObsolete => throw _privateConstructorUsedError;

  /// Serializes this ConnectionTypeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionTypeDtoCopyWith<ConnectionTypeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionTypeDtoCopyWith<$Res> {
  factory $ConnectionTypeDtoCopyWith(
    ConnectionTypeDto value,
    $Res Function(ConnectionTypeDto) then,
  ) = _$ConnectionTypeDtoCopyWithImpl<$Res, ConnectionTypeDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'FormalName') String? formalName,
    @JsonKey(name: 'IsDiscontinued') bool? isDiscontinued,
    @JsonKey(name: 'IsObsolete') bool? isObsolete,
  });
}

/// @nodoc
class _$ConnectionTypeDtoCopyWithImpl<$Res, $Val extends ConnectionTypeDto>
    implements $ConnectionTypeDtoCopyWith<$Res> {
  _$ConnectionTypeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? formalName = freezed,
    Object? isDiscontinued = freezed,
    Object? isObsolete = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            formalName: freezed == formalName
                ? _value.formalName
                : formalName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDiscontinued: freezed == isDiscontinued
                ? _value.isDiscontinued
                : isDiscontinued // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isObsolete: freezed == isObsolete
                ? _value.isObsolete
                : isObsolete // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConnectionTypeDtoImplCopyWith<$Res>
    implements $ConnectionTypeDtoCopyWith<$Res> {
  factory _$$ConnectionTypeDtoImplCopyWith(
    _$ConnectionTypeDtoImpl value,
    $Res Function(_$ConnectionTypeDtoImpl) then,
  ) = __$$ConnectionTypeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'FormalName') String? formalName,
    @JsonKey(name: 'IsDiscontinued') bool? isDiscontinued,
    @JsonKey(name: 'IsObsolete') bool? isObsolete,
  });
}

/// @nodoc
class __$$ConnectionTypeDtoImplCopyWithImpl<$Res>
    extends _$ConnectionTypeDtoCopyWithImpl<$Res, _$ConnectionTypeDtoImpl>
    implements _$$ConnectionTypeDtoImplCopyWith<$Res> {
  __$$ConnectionTypeDtoImplCopyWithImpl(
    _$ConnectionTypeDtoImpl _value,
    $Res Function(_$ConnectionTypeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectionTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? formalName = freezed,
    Object? isDiscontinued = freezed,
    Object? isObsolete = freezed,
  }) {
    return _then(
      _$ConnectionTypeDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        formalName: freezed == formalName
            ? _value.formalName
            : formalName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDiscontinued: freezed == isDiscontinued
            ? _value.isDiscontinued
            : isDiscontinued // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isObsolete: freezed == isObsolete
            ? _value.isObsolete
            : isObsolete // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionTypeDtoImpl implements _ConnectionTypeDto {
  const _$ConnectionTypeDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'Title') this.title,
    @JsonKey(name: 'FormalName') this.formalName,
    @JsonKey(name: 'IsDiscontinued') this.isDiscontinued,
    @JsonKey(name: 'IsObsolete') this.isObsolete,
  });

  factory _$ConnectionTypeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionTypeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'FormalName')
  final String? formalName;
  @override
  @JsonKey(name: 'IsDiscontinued')
  final bool? isDiscontinued;
  @override
  @JsonKey(name: 'IsObsolete')
  final bool? isObsolete;

  @override
  String toString() {
    return 'ConnectionTypeDto(id: $id, title: $title, formalName: $formalName, isDiscontinued: $isDiscontinued, isObsolete: $isObsolete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionTypeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.formalName, formalName) ||
                other.formalName == formalName) &&
            (identical(other.isDiscontinued, isDiscontinued) ||
                other.isDiscontinued == isDiscontinued) &&
            (identical(other.isObsolete, isObsolete) ||
                other.isObsolete == isObsolete));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    formalName,
    isDiscontinued,
    isObsolete,
  );

  /// Create a copy of ConnectionTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionTypeDtoImplCopyWith<_$ConnectionTypeDtoImpl> get copyWith =>
      __$$ConnectionTypeDtoImplCopyWithImpl<_$ConnectionTypeDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionTypeDtoImplToJson(this);
  }
}

abstract class _ConnectionTypeDto implements ConnectionTypeDto {
  const factory _ConnectionTypeDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'Title') final String? title,
    @JsonKey(name: 'FormalName') final String? formalName,
    @JsonKey(name: 'IsDiscontinued') final bool? isDiscontinued,
    @JsonKey(name: 'IsObsolete') final bool? isObsolete,
  }) = _$ConnectionTypeDtoImpl;

  factory _ConnectionTypeDto.fromJson(Map<String, dynamic> json) =
      _$ConnectionTypeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'FormalName')
  String? get formalName;
  @override
  @JsonKey(name: 'IsDiscontinued')
  bool? get isDiscontinued;
  @override
  @JsonKey(name: 'IsObsolete')
  bool? get isObsolete;

  /// Create a copy of ConnectionTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionTypeDtoImplCopyWith<_$ConnectionTypeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChargingLevelDto _$ChargingLevelDtoFromJson(Map<String, dynamic> json) {
  return _ChargingLevelDto.fromJson(json);
}

/// @nodoc
mixin _$ChargingLevelDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'Comments')
  String? get comments => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsFastChargeCapable')
  bool? get isFastChargeCapable => throw _privateConstructorUsedError;

  /// Serializes this ChargingLevelDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChargingLevelDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargingLevelDtoCopyWith<ChargingLevelDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargingLevelDtoCopyWith<$Res> {
  factory $ChargingLevelDtoCopyWith(
    ChargingLevelDto value,
    $Res Function(ChargingLevelDto) then,
  ) = _$ChargingLevelDtoCopyWithImpl<$Res, ChargingLevelDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'Comments') String? comments,
    @JsonKey(name: 'IsFastChargeCapable') bool? isFastChargeCapable,
  });
}

/// @nodoc
class _$ChargingLevelDtoCopyWithImpl<$Res, $Val extends ChargingLevelDto>
    implements $ChargingLevelDtoCopyWith<$Res> {
  _$ChargingLevelDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChargingLevelDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? comments = freezed,
    Object? isFastChargeCapable = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFastChargeCapable: freezed == isFastChargeCapable
                ? _value.isFastChargeCapable
                : isFastChargeCapable // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChargingLevelDtoImplCopyWith<$Res>
    implements $ChargingLevelDtoCopyWith<$Res> {
  factory _$$ChargingLevelDtoImplCopyWith(
    _$ChargingLevelDtoImpl value,
    $Res Function(_$ChargingLevelDtoImpl) then,
  ) = __$$ChargingLevelDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'Comments') String? comments,
    @JsonKey(name: 'IsFastChargeCapable') bool? isFastChargeCapable,
  });
}

/// @nodoc
class __$$ChargingLevelDtoImplCopyWithImpl<$Res>
    extends _$ChargingLevelDtoCopyWithImpl<$Res, _$ChargingLevelDtoImpl>
    implements _$$ChargingLevelDtoImplCopyWith<$Res> {
  __$$ChargingLevelDtoImplCopyWithImpl(
    _$ChargingLevelDtoImpl _value,
    $Res Function(_$ChargingLevelDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingLevelDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? comments = freezed,
    Object? isFastChargeCapable = freezed,
  }) {
    return _then(
      _$ChargingLevelDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFastChargeCapable: freezed == isFastChargeCapable
            ? _value.isFastChargeCapable
            : isFastChargeCapable // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChargingLevelDtoImpl implements _ChargingLevelDto {
  const _$ChargingLevelDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'Title') this.title,
    @JsonKey(name: 'Comments') this.comments,
    @JsonKey(name: 'IsFastChargeCapable') this.isFastChargeCapable,
  });

  factory _$ChargingLevelDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargingLevelDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'Comments')
  final String? comments;
  @override
  @JsonKey(name: 'IsFastChargeCapable')
  final bool? isFastChargeCapable;

  @override
  String toString() {
    return 'ChargingLevelDto(id: $id, title: $title, comments: $comments, isFastChargeCapable: $isFastChargeCapable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargingLevelDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.isFastChargeCapable, isFastChargeCapable) ||
                other.isFastChargeCapable == isFastChargeCapable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, comments, isFastChargeCapable);

  /// Create a copy of ChargingLevelDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargingLevelDtoImplCopyWith<_$ChargingLevelDtoImpl> get copyWith =>
      __$$ChargingLevelDtoImplCopyWithImpl<_$ChargingLevelDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargingLevelDtoImplToJson(this);
  }
}

abstract class _ChargingLevelDto implements ChargingLevelDto {
  const factory _ChargingLevelDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'Title') final String? title,
    @JsonKey(name: 'Comments') final String? comments,
    @JsonKey(name: 'IsFastChargeCapable') final bool? isFastChargeCapable,
  }) = _$ChargingLevelDtoImpl;

  factory _ChargingLevelDto.fromJson(Map<String, dynamic> json) =
      _$ChargingLevelDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'Comments')
  String? get comments;
  @override
  @JsonKey(name: 'IsFastChargeCapable')
  bool? get isFastChargeCapable;

  /// Create a copy of ChargingLevelDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargingLevelDtoImplCopyWith<_$ChargingLevelDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrentTypeDto _$CurrentTypeDtoFromJson(Map<String, dynamic> json) {
  return _CurrentTypeDto.fromJson(json);
}

/// @nodoc
mixin _$CurrentTypeDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description')
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this CurrentTypeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrentTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentTypeDtoCopyWith<CurrentTypeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentTypeDtoCopyWith<$Res> {
  factory $CurrentTypeDtoCopyWith(
    CurrentTypeDto value,
    $Res Function(CurrentTypeDto) then,
  ) = _$CurrentTypeDtoCopyWithImpl<$Res, CurrentTypeDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'Description') String? description,
  });
}

/// @nodoc
class _$CurrentTypeDtoCopyWithImpl<$Res, $Val extends CurrentTypeDto>
    implements $CurrentTypeDtoCopyWith<$Res> {
  _$CurrentTypeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CurrentTypeDtoImplCopyWith<$Res>
    implements $CurrentTypeDtoCopyWith<$Res> {
  factory _$$CurrentTypeDtoImplCopyWith(
    _$CurrentTypeDtoImpl value,
    $Res Function(_$CurrentTypeDtoImpl) then,
  ) = __$$CurrentTypeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'Description') String? description,
  });
}

/// @nodoc
class __$$CurrentTypeDtoImplCopyWithImpl<$Res>
    extends _$CurrentTypeDtoCopyWithImpl<$Res, _$CurrentTypeDtoImpl>
    implements _$$CurrentTypeDtoImplCopyWith<$Res> {
  __$$CurrentTypeDtoImplCopyWithImpl(
    _$CurrentTypeDtoImpl _value,
    $Res Function(_$CurrentTypeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CurrentTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$CurrentTypeDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentTypeDtoImpl implements _CurrentTypeDto {
  const _$CurrentTypeDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'Title') this.title,
    @JsonKey(name: 'Description') this.description,
  });

  factory _$CurrentTypeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentTypeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'Description')
  final String? description;

  @override
  String toString() {
    return 'CurrentTypeDto(id: $id, title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentTypeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description);

  /// Create a copy of CurrentTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentTypeDtoImplCopyWith<_$CurrentTypeDtoImpl> get copyWith =>
      __$$CurrentTypeDtoImplCopyWithImpl<_$CurrentTypeDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentTypeDtoImplToJson(this);
  }
}

abstract class _CurrentTypeDto implements CurrentTypeDto {
  const factory _CurrentTypeDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'Title') final String? title,
    @JsonKey(name: 'Description') final String? description,
  }) = _$CurrentTypeDtoImpl;

  factory _CurrentTypeDto.fromJson(Map<String, dynamic> json) =
      _$CurrentTypeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'Description')
  String? get description;

  /// Create a copy of CurrentTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentTypeDtoImplCopyWith<_$CurrentTypeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UsageTypeDto _$UsageTypeDtoFromJson(Map<String, dynamic> json) {
  return _UsageTypeDto.fromJson(json);
}

/// @nodoc
mixin _$UsageTypeDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsPayAtLocation')
  bool? get isPayAtLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsMembershipRequired')
  bool? get isMembershipRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsAccessKeyRequired')
  bool? get isAccessKeyRequired => throw _privateConstructorUsedError;

  /// Serializes this UsageTypeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsageTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsageTypeDtoCopyWith<UsageTypeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageTypeDtoCopyWith<$Res> {
  factory $UsageTypeDtoCopyWith(
    UsageTypeDto value,
    $Res Function(UsageTypeDto) then,
  ) = _$UsageTypeDtoCopyWithImpl<$Res, UsageTypeDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'IsPayAtLocation') bool? isPayAtLocation,
    @JsonKey(name: 'IsMembershipRequired') bool? isMembershipRequired,
    @JsonKey(name: 'IsAccessKeyRequired') bool? isAccessKeyRequired,
  });
}

/// @nodoc
class _$UsageTypeDtoCopyWithImpl<$Res, $Val extends UsageTypeDto>
    implements $UsageTypeDtoCopyWith<$Res> {
  _$UsageTypeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsageTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? isPayAtLocation = freezed,
    Object? isMembershipRequired = freezed,
    Object? isAccessKeyRequired = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPayAtLocation: freezed == isPayAtLocation
                ? _value.isPayAtLocation
                : isPayAtLocation // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isMembershipRequired: freezed == isMembershipRequired
                ? _value.isMembershipRequired
                : isMembershipRequired // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isAccessKeyRequired: freezed == isAccessKeyRequired
                ? _value.isAccessKeyRequired
                : isAccessKeyRequired // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsageTypeDtoImplCopyWith<$Res>
    implements $UsageTypeDtoCopyWith<$Res> {
  factory _$$UsageTypeDtoImplCopyWith(
    _$UsageTypeDtoImpl value,
    $Res Function(_$UsageTypeDtoImpl) then,
  ) = __$$UsageTypeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'IsPayAtLocation') bool? isPayAtLocation,
    @JsonKey(name: 'IsMembershipRequired') bool? isMembershipRequired,
    @JsonKey(name: 'IsAccessKeyRequired') bool? isAccessKeyRequired,
  });
}

/// @nodoc
class __$$UsageTypeDtoImplCopyWithImpl<$Res>
    extends _$UsageTypeDtoCopyWithImpl<$Res, _$UsageTypeDtoImpl>
    implements _$$UsageTypeDtoImplCopyWith<$Res> {
  __$$UsageTypeDtoImplCopyWithImpl(
    _$UsageTypeDtoImpl _value,
    $Res Function(_$UsageTypeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsageTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? isPayAtLocation = freezed,
    Object? isMembershipRequired = freezed,
    Object? isAccessKeyRequired = freezed,
  }) {
    return _then(
      _$UsageTypeDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPayAtLocation: freezed == isPayAtLocation
            ? _value.isPayAtLocation
            : isPayAtLocation // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isMembershipRequired: freezed == isMembershipRequired
            ? _value.isMembershipRequired
            : isMembershipRequired // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isAccessKeyRequired: freezed == isAccessKeyRequired
            ? _value.isAccessKeyRequired
            : isAccessKeyRequired // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsageTypeDtoImpl implements _UsageTypeDto {
  const _$UsageTypeDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'Title') this.title,
    @JsonKey(name: 'IsPayAtLocation') this.isPayAtLocation,
    @JsonKey(name: 'IsMembershipRequired') this.isMembershipRequired,
    @JsonKey(name: 'IsAccessKeyRequired') this.isAccessKeyRequired,
  });

  factory _$UsageTypeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageTypeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'IsPayAtLocation')
  final bool? isPayAtLocation;
  @override
  @JsonKey(name: 'IsMembershipRequired')
  final bool? isMembershipRequired;
  @override
  @JsonKey(name: 'IsAccessKeyRequired')
  final bool? isAccessKeyRequired;

  @override
  String toString() {
    return 'UsageTypeDto(id: $id, title: $title, isPayAtLocation: $isPayAtLocation, isMembershipRequired: $isMembershipRequired, isAccessKeyRequired: $isAccessKeyRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageTypeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isPayAtLocation, isPayAtLocation) ||
                other.isPayAtLocation == isPayAtLocation) &&
            (identical(other.isMembershipRequired, isMembershipRequired) ||
                other.isMembershipRequired == isMembershipRequired) &&
            (identical(other.isAccessKeyRequired, isAccessKeyRequired) ||
                other.isAccessKeyRequired == isAccessKeyRequired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    isPayAtLocation,
    isMembershipRequired,
    isAccessKeyRequired,
  );

  /// Create a copy of UsageTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageTypeDtoImplCopyWith<_$UsageTypeDtoImpl> get copyWith =>
      __$$UsageTypeDtoImplCopyWithImpl<_$UsageTypeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageTypeDtoImplToJson(this);
  }
}

abstract class _UsageTypeDto implements UsageTypeDto {
  const factory _UsageTypeDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'Title') final String? title,
    @JsonKey(name: 'IsPayAtLocation') final bool? isPayAtLocation,
    @JsonKey(name: 'IsMembershipRequired') final bool? isMembershipRequired,
    @JsonKey(name: 'IsAccessKeyRequired') final bool? isAccessKeyRequired,
  }) = _$UsageTypeDtoImpl;

  factory _UsageTypeDto.fromJson(Map<String, dynamic> json) =
      _$UsageTypeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'IsPayAtLocation')
  bool? get isPayAtLocation;
  @override
  @JsonKey(name: 'IsMembershipRequired')
  bool? get isMembershipRequired;
  @override
  @JsonKey(name: 'IsAccessKeyRequired')
  bool? get isAccessKeyRequired;

  /// Create a copy of UsageTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsageTypeDtoImplCopyWith<_$UsageTypeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StatusTypeDto _$StatusTypeDtoFromJson(Map<String, dynamic> json) {
  return _StatusTypeDto.fromJson(json);
}

/// @nodoc
mixin _$StatusTypeDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsOperational')
  bool? get isOperational => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsUserSelectable')
  bool? get isUserSelectable => throw _privateConstructorUsedError;

  /// Serializes this StatusTypeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusTypeDtoCopyWith<StatusTypeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusTypeDtoCopyWith<$Res> {
  factory $StatusTypeDtoCopyWith(
    StatusTypeDto value,
    $Res Function(StatusTypeDto) then,
  ) = _$StatusTypeDtoCopyWithImpl<$Res, StatusTypeDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'IsOperational') bool? isOperational,
    @JsonKey(name: 'IsUserSelectable') bool? isUserSelectable,
  });
}

/// @nodoc
class _$StatusTypeDtoCopyWithImpl<$Res, $Val extends StatusTypeDto>
    implements $StatusTypeDtoCopyWith<$Res> {
  _$StatusTypeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? isOperational = freezed,
    Object? isUserSelectable = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOperational: freezed == isOperational
                ? _value.isOperational
                : isOperational // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isUserSelectable: freezed == isUserSelectable
                ? _value.isUserSelectable
                : isUserSelectable // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatusTypeDtoImplCopyWith<$Res>
    implements $StatusTypeDtoCopyWith<$Res> {
  factory _$$StatusTypeDtoImplCopyWith(
    _$StatusTypeDtoImpl value,
    $Res Function(_$StatusTypeDtoImpl) then,
  ) = __$$StatusTypeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'IsOperational') bool? isOperational,
    @JsonKey(name: 'IsUserSelectable') bool? isUserSelectable,
  });
}

/// @nodoc
class __$$StatusTypeDtoImplCopyWithImpl<$Res>
    extends _$StatusTypeDtoCopyWithImpl<$Res, _$StatusTypeDtoImpl>
    implements _$$StatusTypeDtoImplCopyWith<$Res> {
  __$$StatusTypeDtoImplCopyWithImpl(
    _$StatusTypeDtoImpl _value,
    $Res Function(_$StatusTypeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatusTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? isOperational = freezed,
    Object? isUserSelectable = freezed,
  }) {
    return _then(
      _$StatusTypeDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOperational: freezed == isOperational
            ? _value.isOperational
            : isOperational // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isUserSelectable: freezed == isUserSelectable
            ? _value.isUserSelectable
            : isUserSelectable // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusTypeDtoImpl implements _StatusTypeDto {
  const _$StatusTypeDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'Title') this.title,
    @JsonKey(name: 'IsOperational') this.isOperational,
    @JsonKey(name: 'IsUserSelectable') this.isUserSelectable,
  });

  factory _$StatusTypeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusTypeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'IsOperational')
  final bool? isOperational;
  @override
  @JsonKey(name: 'IsUserSelectable')
  final bool? isUserSelectable;

  @override
  String toString() {
    return 'StatusTypeDto(id: $id, title: $title, isOperational: $isOperational, isUserSelectable: $isUserSelectable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusTypeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isOperational, isOperational) ||
                other.isOperational == isOperational) &&
            (identical(other.isUserSelectable, isUserSelectable) ||
                other.isUserSelectable == isUserSelectable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, isOperational, isUserSelectable);

  /// Create a copy of StatusTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusTypeDtoImplCopyWith<_$StatusTypeDtoImpl> get copyWith =>
      __$$StatusTypeDtoImplCopyWithImpl<_$StatusTypeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusTypeDtoImplToJson(this);
  }
}

abstract class _StatusTypeDto implements StatusTypeDto {
  const factory _StatusTypeDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'Title') final String? title,
    @JsonKey(name: 'IsOperational') final bool? isOperational,
    @JsonKey(name: 'IsUserSelectable') final bool? isUserSelectable,
  }) = _$StatusTypeDtoImpl;

  factory _StatusTypeDto.fromJson(Map<String, dynamic> json) =
      _$StatusTypeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'IsOperational')
  bool? get isOperational;
  @override
  @JsonKey(name: 'IsUserSelectable')
  bool? get isUserSelectable;

  /// Create a copy of StatusTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusTypeDtoImplCopyWith<_$StatusTypeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OperatorInfoDto _$OperatorInfoDtoFromJson(Map<String, dynamic> json) {
  return _OperatorInfoDto.fromJson(json);
}

/// @nodoc
mixin _$OperatorInfoDto {
  @JsonKey(name: 'ID')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'WebsiteURL')
  String? get websiteUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'PhonePrimaryContact')
  String? get phonePrimaryContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'ContactEmail')
  String? get contactEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsPrivateIndividual')
  bool? get isPrivateIndividual => throw _privateConstructorUsedError;

  /// Serializes this OperatorInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OperatorInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OperatorInfoDtoCopyWith<OperatorInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperatorInfoDtoCopyWith<$Res> {
  factory $OperatorInfoDtoCopyWith(
    OperatorInfoDto value,
    $Res Function(OperatorInfoDto) then,
  ) = _$OperatorInfoDtoCopyWithImpl<$Res, OperatorInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'WebsiteURL') String? websiteUrl,
    @JsonKey(name: 'PhonePrimaryContact') String? phonePrimaryContact,
    @JsonKey(name: 'ContactEmail') String? contactEmail,
    @JsonKey(name: 'IsPrivateIndividual') bool? isPrivateIndividual,
  });
}

/// @nodoc
class _$OperatorInfoDtoCopyWithImpl<$Res, $Val extends OperatorInfoDto>
    implements $OperatorInfoDtoCopyWith<$Res> {
  _$OperatorInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OperatorInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? websiteUrl = freezed,
    Object? phonePrimaryContact = freezed,
    Object? contactEmail = freezed,
    Object? isPrivateIndividual = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            websiteUrl: freezed == websiteUrl
                ? _value.websiteUrl
                : websiteUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            phonePrimaryContact: freezed == phonePrimaryContact
                ? _value.phonePrimaryContact
                : phonePrimaryContact // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactEmail: freezed == contactEmail
                ? _value.contactEmail
                : contactEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPrivateIndividual: freezed == isPrivateIndividual
                ? _value.isPrivateIndividual
                : isPrivateIndividual // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OperatorInfoDtoImplCopyWith<$Res>
    implements $OperatorInfoDtoCopyWith<$Res> {
  factory _$$OperatorInfoDtoImplCopyWith(
    _$OperatorInfoDtoImpl value,
    $Res Function(_$OperatorInfoDtoImpl) then,
  ) = __$$OperatorInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ID') int? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'WebsiteURL') String? websiteUrl,
    @JsonKey(name: 'PhonePrimaryContact') String? phonePrimaryContact,
    @JsonKey(name: 'ContactEmail') String? contactEmail,
    @JsonKey(name: 'IsPrivateIndividual') bool? isPrivateIndividual,
  });
}

/// @nodoc
class __$$OperatorInfoDtoImplCopyWithImpl<$Res>
    extends _$OperatorInfoDtoCopyWithImpl<$Res, _$OperatorInfoDtoImpl>
    implements _$$OperatorInfoDtoImplCopyWith<$Res> {
  __$$OperatorInfoDtoImplCopyWithImpl(
    _$OperatorInfoDtoImpl _value,
    $Res Function(_$OperatorInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OperatorInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? websiteUrl = freezed,
    Object? phonePrimaryContact = freezed,
    Object? contactEmail = freezed,
    Object? isPrivateIndividual = freezed,
  }) {
    return _then(
      _$OperatorInfoDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        websiteUrl: freezed == websiteUrl
            ? _value.websiteUrl
            : websiteUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        phonePrimaryContact: freezed == phonePrimaryContact
            ? _value.phonePrimaryContact
            : phonePrimaryContact // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactEmail: freezed == contactEmail
            ? _value.contactEmail
            : contactEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPrivateIndividual: freezed == isPrivateIndividual
            ? _value.isPrivateIndividual
            : isPrivateIndividual // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OperatorInfoDtoImpl implements _OperatorInfoDto {
  const _$OperatorInfoDtoImpl({
    @JsonKey(name: 'ID') this.id,
    @JsonKey(name: 'Title') this.title,
    @JsonKey(name: 'WebsiteURL') this.websiteUrl,
    @JsonKey(name: 'PhonePrimaryContact') this.phonePrimaryContact,
    @JsonKey(name: 'ContactEmail') this.contactEmail,
    @JsonKey(name: 'IsPrivateIndividual') this.isPrivateIndividual,
  });

  factory _$OperatorInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OperatorInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ID')
  final int? id;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'WebsiteURL')
  final String? websiteUrl;
  @override
  @JsonKey(name: 'PhonePrimaryContact')
  final String? phonePrimaryContact;
  @override
  @JsonKey(name: 'ContactEmail')
  final String? contactEmail;
  @override
  @JsonKey(name: 'IsPrivateIndividual')
  final bool? isPrivateIndividual;

  @override
  String toString() {
    return 'OperatorInfoDto(id: $id, title: $title, websiteUrl: $websiteUrl, phonePrimaryContact: $phonePrimaryContact, contactEmail: $contactEmail, isPrivateIndividual: $isPrivateIndividual)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OperatorInfoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.phonePrimaryContact, phonePrimaryContact) ||
                other.phonePrimaryContact == phonePrimaryContact) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.isPrivateIndividual, isPrivateIndividual) ||
                other.isPrivateIndividual == isPrivateIndividual));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    websiteUrl,
    phonePrimaryContact,
    contactEmail,
    isPrivateIndividual,
  );

  /// Create a copy of OperatorInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OperatorInfoDtoImplCopyWith<_$OperatorInfoDtoImpl> get copyWith =>
      __$$OperatorInfoDtoImplCopyWithImpl<_$OperatorInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OperatorInfoDtoImplToJson(this);
  }
}

abstract class _OperatorInfoDto implements OperatorInfoDto {
  const factory _OperatorInfoDto({
    @JsonKey(name: 'ID') final int? id,
    @JsonKey(name: 'Title') final String? title,
    @JsonKey(name: 'WebsiteURL') final String? websiteUrl,
    @JsonKey(name: 'PhonePrimaryContact') final String? phonePrimaryContact,
    @JsonKey(name: 'ContactEmail') final String? contactEmail,
    @JsonKey(name: 'IsPrivateIndividual') final bool? isPrivateIndividual,
  }) = _$OperatorInfoDtoImpl;

  factory _OperatorInfoDto.fromJson(Map<String, dynamic> json) =
      _$OperatorInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ID')
  int? get id;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'WebsiteURL')
  String? get websiteUrl;
  @override
  @JsonKey(name: 'PhonePrimaryContact')
  String? get phonePrimaryContact;
  @override
  @JsonKey(name: 'ContactEmail')
  String? get contactEmail;
  @override
  @JsonKey(name: 'IsPrivateIndividual')
  bool? get isPrivateIndividual;

  /// Create a copy of OperatorInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OperatorInfoDtoImplCopyWith<_$OperatorInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
