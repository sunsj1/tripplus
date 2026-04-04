// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charging_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChargingState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ChargingStation> stations) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ChargingStation> stations)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ChargingStation> stations)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChargingInitial value) initial,
    required TResult Function(ChargingLoading value) loading,
    required TResult Function(ChargingLoaded value) loaded,
    required TResult Function(ChargingError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChargingInitial value)? initial,
    TResult? Function(ChargingLoading value)? loading,
    TResult? Function(ChargingLoaded value)? loaded,
    TResult? Function(ChargingError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChargingInitial value)? initial,
    TResult Function(ChargingLoading value)? loading,
    TResult Function(ChargingLoaded value)? loaded,
    TResult Function(ChargingError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargingStateCopyWith<$Res> {
  factory $ChargingStateCopyWith(
    ChargingState value,
    $Res Function(ChargingState) then,
  ) = _$ChargingStateCopyWithImpl<$Res, ChargingState>;
}

/// @nodoc
class _$ChargingStateCopyWithImpl<$Res, $Val extends ChargingState>
    implements $ChargingStateCopyWith<$Res> {
  _$ChargingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ChargingInitialImplCopyWith<$Res> {
  factory _$$ChargingInitialImplCopyWith(
    _$ChargingInitialImpl value,
    $Res Function(_$ChargingInitialImpl) then,
  ) = __$$ChargingInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChargingInitialImplCopyWithImpl<$Res>
    extends _$ChargingStateCopyWithImpl<$Res, _$ChargingInitialImpl>
    implements _$$ChargingInitialImplCopyWith<$Res> {
  __$$ChargingInitialImplCopyWithImpl(
    _$ChargingInitialImpl _value,
    $Res Function(_$ChargingInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChargingInitialImpl implements ChargingInitial {
  const _$ChargingInitialImpl();

  @override
  String toString() {
    return 'ChargingState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChargingInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ChargingStation> stations) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ChargingStation> stations)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ChargingStation> stations)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChargingInitial value) initial,
    required TResult Function(ChargingLoading value) loading,
    required TResult Function(ChargingLoaded value) loaded,
    required TResult Function(ChargingError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChargingInitial value)? initial,
    TResult? Function(ChargingLoading value)? loading,
    TResult? Function(ChargingLoaded value)? loaded,
    TResult? Function(ChargingError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChargingInitial value)? initial,
    TResult Function(ChargingLoading value)? loading,
    TResult Function(ChargingLoaded value)? loaded,
    TResult Function(ChargingError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ChargingInitial implements ChargingState {
  const factory ChargingInitial() = _$ChargingInitialImpl;
}

/// @nodoc
abstract class _$$ChargingLoadingImplCopyWith<$Res> {
  factory _$$ChargingLoadingImplCopyWith(
    _$ChargingLoadingImpl value,
    $Res Function(_$ChargingLoadingImpl) then,
  ) = __$$ChargingLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChargingLoadingImplCopyWithImpl<$Res>
    extends _$ChargingStateCopyWithImpl<$Res, _$ChargingLoadingImpl>
    implements _$$ChargingLoadingImplCopyWith<$Res> {
  __$$ChargingLoadingImplCopyWithImpl(
    _$ChargingLoadingImpl _value,
    $Res Function(_$ChargingLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChargingLoadingImpl implements ChargingLoading {
  const _$ChargingLoadingImpl();

  @override
  String toString() {
    return 'ChargingState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChargingLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ChargingStation> stations) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ChargingStation> stations)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ChargingStation> stations)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChargingInitial value) initial,
    required TResult Function(ChargingLoading value) loading,
    required TResult Function(ChargingLoaded value) loaded,
    required TResult Function(ChargingError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChargingInitial value)? initial,
    TResult? Function(ChargingLoading value)? loading,
    TResult? Function(ChargingLoaded value)? loaded,
    TResult? Function(ChargingError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChargingInitial value)? initial,
    TResult Function(ChargingLoading value)? loading,
    TResult Function(ChargingLoaded value)? loaded,
    TResult Function(ChargingError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ChargingLoading implements ChargingState {
  const factory ChargingLoading() = _$ChargingLoadingImpl;
}

/// @nodoc
abstract class _$$ChargingLoadedImplCopyWith<$Res> {
  factory _$$ChargingLoadedImplCopyWith(
    _$ChargingLoadedImpl value,
    $Res Function(_$ChargingLoadedImpl) then,
  ) = __$$ChargingLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ChargingStation> stations});
}

/// @nodoc
class __$$ChargingLoadedImplCopyWithImpl<$Res>
    extends _$ChargingStateCopyWithImpl<$Res, _$ChargingLoadedImpl>
    implements _$$ChargingLoadedImplCopyWith<$Res> {
  __$$ChargingLoadedImplCopyWithImpl(
    _$ChargingLoadedImpl _value,
    $Res Function(_$ChargingLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? stations = null}) {
    return _then(
      _$ChargingLoadedImpl(
        null == stations
            ? _value._stations
            : stations // ignore: cast_nullable_to_non_nullable
                  as List<ChargingStation>,
      ),
    );
  }
}

/// @nodoc

class _$ChargingLoadedImpl implements ChargingLoaded {
  const _$ChargingLoadedImpl(final List<ChargingStation> stations)
    : _stations = stations;

  final List<ChargingStation> _stations;
  @override
  List<ChargingStation> get stations {
    if (_stations is EqualUnmodifiableListView) return _stations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stations);
  }

  @override
  String toString() {
    return 'ChargingState.loaded(stations: $stations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargingLoadedImpl &&
            const DeepCollectionEquality().equals(other._stations, _stations));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_stations));

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargingLoadedImplCopyWith<_$ChargingLoadedImpl> get copyWith =>
      __$$ChargingLoadedImplCopyWithImpl<_$ChargingLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ChargingStation> stations) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(stations);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ChargingStation> stations)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(stations);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ChargingStation> stations)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(stations);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChargingInitial value) initial,
    required TResult Function(ChargingLoading value) loading,
    required TResult Function(ChargingLoaded value) loaded,
    required TResult Function(ChargingError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChargingInitial value)? initial,
    TResult? Function(ChargingLoading value)? loading,
    TResult? Function(ChargingLoaded value)? loaded,
    TResult? Function(ChargingError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChargingInitial value)? initial,
    TResult Function(ChargingLoading value)? loading,
    TResult Function(ChargingLoaded value)? loaded,
    TResult Function(ChargingError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ChargingLoaded implements ChargingState {
  const factory ChargingLoaded(final List<ChargingStation> stations) =
      _$ChargingLoadedImpl;

  List<ChargingStation> get stations;

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargingLoadedImplCopyWith<_$ChargingLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChargingErrorImplCopyWith<$Res> {
  factory _$$ChargingErrorImplCopyWith(
    _$ChargingErrorImpl value,
    $Res Function(_$ChargingErrorImpl) then,
  ) = __$$ChargingErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ChargingErrorImplCopyWithImpl<$Res>
    extends _$ChargingStateCopyWithImpl<$Res, _$ChargingErrorImpl>
    implements _$$ChargingErrorImplCopyWith<$Res> {
  __$$ChargingErrorImplCopyWithImpl(
    _$ChargingErrorImpl _value,
    $Res Function(_$ChargingErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ChargingErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChargingErrorImpl implements ChargingError {
  const _$ChargingErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ChargingState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargingErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargingErrorImplCopyWith<_$ChargingErrorImpl> get copyWith =>
      __$$ChargingErrorImplCopyWithImpl<_$ChargingErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ChargingStation> stations) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ChargingStation> stations)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ChargingStation> stations)? loaded,
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
    required TResult Function(ChargingInitial value) initial,
    required TResult Function(ChargingLoading value) loading,
    required TResult Function(ChargingLoaded value) loaded,
    required TResult Function(ChargingError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChargingInitial value)? initial,
    TResult? Function(ChargingLoading value)? loading,
    TResult? Function(ChargingLoaded value)? loaded,
    TResult? Function(ChargingError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChargingInitial value)? initial,
    TResult Function(ChargingLoading value)? loading,
    TResult Function(ChargingLoaded value)? loaded,
    TResult Function(ChargingError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ChargingError implements ChargingState {
  const factory ChargingError(final String message) = _$ChargingErrorImpl;

  String get message;

  /// Create a copy of ChargingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargingErrorImplCopyWith<_$ChargingErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
