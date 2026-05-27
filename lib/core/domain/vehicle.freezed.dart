// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return _Vehicle.fromJson(json);
}

/// @nodoc
mixin _$Vehicle {
  VehicleType get type => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  double? get fuelEfficiencyKmpl => throw _privateConstructorUsedError;
  double? get batteryKwh => throw _privateConstructorUsedError;
  List<String> get connectorTypes => throw _privateConstructorUsedError;
  bool get fastChargeOnly => throw _privateConstructorUsedError;

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleCopyWith<Vehicle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleCopyWith<$Res> {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) then) =
      _$VehicleCopyWithImpl<$Res, Vehicle>;
  @useResult
  $Res call({
    VehicleType type,
    String? nickname,
    double? fuelEfficiencyKmpl,
    double? batteryKwh,
    List<String> connectorTypes,
    bool fastChargeOnly,
  });
}

/// @nodoc
class _$VehicleCopyWithImpl<$Res, $Val extends Vehicle>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? nickname = freezed,
    Object? fuelEfficiencyKmpl = freezed,
    Object? batteryKwh = freezed,
    Object? connectorTypes = null,
    Object? fastChargeOnly = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as VehicleType,
            nickname: freezed == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String?,
            fuelEfficiencyKmpl: freezed == fuelEfficiencyKmpl
                ? _value.fuelEfficiencyKmpl
                : fuelEfficiencyKmpl // ignore: cast_nullable_to_non_nullable
                      as double?,
            batteryKwh: freezed == batteryKwh
                ? _value.batteryKwh
                : batteryKwh // ignore: cast_nullable_to_non_nullable
                      as double?,
            connectorTypes: null == connectorTypes
                ? _value.connectorTypes
                : connectorTypes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            fastChargeOnly: null == fastChargeOnly
                ? _value.fastChargeOnly
                : fastChargeOnly // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleImplCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$$VehicleImplCopyWith(
    _$VehicleImpl value,
    $Res Function(_$VehicleImpl) then,
  ) = __$$VehicleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    VehicleType type,
    String? nickname,
    double? fuelEfficiencyKmpl,
    double? batteryKwh,
    List<String> connectorTypes,
    bool fastChargeOnly,
  });
}

/// @nodoc
class __$$VehicleImplCopyWithImpl<$Res>
    extends _$VehicleCopyWithImpl<$Res, _$VehicleImpl>
    implements _$$VehicleImplCopyWith<$Res> {
  __$$VehicleImplCopyWithImpl(
    _$VehicleImpl _value,
    $Res Function(_$VehicleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? nickname = freezed,
    Object? fuelEfficiencyKmpl = freezed,
    Object? batteryKwh = freezed,
    Object? connectorTypes = null,
    Object? fastChargeOnly = null,
  }) {
    return _then(
      _$VehicleImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as VehicleType,
        nickname: freezed == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String?,
        fuelEfficiencyKmpl: freezed == fuelEfficiencyKmpl
            ? _value.fuelEfficiencyKmpl
            : fuelEfficiencyKmpl // ignore: cast_nullable_to_non_nullable
                  as double?,
        batteryKwh: freezed == batteryKwh
            ? _value.batteryKwh
            : batteryKwh // ignore: cast_nullable_to_non_nullable
                  as double?,
        connectorTypes: null == connectorTypes
            ? _value._connectorTypes
            : connectorTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        fastChargeOnly: null == fastChargeOnly
            ? _value.fastChargeOnly
            : fastChargeOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleImpl extends _Vehicle {
  const _$VehicleImpl({
    required this.type,
    this.nickname,
    this.fuelEfficiencyKmpl,
    this.batteryKwh,
    final List<String> connectorTypes = const <String>[],
    this.fastChargeOnly = false,
  }) : _connectorTypes = connectorTypes,
       super._();

  factory _$VehicleImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleImplFromJson(json);

  @override
  final VehicleType type;
  @override
  final String? nickname;
  @override
  final double? fuelEfficiencyKmpl;
  @override
  final double? batteryKwh;
  final List<String> _connectorTypes;
  @override
  @JsonKey()
  List<String> get connectorTypes {
    if (_connectorTypes is EqualUnmodifiableListView) return _connectorTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connectorTypes);
  }

  @override
  @JsonKey()
  final bool fastChargeOnly;

  @override
  String toString() {
    return 'Vehicle(type: $type, nickname: $nickname, fuelEfficiencyKmpl: $fuelEfficiencyKmpl, batteryKwh: $batteryKwh, connectorTypes: $connectorTypes, fastChargeOnly: $fastChargeOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.fuelEfficiencyKmpl, fuelEfficiencyKmpl) ||
                other.fuelEfficiencyKmpl == fuelEfficiencyKmpl) &&
            (identical(other.batteryKwh, batteryKwh) ||
                other.batteryKwh == batteryKwh) &&
            const DeepCollectionEquality().equals(
              other._connectorTypes,
              _connectorTypes,
            ) &&
            (identical(other.fastChargeOnly, fastChargeOnly) ||
                other.fastChargeOnly == fastChargeOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    nickname,
    fuelEfficiencyKmpl,
    batteryKwh,
    const DeepCollectionEquality().hash(_connectorTypes),
    fastChargeOnly,
  );

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      __$$VehicleImplCopyWithImpl<_$VehicleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleImplToJson(this);
  }
}

abstract class _Vehicle extends Vehicle {
  const factory _Vehicle({
    required final VehicleType type,
    final String? nickname,
    final double? fuelEfficiencyKmpl,
    final double? batteryKwh,
    final List<String> connectorTypes,
    final bool fastChargeOnly,
  }) = _$VehicleImpl;
  const _Vehicle._() : super._();

  factory _Vehicle.fromJson(Map<String, dynamic> json) = _$VehicleImpl.fromJson;

  @override
  VehicleType get type;
  @override
  String? get nickname;
  @override
  double? get fuelEfficiencyKmpl;
  @override
  double? get batteryKwh;
  @override
  List<String> get connectorTypes;
  @override
  bool get fastChargeOnly;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
