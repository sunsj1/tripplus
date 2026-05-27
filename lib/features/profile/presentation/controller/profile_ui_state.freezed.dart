// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProfileUiState {
  ProfileData get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProfileData data) idle,
    required TResult Function(ProfileData data) saving,
    required TResult Function(ProfileData data, Failure failure) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProfileData data)? idle,
    TResult? Function(ProfileData data)? saving,
    TResult? Function(ProfileData data, Failure failure)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProfileData data)? idle,
    TResult Function(ProfileData data)? saving,
    TResult Function(ProfileData data, Failure failure)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProfileIdle value) idle,
    required TResult Function(ProfileSaving value) saving,
    required TResult Function(ProfileErrored value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileIdle value)? idle,
    TResult? Function(ProfileSaving value)? saving,
    TResult? Function(ProfileErrored value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileIdle value)? idle,
    TResult Function(ProfileSaving value)? saving,
    TResult Function(ProfileErrored value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileUiStateCopyWith<ProfileUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileUiStateCopyWith<$Res> {
  factory $ProfileUiStateCopyWith(
    ProfileUiState value,
    $Res Function(ProfileUiState) then,
  ) = _$ProfileUiStateCopyWithImpl<$Res, ProfileUiState>;
  @useResult
  $Res call({ProfileData data});

  $ProfileDataCopyWith<$Res> get data;
}

/// @nodoc
class _$ProfileUiStateCopyWithImpl<$Res, $Val extends ProfileUiState>
    implements $ProfileUiStateCopyWith<$Res> {
  _$ProfileUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as ProfileData,
          )
          as $Val,
    );
  }

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileDataCopyWith<$Res> get data {
    return $ProfileDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileIdleImplCopyWith<$Res>
    implements $ProfileUiStateCopyWith<$Res> {
  factory _$$ProfileIdleImplCopyWith(
    _$ProfileIdleImpl value,
    $Res Function(_$ProfileIdleImpl) then,
  ) = __$$ProfileIdleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ProfileData data});

  @override
  $ProfileDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ProfileIdleImplCopyWithImpl<$Res>
    extends _$ProfileUiStateCopyWithImpl<$Res, _$ProfileIdleImpl>
    implements _$$ProfileIdleImplCopyWith<$Res> {
  __$$ProfileIdleImplCopyWithImpl(
    _$ProfileIdleImpl _value,
    $Res Function(_$ProfileIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$ProfileIdleImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as ProfileData,
      ),
    );
  }
}

/// @nodoc

class _$ProfileIdleImpl implements ProfileIdle {
  const _$ProfileIdleImpl(this.data);

  @override
  final ProfileData data;

  @override
  String toString() {
    return 'ProfileUiState.idle(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileIdleImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileIdleImplCopyWith<_$ProfileIdleImpl> get copyWith =>
      __$$ProfileIdleImplCopyWithImpl<_$ProfileIdleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProfileData data) idle,
    required TResult Function(ProfileData data) saving,
    required TResult Function(ProfileData data, Failure failure) error,
  }) {
    return idle(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProfileData data)? idle,
    TResult? Function(ProfileData data)? saving,
    TResult? Function(ProfileData data, Failure failure)? error,
  }) {
    return idle?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProfileData data)? idle,
    TResult Function(ProfileData data)? saving,
    TResult Function(ProfileData data, Failure failure)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProfileIdle value) idle,
    required TResult Function(ProfileSaving value) saving,
    required TResult Function(ProfileErrored value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileIdle value)? idle,
    TResult? Function(ProfileSaving value)? saving,
    TResult? Function(ProfileErrored value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileIdle value)? idle,
    TResult Function(ProfileSaving value)? saving,
    TResult Function(ProfileErrored value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class ProfileIdle implements ProfileUiState {
  const factory ProfileIdle(final ProfileData data) = _$ProfileIdleImpl;

  @override
  ProfileData get data;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileIdleImplCopyWith<_$ProfileIdleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProfileSavingImplCopyWith<$Res>
    implements $ProfileUiStateCopyWith<$Res> {
  factory _$$ProfileSavingImplCopyWith(
    _$ProfileSavingImpl value,
    $Res Function(_$ProfileSavingImpl) then,
  ) = __$$ProfileSavingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ProfileData data});

  @override
  $ProfileDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ProfileSavingImplCopyWithImpl<$Res>
    extends _$ProfileUiStateCopyWithImpl<$Res, _$ProfileSavingImpl>
    implements _$$ProfileSavingImplCopyWith<$Res> {
  __$$ProfileSavingImplCopyWithImpl(
    _$ProfileSavingImpl _value,
    $Res Function(_$ProfileSavingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$ProfileSavingImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as ProfileData,
      ),
    );
  }
}

/// @nodoc

class _$ProfileSavingImpl implements ProfileSaving {
  const _$ProfileSavingImpl(this.data);

  @override
  final ProfileData data;

  @override
  String toString() {
    return 'ProfileUiState.saving(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileSavingImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileSavingImplCopyWith<_$ProfileSavingImpl> get copyWith =>
      __$$ProfileSavingImplCopyWithImpl<_$ProfileSavingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProfileData data) idle,
    required TResult Function(ProfileData data) saving,
    required TResult Function(ProfileData data, Failure failure) error,
  }) {
    return saving(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProfileData data)? idle,
    TResult? Function(ProfileData data)? saving,
    TResult? Function(ProfileData data, Failure failure)? error,
  }) {
    return saving?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProfileData data)? idle,
    TResult Function(ProfileData data)? saving,
    TResult Function(ProfileData data, Failure failure)? error,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProfileIdle value) idle,
    required TResult Function(ProfileSaving value) saving,
    required TResult Function(ProfileErrored value) error,
  }) {
    return saving(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileIdle value)? idle,
    TResult? Function(ProfileSaving value)? saving,
    TResult? Function(ProfileErrored value)? error,
  }) {
    return saving?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileIdle value)? idle,
    TResult Function(ProfileSaving value)? saving,
    TResult Function(ProfileErrored value)? error,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving(this);
    }
    return orElse();
  }
}

abstract class ProfileSaving implements ProfileUiState {
  const factory ProfileSaving(final ProfileData data) = _$ProfileSavingImpl;

  @override
  ProfileData get data;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileSavingImplCopyWith<_$ProfileSavingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProfileErroredImplCopyWith<$Res>
    implements $ProfileUiStateCopyWith<$Res> {
  factory _$$ProfileErroredImplCopyWith(
    _$ProfileErroredImpl value,
    $Res Function(_$ProfileErroredImpl) then,
  ) = __$$ProfileErroredImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ProfileData data, Failure failure});

  @override
  $ProfileDataCopyWith<$Res> get data;
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$ProfileErroredImplCopyWithImpl<$Res>
    extends _$ProfileUiStateCopyWithImpl<$Res, _$ProfileErroredImpl>
    implements _$$ProfileErroredImplCopyWith<$Res> {
  __$$ProfileErroredImplCopyWithImpl(
    _$ProfileErroredImpl _value,
    $Res Function(_$ProfileErroredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null, Object? failure = null}) {
    return _then(
      _$ProfileErroredImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as ProfileData,
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$ProfileErroredImpl implements ProfileErrored {
  const _$ProfileErroredImpl(this.data, this.failure);

  @override
  final ProfileData data;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'ProfileUiState.error(data: $data, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileErroredImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data, failure);

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileErroredImplCopyWith<_$ProfileErroredImpl> get copyWith =>
      __$$ProfileErroredImplCopyWithImpl<_$ProfileErroredImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ProfileData data) idle,
    required TResult Function(ProfileData data) saving,
    required TResult Function(ProfileData data, Failure failure) error,
  }) {
    return error(data, failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ProfileData data)? idle,
    TResult? Function(ProfileData data)? saving,
    TResult? Function(ProfileData data, Failure failure)? error,
  }) {
    return error?.call(data, failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ProfileData data)? idle,
    TResult Function(ProfileData data)? saving,
    TResult Function(ProfileData data, Failure failure)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(data, failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProfileIdle value) idle,
    required TResult Function(ProfileSaving value) saving,
    required TResult Function(ProfileErrored value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProfileIdle value)? idle,
    TResult? Function(ProfileSaving value)? saving,
    TResult? Function(ProfileErrored value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProfileIdle value)? idle,
    TResult Function(ProfileSaving value)? saving,
    TResult Function(ProfileErrored value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ProfileErrored implements ProfileUiState {
  const factory ProfileErrored(final ProfileData data, final Failure failure) =
      _$ProfileErroredImpl;

  @override
  ProfileData get data;
  Failure get failure;

  /// Create a copy of ProfileUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileErroredImplCopyWith<_$ProfileErroredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
