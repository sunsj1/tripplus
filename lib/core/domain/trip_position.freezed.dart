// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TripPosition {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get accuracyMeters => throw _privateConstructorUsedError;
  DateTime get capturedAt => throw _privateConstructorUsedError;
  double get speedMetersPerSecond => throw _privateConstructorUsedError;
  double get headingDegrees => throw _privateConstructorUsedError;

  /// Create a copy of TripPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripPositionCopyWith<TripPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripPositionCopyWith<$Res> {
  factory $TripPositionCopyWith(
    TripPosition value,
    $Res Function(TripPosition) then,
  ) = _$TripPositionCopyWithImpl<$Res, TripPosition>;
  @useResult
  $Res call({
    double latitude,
    double longitude,
    double accuracyMeters,
    DateTime capturedAt,
    double speedMetersPerSecond,
    double headingDegrees,
  });
}

/// @nodoc
class _$TripPositionCopyWithImpl<$Res, $Val extends TripPosition>
    implements $TripPositionCopyWith<$Res> {
  _$TripPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracyMeters = null,
    Object? capturedAt = null,
    Object? speedMetersPerSecond = null,
    Object? headingDegrees = null,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            accuracyMeters: null == accuracyMeters
                ? _value.accuracyMeters
                : accuracyMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            capturedAt: null == capturedAt
                ? _value.capturedAt
                : capturedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            speedMetersPerSecond: null == speedMetersPerSecond
                ? _value.speedMetersPerSecond
                : speedMetersPerSecond // ignore: cast_nullable_to_non_nullable
                      as double,
            headingDegrees: null == headingDegrees
                ? _value.headingDegrees
                : headingDegrees // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripPositionImplCopyWith<$Res>
    implements $TripPositionCopyWith<$Res> {
  factory _$$TripPositionImplCopyWith(
    _$TripPositionImpl value,
    $Res Function(_$TripPositionImpl) then,
  ) = __$$TripPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double latitude,
    double longitude,
    double accuracyMeters,
    DateTime capturedAt,
    double speedMetersPerSecond,
    double headingDegrees,
  });
}

/// @nodoc
class __$$TripPositionImplCopyWithImpl<$Res>
    extends _$TripPositionCopyWithImpl<$Res, _$TripPositionImpl>
    implements _$$TripPositionImplCopyWith<$Res> {
  __$$TripPositionImplCopyWithImpl(
    _$TripPositionImpl _value,
    $Res Function(_$TripPositionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracyMeters = null,
    Object? capturedAt = null,
    Object? speedMetersPerSecond = null,
    Object? headingDegrees = null,
  }) {
    return _then(
      _$TripPositionImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        accuracyMeters: null == accuracyMeters
            ? _value.accuracyMeters
            : accuracyMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        capturedAt: null == capturedAt
            ? _value.capturedAt
            : capturedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        speedMetersPerSecond: null == speedMetersPerSecond
            ? _value.speedMetersPerSecond
            : speedMetersPerSecond // ignore: cast_nullable_to_non_nullable
                  as double,
        headingDegrees: null == headingDegrees
            ? _value.headingDegrees
            : headingDegrees // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$TripPositionImpl extends _TripPosition {
  const _$TripPositionImpl({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.capturedAt,
    this.speedMetersPerSecond = 0,
    this.headingDegrees = 0,
  }) : super._();

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double accuracyMeters;
  @override
  final DateTime capturedAt;
  @override
  @JsonKey()
  final double speedMetersPerSecond;
  @override
  @JsonKey()
  final double headingDegrees;

  @override
  String toString() {
    return 'TripPosition(latitude: $latitude, longitude: $longitude, accuracyMeters: $accuracyMeters, capturedAt: $capturedAt, speedMetersPerSecond: $speedMetersPerSecond, headingDegrees: $headingDegrees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripPositionImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.accuracyMeters, accuracyMeters) ||
                other.accuracyMeters == accuracyMeters) &&
            (identical(other.capturedAt, capturedAt) ||
                other.capturedAt == capturedAt) &&
            (identical(other.speedMetersPerSecond, speedMetersPerSecond) ||
                other.speedMetersPerSecond == speedMetersPerSecond) &&
            (identical(other.headingDegrees, headingDegrees) ||
                other.headingDegrees == headingDegrees));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    latitude,
    longitude,
    accuracyMeters,
    capturedAt,
    speedMetersPerSecond,
    headingDegrees,
  );

  /// Create a copy of TripPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripPositionImplCopyWith<_$TripPositionImpl> get copyWith =>
      __$$TripPositionImplCopyWithImpl<_$TripPositionImpl>(this, _$identity);
}

abstract class _TripPosition extends TripPosition {
  const factory _TripPosition({
    required final double latitude,
    required final double longitude,
    required final double accuracyMeters,
    required final DateTime capturedAt,
    final double speedMetersPerSecond,
    final double headingDegrees,
  }) = _$TripPositionImpl;
  const _TripPosition._() : super._();

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get accuracyMeters;
  @override
  DateTime get capturedAt;
  @override
  double get speedMetersPerSecond;
  @override
  double get headingDegrees;

  /// Create a copy of TripPosition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripPositionImplCopyWith<_$TripPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
