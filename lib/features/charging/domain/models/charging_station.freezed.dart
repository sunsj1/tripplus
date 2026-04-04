// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charging_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChargingStation _$ChargingStationFromJson(Map<String, dynamic> json) {
  return _ChargingStation.fromJson(json);
}

/// @nodoc
mixin _$ChargingStation {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get uuid => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get addressLine2 => throw _privateConstructorUsedError;
  String? get town => throw _privateConstructorUsedError;
  String? get stateOrProvince => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get countryCode => throw _privateConstructorUsedError;
  String? get postcode => throw _privateConstructorUsedError;
  int? get numberOfPoints => throw _privateConstructorUsedError;
  String? get usageType => throw _privateConstructorUsedError;
  String? get usageCost => throw _privateConstructorUsedError;
  String? get statusType => throw _privateConstructorUsedError;
  bool? get isOperational => throw _privateConstructorUsedError;
  String? get operatorName => throw _privateConstructorUsedError;
  String? get operatorWebsite => throw _privateConstructorUsedError;
  double? get distanceKm => throw _privateConstructorUsedError;
  String? get generalComments => throw _privateConstructorUsedError;
  String? get accessComments => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  String? get dateLastVerified => throw _privateConstructorUsedError;
  bool? get isRecentlyVerified => throw _privateConstructorUsedError;
  List<Connection> get connections => throw _privateConstructorUsedError;
  String get dataSource => throw _privateConstructorUsedError;

  /// Serializes this ChargingStation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChargingStationCopyWith<ChargingStation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargingStationCopyWith<$Res> {
  factory $ChargingStationCopyWith(
    ChargingStation value,
    $Res Function(ChargingStation) then,
  ) = _$ChargingStationCopyWithImpl<$Res, ChargingStation>;
  @useResult
  $Res call({
    int id,
    String name,
    double latitude,
    double longitude,
    String? uuid,
    String? address,
    String? addressLine2,
    String? town,
    String? stateOrProvince,
    String? country,
    String? countryCode,
    String? postcode,
    int? numberOfPoints,
    String? usageType,
    String? usageCost,
    String? statusType,
    bool? isOperational,
    String? operatorName,
    String? operatorWebsite,
    double? distanceKm,
    String? generalComments,
    String? accessComments,
    String? contactPhone,
    String? dateLastVerified,
    bool? isRecentlyVerified,
    List<Connection> connections,
    String dataSource,
  });
}

/// @nodoc
class _$ChargingStationCopyWithImpl<$Res, $Val extends ChargingStation>
    implements $ChargingStationCopyWith<$Res> {
  _$ChargingStationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? uuid = freezed,
    Object? address = freezed,
    Object? addressLine2 = freezed,
    Object? town = freezed,
    Object? stateOrProvince = freezed,
    Object? country = freezed,
    Object? countryCode = freezed,
    Object? postcode = freezed,
    Object? numberOfPoints = freezed,
    Object? usageType = freezed,
    Object? usageCost = freezed,
    Object? statusType = freezed,
    Object? isOperational = freezed,
    Object? operatorName = freezed,
    Object? operatorWebsite = freezed,
    Object? distanceKm = freezed,
    Object? generalComments = freezed,
    Object? accessComments = freezed,
    Object? contactPhone = freezed,
    Object? dateLastVerified = freezed,
    Object? isRecentlyVerified = freezed,
    Object? connections = null,
    Object? dataSource = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            uuid: freezed == uuid
                ? _value.uuid
                : uuid // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
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
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            countryCode: freezed == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            postcode: freezed == postcode
                ? _value.postcode
                : postcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            numberOfPoints: freezed == numberOfPoints
                ? _value.numberOfPoints
                : numberOfPoints // ignore: cast_nullable_to_non_nullable
                      as int?,
            usageType: freezed == usageType
                ? _value.usageType
                : usageType // ignore: cast_nullable_to_non_nullable
                      as String?,
            usageCost: freezed == usageCost
                ? _value.usageCost
                : usageCost // ignore: cast_nullable_to_non_nullable
                      as String?,
            statusType: freezed == statusType
                ? _value.statusType
                : statusType // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOperational: freezed == isOperational
                ? _value.isOperational
                : isOperational // ignore: cast_nullable_to_non_nullable
                      as bool?,
            operatorName: freezed == operatorName
                ? _value.operatorName
                : operatorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            operatorWebsite: freezed == operatorWebsite
                ? _value.operatorWebsite
                : operatorWebsite // ignore: cast_nullable_to_non_nullable
                      as String?,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            generalComments: freezed == generalComments
                ? _value.generalComments
                : generalComments // ignore: cast_nullable_to_non_nullable
                      as String?,
            accessComments: freezed == accessComments
                ? _value.accessComments
                : accessComments // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactPhone: freezed == contactPhone
                ? _value.contactPhone
                : contactPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateLastVerified: freezed == dateLastVerified
                ? _value.dateLastVerified
                : dateLastVerified // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRecentlyVerified: freezed == isRecentlyVerified
                ? _value.isRecentlyVerified
                : isRecentlyVerified // ignore: cast_nullable_to_non_nullable
                      as bool?,
            connections: null == connections
                ? _value.connections
                : connections // ignore: cast_nullable_to_non_nullable
                      as List<Connection>,
            dataSource: null == dataSource
                ? _value.dataSource
                : dataSource // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChargingStationImplCopyWith<$Res>
    implements $ChargingStationCopyWith<$Res> {
  factory _$$ChargingStationImplCopyWith(
    _$ChargingStationImpl value,
    $Res Function(_$ChargingStationImpl) then,
  ) = __$$ChargingStationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    double latitude,
    double longitude,
    String? uuid,
    String? address,
    String? addressLine2,
    String? town,
    String? stateOrProvince,
    String? country,
    String? countryCode,
    String? postcode,
    int? numberOfPoints,
    String? usageType,
    String? usageCost,
    String? statusType,
    bool? isOperational,
    String? operatorName,
    String? operatorWebsite,
    double? distanceKm,
    String? generalComments,
    String? accessComments,
    String? contactPhone,
    String? dateLastVerified,
    bool? isRecentlyVerified,
    List<Connection> connections,
    String dataSource,
  });
}

/// @nodoc
class __$$ChargingStationImplCopyWithImpl<$Res>
    extends _$ChargingStationCopyWithImpl<$Res, _$ChargingStationImpl>
    implements _$$ChargingStationImplCopyWith<$Res> {
  __$$ChargingStationImplCopyWithImpl(
    _$ChargingStationImpl _value,
    $Res Function(_$ChargingStationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? uuid = freezed,
    Object? address = freezed,
    Object? addressLine2 = freezed,
    Object? town = freezed,
    Object? stateOrProvince = freezed,
    Object? country = freezed,
    Object? countryCode = freezed,
    Object? postcode = freezed,
    Object? numberOfPoints = freezed,
    Object? usageType = freezed,
    Object? usageCost = freezed,
    Object? statusType = freezed,
    Object? isOperational = freezed,
    Object? operatorName = freezed,
    Object? operatorWebsite = freezed,
    Object? distanceKm = freezed,
    Object? generalComments = freezed,
    Object? accessComments = freezed,
    Object? contactPhone = freezed,
    Object? dateLastVerified = freezed,
    Object? isRecentlyVerified = freezed,
    Object? connections = null,
    Object? dataSource = null,
  }) {
    return _then(
      _$ChargingStationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        uuid: freezed == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
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
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        countryCode: freezed == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        postcode: freezed == postcode
            ? _value.postcode
            : postcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        numberOfPoints: freezed == numberOfPoints
            ? _value.numberOfPoints
            : numberOfPoints // ignore: cast_nullable_to_non_nullable
                  as int?,
        usageType: freezed == usageType
            ? _value.usageType
            : usageType // ignore: cast_nullable_to_non_nullable
                  as String?,
        usageCost: freezed == usageCost
            ? _value.usageCost
            : usageCost // ignore: cast_nullable_to_non_nullable
                  as String?,
        statusType: freezed == statusType
            ? _value.statusType
            : statusType // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOperational: freezed == isOperational
            ? _value.isOperational
            : isOperational // ignore: cast_nullable_to_non_nullable
                  as bool?,
        operatorName: freezed == operatorName
            ? _value.operatorName
            : operatorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        operatorWebsite: freezed == operatorWebsite
            ? _value.operatorWebsite
            : operatorWebsite // ignore: cast_nullable_to_non_nullable
                  as String?,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        generalComments: freezed == generalComments
            ? _value.generalComments
            : generalComments // ignore: cast_nullable_to_non_nullable
                  as String?,
        accessComments: freezed == accessComments
            ? _value.accessComments
            : accessComments // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactPhone: freezed == contactPhone
            ? _value.contactPhone
            : contactPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateLastVerified: freezed == dateLastVerified
            ? _value.dateLastVerified
            : dateLastVerified // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRecentlyVerified: freezed == isRecentlyVerified
            ? _value.isRecentlyVerified
            : isRecentlyVerified // ignore: cast_nullable_to_non_nullable
                  as bool?,
        connections: null == connections
            ? _value._connections
            : connections // ignore: cast_nullable_to_non_nullable
                  as List<Connection>,
        dataSource: null == dataSource
            ? _value.dataSource
            : dataSource // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChargingStationImpl implements _ChargingStation {
  const _$ChargingStationImpl({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.uuid,
    this.address,
    this.addressLine2,
    this.town,
    this.stateOrProvince,
    this.country,
    this.countryCode,
    this.postcode,
    this.numberOfPoints,
    this.usageType,
    this.usageCost,
    this.statusType,
    this.isOperational,
    this.operatorName,
    this.operatorWebsite,
    this.distanceKm,
    this.generalComments,
    this.accessComments,
    this.contactPhone,
    this.dateLastVerified,
    this.isRecentlyVerified,
    final List<Connection> connections = const [],
    this.dataSource = 'ocm',
  }) : _connections = connections;

  factory _$ChargingStationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargingStationImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? uuid;
  @override
  final String? address;
  @override
  final String? addressLine2;
  @override
  final String? town;
  @override
  final String? stateOrProvince;
  @override
  final String? country;
  @override
  final String? countryCode;
  @override
  final String? postcode;
  @override
  final int? numberOfPoints;
  @override
  final String? usageType;
  @override
  final String? usageCost;
  @override
  final String? statusType;
  @override
  final bool? isOperational;
  @override
  final String? operatorName;
  @override
  final String? operatorWebsite;
  @override
  final double? distanceKm;
  @override
  final String? generalComments;
  @override
  final String? accessComments;
  @override
  final String? contactPhone;
  @override
  final String? dateLastVerified;
  @override
  final bool? isRecentlyVerified;
  final List<Connection> _connections;
  @override
  @JsonKey()
  List<Connection> get connections {
    if (_connections is EqualUnmodifiableListView) return _connections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connections);
  }

  @override
  @JsonKey()
  final String dataSource;

  @override
  String toString() {
    return 'ChargingStation(id: $id, name: $name, latitude: $latitude, longitude: $longitude, uuid: $uuid, address: $address, addressLine2: $addressLine2, town: $town, stateOrProvince: $stateOrProvince, country: $country, countryCode: $countryCode, postcode: $postcode, numberOfPoints: $numberOfPoints, usageType: $usageType, usageCost: $usageCost, statusType: $statusType, isOperational: $isOperational, operatorName: $operatorName, operatorWebsite: $operatorWebsite, distanceKm: $distanceKm, generalComments: $generalComments, accessComments: $accessComments, contactPhone: $contactPhone, dateLastVerified: $dateLastVerified, isRecentlyVerified: $isRecentlyVerified, connections: $connections, dataSource: $dataSource)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargingStationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.town, town) || other.town == town) &&
            (identical(other.stateOrProvince, stateOrProvince) ||
                other.stateOrProvince == stateOrProvince) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.numberOfPoints, numberOfPoints) ||
                other.numberOfPoints == numberOfPoints) &&
            (identical(other.usageType, usageType) ||
                other.usageType == usageType) &&
            (identical(other.usageCost, usageCost) ||
                other.usageCost == usageCost) &&
            (identical(other.statusType, statusType) ||
                other.statusType == statusType) &&
            (identical(other.isOperational, isOperational) ||
                other.isOperational == isOperational) &&
            (identical(other.operatorName, operatorName) ||
                other.operatorName == operatorName) &&
            (identical(other.operatorWebsite, operatorWebsite) ||
                other.operatorWebsite == operatorWebsite) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.generalComments, generalComments) ||
                other.generalComments == generalComments) &&
            (identical(other.accessComments, accessComments) ||
                other.accessComments == accessComments) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.dateLastVerified, dateLastVerified) ||
                other.dateLastVerified == dateLastVerified) &&
            (identical(other.isRecentlyVerified, isRecentlyVerified) ||
                other.isRecentlyVerified == isRecentlyVerified) &&
            const DeepCollectionEquality().equals(
              other._connections,
              _connections,
            ) &&
            (identical(other.dataSource, dataSource) ||
                other.dataSource == dataSource));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    latitude,
    longitude,
    uuid,
    address,
    addressLine2,
    town,
    stateOrProvince,
    country,
    countryCode,
    postcode,
    numberOfPoints,
    usageType,
    usageCost,
    statusType,
    isOperational,
    operatorName,
    operatorWebsite,
    distanceKm,
    generalComments,
    accessComments,
    contactPhone,
    dateLastVerified,
    isRecentlyVerified,
    const DeepCollectionEquality().hash(_connections),
    dataSource,
  ]);

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargingStationImplCopyWith<_$ChargingStationImpl> get copyWith =>
      __$$ChargingStationImplCopyWithImpl<_$ChargingStationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargingStationImplToJson(this);
  }
}

abstract class _ChargingStation implements ChargingStation {
  const factory _ChargingStation({
    required final int id,
    required final String name,
    required final double latitude,
    required final double longitude,
    final String? uuid,
    final String? address,
    final String? addressLine2,
    final String? town,
    final String? stateOrProvince,
    final String? country,
    final String? countryCode,
    final String? postcode,
    final int? numberOfPoints,
    final String? usageType,
    final String? usageCost,
    final String? statusType,
    final bool? isOperational,
    final String? operatorName,
    final String? operatorWebsite,
    final double? distanceKm,
    final String? generalComments,
    final String? accessComments,
    final String? contactPhone,
    final String? dateLastVerified,
    final bool? isRecentlyVerified,
    final List<Connection> connections,
    final String dataSource,
  }) = _$ChargingStationImpl;

  factory _ChargingStation.fromJson(Map<String, dynamic> json) =
      _$ChargingStationImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get uuid;
  @override
  String? get address;
  @override
  String? get addressLine2;
  @override
  String? get town;
  @override
  String? get stateOrProvince;
  @override
  String? get country;
  @override
  String? get countryCode;
  @override
  String? get postcode;
  @override
  int? get numberOfPoints;
  @override
  String? get usageType;
  @override
  String? get usageCost;
  @override
  String? get statusType;
  @override
  bool? get isOperational;
  @override
  String? get operatorName;
  @override
  String? get operatorWebsite;
  @override
  double? get distanceKm;
  @override
  String? get generalComments;
  @override
  String? get accessComments;
  @override
  String? get contactPhone;
  @override
  String? get dateLastVerified;
  @override
  bool? get isRecentlyVerified;
  @override
  List<Connection> get connections;
  @override
  String get dataSource;

  /// Create a copy of ChargingStation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargingStationImplCopyWith<_$ChargingStationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Connection _$ConnectionFromJson(Map<String, dynamic> json) {
  return _Connection.fromJson(json);
}

/// @nodoc
mixin _$Connection {
  int? get id => throw _privateConstructorUsedError;
  String? get connectionType => throw _privateConstructorUsedError;
  String? get formalName => throw _privateConstructorUsedError;
  String? get level => throw _privateConstructorUsedError;
  bool? get isFastCharge => throw _privateConstructorUsedError;
  double? get powerKw => throw _privateConstructorUsedError;
  int? get amps => throw _privateConstructorUsedError;
  int? get voltage => throw _privateConstructorUsedError;
  String? get currentType => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  String? get statusType => throw _privateConstructorUsedError;
  bool? get isOperational => throw _privateConstructorUsedError;

  /// Serializes this Connection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionCopyWith<Connection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionCopyWith<$Res> {
  factory $ConnectionCopyWith(
    Connection value,
    $Res Function(Connection) then,
  ) = _$ConnectionCopyWithImpl<$Res, Connection>;
  @useResult
  $Res call({
    int? id,
    String? connectionType,
    String? formalName,
    String? level,
    bool? isFastCharge,
    double? powerKw,
    int? amps,
    int? voltage,
    String? currentType,
    int? quantity,
    String? statusType,
    bool? isOperational,
  });
}

/// @nodoc
class _$ConnectionCopyWithImpl<$Res, $Val extends Connection>
    implements $ConnectionCopyWith<$Res> {
  _$ConnectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? connectionType = freezed,
    Object? formalName = freezed,
    Object? level = freezed,
    Object? isFastCharge = freezed,
    Object? powerKw = freezed,
    Object? amps = freezed,
    Object? voltage = freezed,
    Object? currentType = freezed,
    Object? quantity = freezed,
    Object? statusType = freezed,
    Object? isOperational = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            connectionType: freezed == connectionType
                ? _value.connectionType
                : connectionType // ignore: cast_nullable_to_non_nullable
                      as String?,
            formalName: freezed == formalName
                ? _value.formalName
                : formalName // ignore: cast_nullable_to_non_nullable
                      as String?,
            level: freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFastCharge: freezed == isFastCharge
                ? _value.isFastCharge
                : isFastCharge // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
            currentType: freezed == currentType
                ? _value.currentType
                : currentType // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            statusType: freezed == statusType
                ? _value.statusType
                : statusType // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOperational: freezed == isOperational
                ? _value.isOperational
                : isOperational // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConnectionImplCopyWith<$Res>
    implements $ConnectionCopyWith<$Res> {
  factory _$$ConnectionImplCopyWith(
    _$ConnectionImpl value,
    $Res Function(_$ConnectionImpl) then,
  ) = __$$ConnectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? connectionType,
    String? formalName,
    String? level,
    bool? isFastCharge,
    double? powerKw,
    int? amps,
    int? voltage,
    String? currentType,
    int? quantity,
    String? statusType,
    bool? isOperational,
  });
}

/// @nodoc
class __$$ConnectionImplCopyWithImpl<$Res>
    extends _$ConnectionCopyWithImpl<$Res, _$ConnectionImpl>
    implements _$$ConnectionImplCopyWith<$Res> {
  __$$ConnectionImplCopyWithImpl(
    _$ConnectionImpl _value,
    $Res Function(_$ConnectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? connectionType = freezed,
    Object? formalName = freezed,
    Object? level = freezed,
    Object? isFastCharge = freezed,
    Object? powerKw = freezed,
    Object? amps = freezed,
    Object? voltage = freezed,
    Object? currentType = freezed,
    Object? quantity = freezed,
    Object? statusType = freezed,
    Object? isOperational = freezed,
  }) {
    return _then(
      _$ConnectionImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        connectionType: freezed == connectionType
            ? _value.connectionType
            : connectionType // ignore: cast_nullable_to_non_nullable
                  as String?,
        formalName: freezed == formalName
            ? _value.formalName
            : formalName // ignore: cast_nullable_to_non_nullable
                  as String?,
        level: freezed == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFastCharge: freezed == isFastCharge
            ? _value.isFastCharge
            : isFastCharge // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
        currentType: freezed == currentType
            ? _value.currentType
            : currentType // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        statusType: freezed == statusType
            ? _value.statusType
            : statusType // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOperational: freezed == isOperational
            ? _value.isOperational
            : isOperational // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionImpl implements _Connection {
  const _$ConnectionImpl({
    this.id,
    this.connectionType,
    this.formalName,
    this.level,
    this.isFastCharge,
    this.powerKw,
    this.amps,
    this.voltage,
    this.currentType,
    this.quantity,
    this.statusType,
    this.isOperational,
  });

  factory _$ConnectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionImplFromJson(json);

  @override
  final int? id;
  @override
  final String? connectionType;
  @override
  final String? formalName;
  @override
  final String? level;
  @override
  final bool? isFastCharge;
  @override
  final double? powerKw;
  @override
  final int? amps;
  @override
  final int? voltage;
  @override
  final String? currentType;
  @override
  final int? quantity;
  @override
  final String? statusType;
  @override
  final bool? isOperational;

  @override
  String toString() {
    return 'Connection(id: $id, connectionType: $connectionType, formalName: $formalName, level: $level, isFastCharge: $isFastCharge, powerKw: $powerKw, amps: $amps, voltage: $voltage, currentType: $currentType, quantity: $quantity, statusType: $statusType, isOperational: $isOperational)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.formalName, formalName) ||
                other.formalName == formalName) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.isFastCharge, isFastCharge) ||
                other.isFastCharge == isFastCharge) &&
            (identical(other.powerKw, powerKw) || other.powerKw == powerKw) &&
            (identical(other.amps, amps) || other.amps == amps) &&
            (identical(other.voltage, voltage) || other.voltage == voltage) &&
            (identical(other.currentType, currentType) ||
                other.currentType == currentType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.statusType, statusType) ||
                other.statusType == statusType) &&
            (identical(other.isOperational, isOperational) ||
                other.isOperational == isOperational));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    connectionType,
    formalName,
    level,
    isFastCharge,
    powerKw,
    amps,
    voltage,
    currentType,
    quantity,
    statusType,
    isOperational,
  );

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionImplCopyWith<_$ConnectionImpl> get copyWith =>
      __$$ConnectionImplCopyWithImpl<_$ConnectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionImplToJson(this);
  }
}

abstract class _Connection implements Connection {
  const factory _Connection({
    final int? id,
    final String? connectionType,
    final String? formalName,
    final String? level,
    final bool? isFastCharge,
    final double? powerKw,
    final int? amps,
    final int? voltage,
    final String? currentType,
    final int? quantity,
    final String? statusType,
    final bool? isOperational,
  }) = _$ConnectionImpl;

  factory _Connection.fromJson(Map<String, dynamic> json) =
      _$ConnectionImpl.fromJson;

  @override
  int? get id;
  @override
  String? get connectionType;
  @override
  String? get formalName;
  @override
  String? get level;
  @override
  bool? get isFastCharge;
  @override
  double? get powerKw;
  @override
  int? get amps;
  @override
  int? get voltage;
  @override
  String? get currentType;
  @override
  int? get quantity;
  @override
  String? get statusType;
  @override
  bool? get isOperational;

  /// Create a copy of Connection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionImplCopyWith<_$ConnectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
