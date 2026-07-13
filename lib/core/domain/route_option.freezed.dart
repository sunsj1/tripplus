// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RouteOption {
  String get id => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  double get distanceKm => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  int? get durationInTrafficMinutes => throw _privateConstructorUsedError;
  String get encodedPolyline => throw _privateConstructorUsedError;
  List<LatLng> get polylinePoints => throw _privateConstructorUsedError;
  bool get hasTolls => throw _privateConstructorUsedError;
  bool get isSuggested => throw _privateConstructorUsedError;

  /// Create a copy of RouteOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteOptionCopyWith<RouteOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteOptionCopyWith<$Res> {
  factory $RouteOptionCopyWith(
    RouteOption value,
    $Res Function(RouteOption) then,
  ) = _$RouteOptionCopyWithImpl<$Res, RouteOption>;
  @useResult
  $Res call({
    String id,
    String summary,
    double distanceKm,
    int durationMinutes,
    int? durationInTrafficMinutes,
    String encodedPolyline,
    List<LatLng> polylinePoints,
    bool hasTolls,
    bool isSuggested,
  });
}

/// @nodoc
class _$RouteOptionCopyWithImpl<$Res, $Val extends RouteOption>
    implements $RouteOptionCopyWith<$Res> {
  _$RouteOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? summary = null,
    Object? distanceKm = null,
    Object? durationMinutes = null,
    Object? durationInTrafficMinutes = freezed,
    Object? encodedPolyline = null,
    Object? polylinePoints = null,
    Object? hasTolls = null,
    Object? isSuggested = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            distanceKm: null == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            durationInTrafficMinutes: freezed == durationInTrafficMinutes
                ? _value.durationInTrafficMinutes
                : durationInTrafficMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            encodedPolyline: null == encodedPolyline
                ? _value.encodedPolyline
                : encodedPolyline // ignore: cast_nullable_to_non_nullable
                      as String,
            polylinePoints: null == polylinePoints
                ? _value.polylinePoints
                : polylinePoints // ignore: cast_nullable_to_non_nullable
                      as List<LatLng>,
            hasTolls: null == hasTolls
                ? _value.hasTolls
                : hasTolls // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuggested: null == isSuggested
                ? _value.isSuggested
                : isSuggested // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RouteOptionImplCopyWith<$Res>
    implements $RouteOptionCopyWith<$Res> {
  factory _$$RouteOptionImplCopyWith(
    _$RouteOptionImpl value,
    $Res Function(_$RouteOptionImpl) then,
  ) = __$$RouteOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String summary,
    double distanceKm,
    int durationMinutes,
    int? durationInTrafficMinutes,
    String encodedPolyline,
    List<LatLng> polylinePoints,
    bool hasTolls,
    bool isSuggested,
  });
}

/// @nodoc
class __$$RouteOptionImplCopyWithImpl<$Res>
    extends _$RouteOptionCopyWithImpl<$Res, _$RouteOptionImpl>
    implements _$$RouteOptionImplCopyWith<$Res> {
  __$$RouteOptionImplCopyWithImpl(
    _$RouteOptionImpl _value,
    $Res Function(_$RouteOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? summary = null,
    Object? distanceKm = null,
    Object? durationMinutes = null,
    Object? durationInTrafficMinutes = freezed,
    Object? encodedPolyline = null,
    Object? polylinePoints = null,
    Object? hasTolls = null,
    Object? isSuggested = null,
  }) {
    return _then(
      _$RouteOptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        distanceKm: null == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        durationInTrafficMinutes: freezed == durationInTrafficMinutes
            ? _value.durationInTrafficMinutes
            : durationInTrafficMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        encodedPolyline: null == encodedPolyline
            ? _value.encodedPolyline
            : encodedPolyline // ignore: cast_nullable_to_non_nullable
                  as String,
        polylinePoints: null == polylinePoints
            ? _value._polylinePoints
            : polylinePoints // ignore: cast_nullable_to_non_nullable
                  as List<LatLng>,
        hasTolls: null == hasTolls
            ? _value.hasTolls
            : hasTolls // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuggested: null == isSuggested
            ? _value.isSuggested
            : isSuggested // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RouteOptionImpl extends _RouteOption {
  const _$RouteOptionImpl({
    required this.id,
    required this.summary,
    required this.distanceKm,
    required this.durationMinutes,
    this.durationInTrafficMinutes,
    required this.encodedPolyline,
    final List<LatLng> polylinePoints = const <LatLng>[],
    this.hasTolls = false,
    this.isSuggested = false,
  }) : _polylinePoints = polylinePoints,
       super._();

  @override
  final String id;
  @override
  final String summary;
  @override
  final double distanceKm;
  @override
  final int durationMinutes;
  @override
  final int? durationInTrafficMinutes;
  @override
  final String encodedPolyline;
  final List<LatLng> _polylinePoints;
  @override
  @JsonKey()
  List<LatLng> get polylinePoints {
    if (_polylinePoints is EqualUnmodifiableListView) return _polylinePoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_polylinePoints);
  }

  @override
  @JsonKey()
  final bool hasTolls;
  @override
  @JsonKey()
  final bool isSuggested;

  @override
  String toString() {
    return 'RouteOption(id: $id, summary: $summary, distanceKm: $distanceKm, durationMinutes: $durationMinutes, durationInTrafficMinutes: $durationInTrafficMinutes, encodedPolyline: $encodedPolyline, polylinePoints: $polylinePoints, hasTolls: $hasTolls, isSuggested: $isSuggested)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(
                  other.durationInTrafficMinutes,
                  durationInTrafficMinutes,
                ) ||
                other.durationInTrafficMinutes == durationInTrafficMinutes) &&
            (identical(other.encodedPolyline, encodedPolyline) ||
                other.encodedPolyline == encodedPolyline) &&
            const DeepCollectionEquality().equals(
              other._polylinePoints,
              _polylinePoints,
            ) &&
            (identical(other.hasTolls, hasTolls) ||
                other.hasTolls == hasTolls) &&
            (identical(other.isSuggested, isSuggested) ||
                other.isSuggested == isSuggested));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    summary,
    distanceKm,
    durationMinutes,
    durationInTrafficMinutes,
    encodedPolyline,
    const DeepCollectionEquality().hash(_polylinePoints),
    hasTolls,
    isSuggested,
  );

  /// Create a copy of RouteOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteOptionImplCopyWith<_$RouteOptionImpl> get copyWith =>
      __$$RouteOptionImplCopyWithImpl<_$RouteOptionImpl>(this, _$identity);
}

abstract class _RouteOption extends RouteOption {
  const factory _RouteOption({
    required final String id,
    required final String summary,
    required final double distanceKm,
    required final int durationMinutes,
    final int? durationInTrafficMinutes,
    required final String encodedPolyline,
    final List<LatLng> polylinePoints,
    final bool hasTolls,
    final bool isSuggested,
  }) = _$RouteOptionImpl;
  const _RouteOption._() : super._();

  @override
  String get id;
  @override
  String get summary;
  @override
  double get distanceKm;
  @override
  int get durationMinutes;
  @override
  int? get durationInTrafficMinutes;
  @override
  String get encodedPolyline;
  @override
  List<LatLng> get polylinePoints;
  @override
  bool get hasTolls;
  @override
  bool get isSuggested;

  /// Create a copy of RouteOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteOptionImplCopyWith<_$RouteOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
