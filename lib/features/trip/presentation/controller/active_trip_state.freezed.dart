// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_trip_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ActiveTripState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Trip trip) ready,
    required TResult Function(Trip trip) running,
    required TResult Function(Trip trip) paused,
    required TResult Function(Trip trip) completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Trip trip)? ready,
    TResult? Function(Trip trip)? running,
    TResult? Function(Trip trip)? paused,
    TResult? Function(Trip trip)? completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Trip trip)? ready,
    TResult Function(Trip trip)? running,
    TResult Function(Trip trip)? paused,
    TResult Function(Trip trip)? completed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveTripIdle value) idle,
    required TResult Function(ActiveTripReady value) ready,
    required TResult Function(ActiveTripRunning value) running,
    required TResult Function(ActiveTripPaused value) paused,
    required TResult Function(ActiveTripCompleted value) completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveTripIdle value)? idle,
    TResult? Function(ActiveTripReady value)? ready,
    TResult? Function(ActiveTripRunning value)? running,
    TResult? Function(ActiveTripPaused value)? paused,
    TResult? Function(ActiveTripCompleted value)? completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveTripIdle value)? idle,
    TResult Function(ActiveTripReady value)? ready,
    TResult Function(ActiveTripRunning value)? running,
    TResult Function(ActiveTripPaused value)? paused,
    TResult Function(ActiveTripCompleted value)? completed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveTripStateCopyWith<$Res> {
  factory $ActiveTripStateCopyWith(
    ActiveTripState value,
    $Res Function(ActiveTripState) then,
  ) = _$ActiveTripStateCopyWithImpl<$Res, ActiveTripState>;
}

/// @nodoc
class _$ActiveTripStateCopyWithImpl<$Res, $Val extends ActiveTripState>
    implements $ActiveTripStateCopyWith<$Res> {
  _$ActiveTripStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ActiveTripIdleImplCopyWith<$Res> {
  factory _$$ActiveTripIdleImplCopyWith(
    _$ActiveTripIdleImpl value,
    $Res Function(_$ActiveTripIdleImpl) then,
  ) = __$$ActiveTripIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActiveTripIdleImplCopyWithImpl<$Res>
    extends _$ActiveTripStateCopyWithImpl<$Res, _$ActiveTripIdleImpl>
    implements _$$ActiveTripIdleImplCopyWith<$Res> {
  __$$ActiveTripIdleImplCopyWithImpl(
    _$ActiveTripIdleImpl _value,
    $Res Function(_$ActiveTripIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ActiveTripIdleImpl implements ActiveTripIdle {
  const _$ActiveTripIdleImpl();

  @override
  String toString() {
    return 'ActiveTripState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ActiveTripIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Trip trip) ready,
    required TResult Function(Trip trip) running,
    required TResult Function(Trip trip) paused,
    required TResult Function(Trip trip) completed,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Trip trip)? ready,
    TResult? Function(Trip trip)? running,
    TResult? Function(Trip trip)? paused,
    TResult? Function(Trip trip)? completed,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Trip trip)? ready,
    TResult Function(Trip trip)? running,
    TResult Function(Trip trip)? paused,
    TResult Function(Trip trip)? completed,
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
    required TResult Function(ActiveTripIdle value) idle,
    required TResult Function(ActiveTripReady value) ready,
    required TResult Function(ActiveTripRunning value) running,
    required TResult Function(ActiveTripPaused value) paused,
    required TResult Function(ActiveTripCompleted value) completed,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveTripIdle value)? idle,
    TResult? Function(ActiveTripReady value)? ready,
    TResult? Function(ActiveTripRunning value)? running,
    TResult? Function(ActiveTripPaused value)? paused,
    TResult? Function(ActiveTripCompleted value)? completed,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveTripIdle value)? idle,
    TResult Function(ActiveTripReady value)? ready,
    TResult Function(ActiveTripRunning value)? running,
    TResult Function(ActiveTripPaused value)? paused,
    TResult Function(ActiveTripCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class ActiveTripIdle implements ActiveTripState {
  const factory ActiveTripIdle() = _$ActiveTripIdleImpl;
}

/// @nodoc
abstract class _$$ActiveTripReadyImplCopyWith<$Res> {
  factory _$$ActiveTripReadyImplCopyWith(
    _$ActiveTripReadyImpl value,
    $Res Function(_$ActiveTripReadyImpl) then,
  ) = __$$ActiveTripReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Trip trip});

  $TripCopyWith<$Res> get trip;
}

/// @nodoc
class __$$ActiveTripReadyImplCopyWithImpl<$Res>
    extends _$ActiveTripStateCopyWithImpl<$Res, _$ActiveTripReadyImpl>
    implements _$$ActiveTripReadyImplCopyWith<$Res> {
  __$$ActiveTripReadyImplCopyWithImpl(
    _$ActiveTripReadyImpl _value,
    $Res Function(_$ActiveTripReadyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? trip = null}) {
    return _then(
      _$ActiveTripReadyImpl(
        trip: null == trip
            ? _value.trip
            : trip // ignore: cast_nullable_to_non_nullable
                  as Trip,
      ),
    );
  }

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripCopyWith<$Res> get trip {
    return $TripCopyWith<$Res>(_value.trip, (value) {
      return _then(_value.copyWith(trip: value));
    });
  }
}

/// @nodoc

class _$ActiveTripReadyImpl implements ActiveTripReady {
  const _$ActiveTripReadyImpl({required this.trip});

  @override
  final Trip trip;

  @override
  String toString() {
    return 'ActiveTripState.ready(trip: $trip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveTripReadyImpl &&
            (identical(other.trip, trip) || other.trip == trip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, trip);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveTripReadyImplCopyWith<_$ActiveTripReadyImpl> get copyWith =>
      __$$ActiveTripReadyImplCopyWithImpl<_$ActiveTripReadyImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Trip trip) ready,
    required TResult Function(Trip trip) running,
    required TResult Function(Trip trip) paused,
    required TResult Function(Trip trip) completed,
  }) {
    return ready(trip);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Trip trip)? ready,
    TResult? Function(Trip trip)? running,
    TResult? Function(Trip trip)? paused,
    TResult? Function(Trip trip)? completed,
  }) {
    return ready?.call(trip);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Trip trip)? ready,
    TResult Function(Trip trip)? running,
    TResult Function(Trip trip)? paused,
    TResult Function(Trip trip)? completed,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(trip);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveTripIdle value) idle,
    required TResult Function(ActiveTripReady value) ready,
    required TResult Function(ActiveTripRunning value) running,
    required TResult Function(ActiveTripPaused value) paused,
    required TResult Function(ActiveTripCompleted value) completed,
  }) {
    return ready(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveTripIdle value)? idle,
    TResult? Function(ActiveTripReady value)? ready,
    TResult? Function(ActiveTripRunning value)? running,
    TResult? Function(ActiveTripPaused value)? paused,
    TResult? Function(ActiveTripCompleted value)? completed,
  }) {
    return ready?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveTripIdle value)? idle,
    TResult Function(ActiveTripReady value)? ready,
    TResult Function(ActiveTripRunning value)? running,
    TResult Function(ActiveTripPaused value)? paused,
    TResult Function(ActiveTripCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(this);
    }
    return orElse();
  }
}

abstract class ActiveTripReady implements ActiveTripState {
  const factory ActiveTripReady({required final Trip trip}) =
      _$ActiveTripReadyImpl;

  Trip get trip;

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveTripReadyImplCopyWith<_$ActiveTripReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ActiveTripRunningImplCopyWith<$Res> {
  factory _$$ActiveTripRunningImplCopyWith(
    _$ActiveTripRunningImpl value,
    $Res Function(_$ActiveTripRunningImpl) then,
  ) = __$$ActiveTripRunningImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Trip trip});

  $TripCopyWith<$Res> get trip;
}

/// @nodoc
class __$$ActiveTripRunningImplCopyWithImpl<$Res>
    extends _$ActiveTripStateCopyWithImpl<$Res, _$ActiveTripRunningImpl>
    implements _$$ActiveTripRunningImplCopyWith<$Res> {
  __$$ActiveTripRunningImplCopyWithImpl(
    _$ActiveTripRunningImpl _value,
    $Res Function(_$ActiveTripRunningImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? trip = null}) {
    return _then(
      _$ActiveTripRunningImpl(
        trip: null == trip
            ? _value.trip
            : trip // ignore: cast_nullable_to_non_nullable
                  as Trip,
      ),
    );
  }

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripCopyWith<$Res> get trip {
    return $TripCopyWith<$Res>(_value.trip, (value) {
      return _then(_value.copyWith(trip: value));
    });
  }
}

/// @nodoc

class _$ActiveTripRunningImpl implements ActiveTripRunning {
  const _$ActiveTripRunningImpl({required this.trip});

  @override
  final Trip trip;

  @override
  String toString() {
    return 'ActiveTripState.running(trip: $trip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveTripRunningImpl &&
            (identical(other.trip, trip) || other.trip == trip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, trip);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveTripRunningImplCopyWith<_$ActiveTripRunningImpl> get copyWith =>
      __$$ActiveTripRunningImplCopyWithImpl<_$ActiveTripRunningImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Trip trip) ready,
    required TResult Function(Trip trip) running,
    required TResult Function(Trip trip) paused,
    required TResult Function(Trip trip) completed,
  }) {
    return running(trip);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Trip trip)? ready,
    TResult? Function(Trip trip)? running,
    TResult? Function(Trip trip)? paused,
    TResult? Function(Trip trip)? completed,
  }) {
    return running?.call(trip);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Trip trip)? ready,
    TResult Function(Trip trip)? running,
    TResult Function(Trip trip)? paused,
    TResult Function(Trip trip)? completed,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(trip);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveTripIdle value) idle,
    required TResult Function(ActiveTripReady value) ready,
    required TResult Function(ActiveTripRunning value) running,
    required TResult Function(ActiveTripPaused value) paused,
    required TResult Function(ActiveTripCompleted value) completed,
  }) {
    return running(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveTripIdle value)? idle,
    TResult? Function(ActiveTripReady value)? ready,
    TResult? Function(ActiveTripRunning value)? running,
    TResult? Function(ActiveTripPaused value)? paused,
    TResult? Function(ActiveTripCompleted value)? completed,
  }) {
    return running?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveTripIdle value)? idle,
    TResult Function(ActiveTripReady value)? ready,
    TResult Function(ActiveTripRunning value)? running,
    TResult Function(ActiveTripPaused value)? paused,
    TResult Function(ActiveTripCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(this);
    }
    return orElse();
  }
}

abstract class ActiveTripRunning implements ActiveTripState {
  const factory ActiveTripRunning({required final Trip trip}) =
      _$ActiveTripRunningImpl;

  Trip get trip;

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveTripRunningImplCopyWith<_$ActiveTripRunningImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ActiveTripPausedImplCopyWith<$Res> {
  factory _$$ActiveTripPausedImplCopyWith(
    _$ActiveTripPausedImpl value,
    $Res Function(_$ActiveTripPausedImpl) then,
  ) = __$$ActiveTripPausedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Trip trip});

  $TripCopyWith<$Res> get trip;
}

/// @nodoc
class __$$ActiveTripPausedImplCopyWithImpl<$Res>
    extends _$ActiveTripStateCopyWithImpl<$Res, _$ActiveTripPausedImpl>
    implements _$$ActiveTripPausedImplCopyWith<$Res> {
  __$$ActiveTripPausedImplCopyWithImpl(
    _$ActiveTripPausedImpl _value,
    $Res Function(_$ActiveTripPausedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? trip = null}) {
    return _then(
      _$ActiveTripPausedImpl(
        trip: null == trip
            ? _value.trip
            : trip // ignore: cast_nullable_to_non_nullable
                  as Trip,
      ),
    );
  }

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripCopyWith<$Res> get trip {
    return $TripCopyWith<$Res>(_value.trip, (value) {
      return _then(_value.copyWith(trip: value));
    });
  }
}

/// @nodoc

class _$ActiveTripPausedImpl implements ActiveTripPaused {
  const _$ActiveTripPausedImpl({required this.trip});

  @override
  final Trip trip;

  @override
  String toString() {
    return 'ActiveTripState.paused(trip: $trip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveTripPausedImpl &&
            (identical(other.trip, trip) || other.trip == trip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, trip);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveTripPausedImplCopyWith<_$ActiveTripPausedImpl> get copyWith =>
      __$$ActiveTripPausedImplCopyWithImpl<_$ActiveTripPausedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Trip trip) ready,
    required TResult Function(Trip trip) running,
    required TResult Function(Trip trip) paused,
    required TResult Function(Trip trip) completed,
  }) {
    return paused(trip);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Trip trip)? ready,
    TResult? Function(Trip trip)? running,
    TResult? Function(Trip trip)? paused,
    TResult? Function(Trip trip)? completed,
  }) {
    return paused?.call(trip);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Trip trip)? ready,
    TResult Function(Trip trip)? running,
    TResult Function(Trip trip)? paused,
    TResult Function(Trip trip)? completed,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(trip);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveTripIdle value) idle,
    required TResult Function(ActiveTripReady value) ready,
    required TResult Function(ActiveTripRunning value) running,
    required TResult Function(ActiveTripPaused value) paused,
    required TResult Function(ActiveTripCompleted value) completed,
  }) {
    return paused(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveTripIdle value)? idle,
    TResult? Function(ActiveTripReady value)? ready,
    TResult? Function(ActiveTripRunning value)? running,
    TResult? Function(ActiveTripPaused value)? paused,
    TResult? Function(ActiveTripCompleted value)? completed,
  }) {
    return paused?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveTripIdle value)? idle,
    TResult Function(ActiveTripReady value)? ready,
    TResult Function(ActiveTripRunning value)? running,
    TResult Function(ActiveTripPaused value)? paused,
    TResult Function(ActiveTripCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(this);
    }
    return orElse();
  }
}

abstract class ActiveTripPaused implements ActiveTripState {
  const factory ActiveTripPaused({required final Trip trip}) =
      _$ActiveTripPausedImpl;

  Trip get trip;

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveTripPausedImplCopyWith<_$ActiveTripPausedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ActiveTripCompletedImplCopyWith<$Res> {
  factory _$$ActiveTripCompletedImplCopyWith(
    _$ActiveTripCompletedImpl value,
    $Res Function(_$ActiveTripCompletedImpl) then,
  ) = __$$ActiveTripCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Trip trip});

  $TripCopyWith<$Res> get trip;
}

/// @nodoc
class __$$ActiveTripCompletedImplCopyWithImpl<$Res>
    extends _$ActiveTripStateCopyWithImpl<$Res, _$ActiveTripCompletedImpl>
    implements _$$ActiveTripCompletedImplCopyWith<$Res> {
  __$$ActiveTripCompletedImplCopyWithImpl(
    _$ActiveTripCompletedImpl _value,
    $Res Function(_$ActiveTripCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? trip = null}) {
    return _then(
      _$ActiveTripCompletedImpl(
        trip: null == trip
            ? _value.trip
            : trip // ignore: cast_nullable_to_non_nullable
                  as Trip,
      ),
    );
  }

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripCopyWith<$Res> get trip {
    return $TripCopyWith<$Res>(_value.trip, (value) {
      return _then(_value.copyWith(trip: value));
    });
  }
}

/// @nodoc

class _$ActiveTripCompletedImpl implements ActiveTripCompleted {
  const _$ActiveTripCompletedImpl({required this.trip});

  @override
  final Trip trip;

  @override
  String toString() {
    return 'ActiveTripState.completed(trip: $trip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveTripCompletedImpl &&
            (identical(other.trip, trip) || other.trip == trip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, trip);

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveTripCompletedImplCopyWith<_$ActiveTripCompletedImpl> get copyWith =>
      __$$ActiveTripCompletedImplCopyWithImpl<_$ActiveTripCompletedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Trip trip) ready,
    required TResult Function(Trip trip) running,
    required TResult Function(Trip trip) paused,
    required TResult Function(Trip trip) completed,
  }) {
    return completed(trip);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Trip trip)? ready,
    TResult? Function(Trip trip)? running,
    TResult? Function(Trip trip)? paused,
    TResult? Function(Trip trip)? completed,
  }) {
    return completed?.call(trip);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Trip trip)? ready,
    TResult Function(Trip trip)? running,
    TResult Function(Trip trip)? paused,
    TResult Function(Trip trip)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(trip);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveTripIdle value) idle,
    required TResult Function(ActiveTripReady value) ready,
    required TResult Function(ActiveTripRunning value) running,
    required TResult Function(ActiveTripPaused value) paused,
    required TResult Function(ActiveTripCompleted value) completed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveTripIdle value)? idle,
    TResult? Function(ActiveTripReady value)? ready,
    TResult? Function(ActiveTripRunning value)? running,
    TResult? Function(ActiveTripPaused value)? paused,
    TResult? Function(ActiveTripCompleted value)? completed,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveTripIdle value)? idle,
    TResult Function(ActiveTripReady value)? ready,
    TResult Function(ActiveTripRunning value)? running,
    TResult Function(ActiveTripPaused value)? paused,
    TResult Function(ActiveTripCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class ActiveTripCompleted implements ActiveTripState {
  const factory ActiveTripCompleted({required final Trip trip}) =
      _$ActiveTripCompletedImpl;

  Trip get trip;

  /// Create a copy of ActiveTripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveTripCompletedImplCopyWith<_$ActiveTripCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
