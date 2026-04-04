// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PlanState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String from, String to) calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )
    result,
    required TResult Function(String from, String to) empty,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to)? calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult? Function(String from, String to)? empty,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to)? calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult Function(String from, String to)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlanIdle value) idle,
    required TResult Function(PlanCalculating value) calculating,
    required TResult Function(PlanResult value) result,
    required TResult Function(PlanEmpty value) empty,
    required TResult Function(PlanError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlanIdle value)? idle,
    TResult? Function(PlanCalculating value)? calculating,
    TResult? Function(PlanResult value)? result,
    TResult? Function(PlanEmpty value)? empty,
    TResult? Function(PlanError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlanIdle value)? idle,
    TResult Function(PlanCalculating value)? calculating,
    TResult Function(PlanResult value)? result,
    TResult Function(PlanEmpty value)? empty,
    TResult Function(PlanError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanStateCopyWith<$Res> {
  factory $PlanStateCopyWith(PlanState value, $Res Function(PlanState) then) =
      _$PlanStateCopyWithImpl<$Res, PlanState>;
}

/// @nodoc
class _$PlanStateCopyWithImpl<$Res, $Val extends PlanState>
    implements $PlanStateCopyWith<$Res> {
  _$PlanStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PlanIdleImplCopyWith<$Res> {
  factory _$$PlanIdleImplCopyWith(
    _$PlanIdleImpl value,
    $Res Function(_$PlanIdleImpl) then,
  ) = __$$PlanIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PlanIdleImplCopyWithImpl<$Res>
    extends _$PlanStateCopyWithImpl<$Res, _$PlanIdleImpl>
    implements _$$PlanIdleImplCopyWith<$Res> {
  __$$PlanIdleImplCopyWithImpl(
    _$PlanIdleImpl _value,
    $Res Function(_$PlanIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PlanIdleImpl implements PlanIdle {
  const _$PlanIdleImpl();

  @override
  String toString() {
    return 'PlanState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PlanIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String from, String to) calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )
    result,
    required TResult Function(String from, String to) empty,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to)? calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult? Function(String from, String to)? empty,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to)? calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult Function(String from, String to)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlanIdle value) idle,
    required TResult Function(PlanCalculating value) calculating,
    required TResult Function(PlanResult value) result,
    required TResult Function(PlanEmpty value) empty,
    required TResult Function(PlanError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlanIdle value)? idle,
    TResult? Function(PlanCalculating value)? calculating,
    TResult? Function(PlanResult value)? result,
    TResult? Function(PlanEmpty value)? empty,
    TResult? Function(PlanError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlanIdle value)? idle,
    TResult Function(PlanCalculating value)? calculating,
    TResult Function(PlanResult value)? result,
    TResult Function(PlanEmpty value)? empty,
    TResult Function(PlanError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class PlanIdle implements PlanState {
  const factory PlanIdle() = _$PlanIdleImpl;
}

/// @nodoc
abstract class _$$PlanCalculatingImplCopyWith<$Res> {
  factory _$$PlanCalculatingImplCopyWith(
    _$PlanCalculatingImpl value,
    $Res Function(_$PlanCalculatingImpl) then,
  ) = __$$PlanCalculatingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String from, String to});
}

/// @nodoc
class __$$PlanCalculatingImplCopyWithImpl<$Res>
    extends _$PlanStateCopyWithImpl<$Res, _$PlanCalculatingImpl>
    implements _$$PlanCalculatingImplCopyWith<$Res> {
  __$$PlanCalculatingImplCopyWithImpl(
    _$PlanCalculatingImpl _value,
    $Res Function(_$PlanCalculatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? to = null}) {
    return _then(
      _$PlanCalculatingImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PlanCalculatingImpl implements PlanCalculating {
  const _$PlanCalculatingImpl({required this.from, required this.to});

  @override
  final String from;
  @override
  final String to;

  @override
  String toString() {
    return 'PlanState.calculating(from: $from, to: $to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanCalculatingImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanCalculatingImplCopyWith<_$PlanCalculatingImpl> get copyWith =>
      __$$PlanCalculatingImplCopyWithImpl<_$PlanCalculatingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String from, String to) calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )
    result,
    required TResult Function(String from, String to) empty,
    required TResult Function(String message) error,
  }) {
    return calculating(from, to);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to)? calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult? Function(String from, String to)? empty,
    TResult? Function(String message)? error,
  }) {
    return calculating?.call(from, to);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to)? calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult Function(String from, String to)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (calculating != null) {
      return calculating(from, to);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlanIdle value) idle,
    required TResult Function(PlanCalculating value) calculating,
    required TResult Function(PlanResult value) result,
    required TResult Function(PlanEmpty value) empty,
    required TResult Function(PlanError value) error,
  }) {
    return calculating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlanIdle value)? idle,
    TResult? Function(PlanCalculating value)? calculating,
    TResult? Function(PlanResult value)? result,
    TResult? Function(PlanEmpty value)? empty,
    TResult? Function(PlanError value)? error,
  }) {
    return calculating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlanIdle value)? idle,
    TResult Function(PlanCalculating value)? calculating,
    TResult Function(PlanResult value)? result,
    TResult Function(PlanEmpty value)? empty,
    TResult Function(PlanError value)? error,
    required TResult orElse(),
  }) {
    if (calculating != null) {
      return calculating(this);
    }
    return orElse();
  }
}

abstract class PlanCalculating implements PlanState {
  const factory PlanCalculating({
    required final String from,
    required final String to,
  }) = _$PlanCalculatingImpl;

  String get from;
  String get to;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanCalculatingImplCopyWith<_$PlanCalculatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlanResultImplCopyWith<$Res> {
  factory _$$PlanResultImplCopyWith(
    _$PlanResultImpl value,
    $Res Function(_$PlanResultImpl) then,
  ) = __$$PlanResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String from,
    String to,
    List<ChargingStation> stations,
    double totalDistanceKm,
    int durationMinutes,
    List<ChargingGap> gaps,
  });
}

/// @nodoc
class __$$PlanResultImplCopyWithImpl<$Res>
    extends _$PlanStateCopyWithImpl<$Res, _$PlanResultImpl>
    implements _$$PlanResultImplCopyWith<$Res> {
  __$$PlanResultImplCopyWithImpl(
    _$PlanResultImpl _value,
    $Res Function(_$PlanResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? stations = null,
    Object? totalDistanceKm = null,
    Object? durationMinutes = null,
    Object? gaps = null,
  }) {
    return _then(
      _$PlanResultImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
        stations: null == stations
            ? _value._stations
            : stations // ignore: cast_nullable_to_non_nullable
                  as List<ChargingStation>,
        totalDistanceKm: null == totalDistanceKm
            ? _value.totalDistanceKm
            : totalDistanceKm // ignore: cast_nullable_to_non_nullable
                  as double,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        gaps: null == gaps
            ? _value._gaps
            : gaps // ignore: cast_nullable_to_non_nullable
                  as List<ChargingGap>,
      ),
    );
  }
}

/// @nodoc

class _$PlanResultImpl implements PlanResult {
  const _$PlanResultImpl({
    required this.from,
    required this.to,
    required final List<ChargingStation> stations,
    required this.totalDistanceKm,
    required this.durationMinutes,
    final List<ChargingGap> gaps = const [],
  }) : _stations = stations,
       _gaps = gaps;

  @override
  final String from;
  @override
  final String to;
  final List<ChargingStation> _stations;
  @override
  List<ChargingStation> get stations {
    if (_stations is EqualUnmodifiableListView) return _stations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stations);
  }

  @override
  final double totalDistanceKm;
  @override
  final int durationMinutes;
  final List<ChargingGap> _gaps;
  @override
  @JsonKey()
  List<ChargingGap> get gaps {
    if (_gaps is EqualUnmodifiableListView) return _gaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gaps);
  }

  @override
  String toString() {
    return 'PlanState.result(from: $from, to: $to, stations: $stations, totalDistanceKm: $totalDistanceKm, durationMinutes: $durationMinutes, gaps: $gaps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanResultImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            const DeepCollectionEquality().equals(other._stations, _stations) &&
            (identical(other.totalDistanceKm, totalDistanceKm) ||
                other.totalDistanceKm == totalDistanceKm) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            const DeepCollectionEquality().equals(other._gaps, _gaps));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    from,
    to,
    const DeepCollectionEquality().hash(_stations),
    totalDistanceKm,
    durationMinutes,
    const DeepCollectionEquality().hash(_gaps),
  );

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanResultImplCopyWith<_$PlanResultImpl> get copyWith =>
      __$$PlanResultImplCopyWithImpl<_$PlanResultImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String from, String to) calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )
    result,
    required TResult Function(String from, String to) empty,
    required TResult Function(String message) error,
  }) {
    return result(from, to, stations, totalDistanceKm, durationMinutes, gaps);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to)? calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult? Function(String from, String to)? empty,
    TResult? Function(String message)? error,
  }) {
    return result?.call(
      from,
      to,
      stations,
      totalDistanceKm,
      durationMinutes,
      gaps,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to)? calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult Function(String from, String to)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(from, to, stations, totalDistanceKm, durationMinutes, gaps);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlanIdle value) idle,
    required TResult Function(PlanCalculating value) calculating,
    required TResult Function(PlanResult value) result,
    required TResult Function(PlanEmpty value) empty,
    required TResult Function(PlanError value) error,
  }) {
    return result(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlanIdle value)? idle,
    TResult? Function(PlanCalculating value)? calculating,
    TResult? Function(PlanResult value)? result,
    TResult? Function(PlanEmpty value)? empty,
    TResult? Function(PlanError value)? error,
  }) {
    return result?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlanIdle value)? idle,
    TResult Function(PlanCalculating value)? calculating,
    TResult Function(PlanResult value)? result,
    TResult Function(PlanEmpty value)? empty,
    TResult Function(PlanError value)? error,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(this);
    }
    return orElse();
  }
}

abstract class PlanResult implements PlanState {
  const factory PlanResult({
    required final String from,
    required final String to,
    required final List<ChargingStation> stations,
    required final double totalDistanceKm,
    required final int durationMinutes,
    final List<ChargingGap> gaps,
  }) = _$PlanResultImpl;

  String get from;
  String get to;
  List<ChargingStation> get stations;
  double get totalDistanceKm;
  int get durationMinutes;
  List<ChargingGap> get gaps;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanResultImplCopyWith<_$PlanResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlanEmptyImplCopyWith<$Res> {
  factory _$$PlanEmptyImplCopyWith(
    _$PlanEmptyImpl value,
    $Res Function(_$PlanEmptyImpl) then,
  ) = __$$PlanEmptyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String from, String to});
}

/// @nodoc
class __$$PlanEmptyImplCopyWithImpl<$Res>
    extends _$PlanStateCopyWithImpl<$Res, _$PlanEmptyImpl>
    implements _$$PlanEmptyImplCopyWith<$Res> {
  __$$PlanEmptyImplCopyWithImpl(
    _$PlanEmptyImpl _value,
    $Res Function(_$PlanEmptyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? to = null}) {
    return _then(
      _$PlanEmptyImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PlanEmptyImpl implements PlanEmpty {
  const _$PlanEmptyImpl({required this.from, required this.to});

  @override
  final String from;
  @override
  final String to;

  @override
  String toString() {
    return 'PlanState.empty(from: $from, to: $to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanEmptyImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanEmptyImplCopyWith<_$PlanEmptyImpl> get copyWith =>
      __$$PlanEmptyImplCopyWithImpl<_$PlanEmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String from, String to) calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )
    result,
    required TResult Function(String from, String to) empty,
    required TResult Function(String message) error,
  }) {
    return empty(from, to);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to)? calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult? Function(String from, String to)? empty,
    TResult? Function(String message)? error,
  }) {
    return empty?.call(from, to);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to)? calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult Function(String from, String to)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(from, to);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlanIdle value) idle,
    required TResult Function(PlanCalculating value) calculating,
    required TResult Function(PlanResult value) result,
    required TResult Function(PlanEmpty value) empty,
    required TResult Function(PlanError value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlanIdle value)? idle,
    TResult? Function(PlanCalculating value)? calculating,
    TResult? Function(PlanResult value)? result,
    TResult? Function(PlanEmpty value)? empty,
    TResult? Function(PlanError value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlanIdle value)? idle,
    TResult Function(PlanCalculating value)? calculating,
    TResult Function(PlanResult value)? result,
    TResult Function(PlanEmpty value)? empty,
    TResult Function(PlanError value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class PlanEmpty implements PlanState {
  const factory PlanEmpty({
    required final String from,
    required final String to,
  }) = _$PlanEmptyImpl;

  String get from;
  String get to;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanEmptyImplCopyWith<_$PlanEmptyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlanErrorImplCopyWith<$Res> {
  factory _$$PlanErrorImplCopyWith(
    _$PlanErrorImpl value,
    $Res Function(_$PlanErrorImpl) then,
  ) = __$$PlanErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PlanErrorImplCopyWithImpl<$Res>
    extends _$PlanStateCopyWithImpl<$Res, _$PlanErrorImpl>
    implements _$$PlanErrorImplCopyWith<$Res> {
  __$$PlanErrorImplCopyWithImpl(
    _$PlanErrorImpl _value,
    $Res Function(_$PlanErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$PlanErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PlanErrorImpl implements PlanError {
  const _$PlanErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PlanState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanErrorImplCopyWith<_$PlanErrorImpl> get copyWith =>
      __$$PlanErrorImplCopyWithImpl<_$PlanErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String from, String to) calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )
    result,
    required TResult Function(String from, String to) empty,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to)? calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult? Function(String from, String to)? empty,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to)? calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
    )?
    result,
    TResult Function(String from, String to)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlanIdle value) idle,
    required TResult Function(PlanCalculating value) calculating,
    required TResult Function(PlanResult value) result,
    required TResult Function(PlanEmpty value) empty,
    required TResult Function(PlanError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlanIdle value)? idle,
    TResult? Function(PlanCalculating value)? calculating,
    TResult? Function(PlanResult value)? result,
    TResult? Function(PlanEmpty value)? empty,
    TResult? Function(PlanError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlanIdle value)? idle,
    TResult Function(PlanCalculating value)? calculating,
    TResult Function(PlanResult value)? result,
    TResult Function(PlanEmpty value)? empty,
    TResult Function(PlanError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PlanError implements PlanState {
  const factory PlanError(final String message) = _$PlanErrorImpl;

  String get message;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanErrorImplCopyWith<_$PlanErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
