// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message) permission,
    required TResult Function(String message) index,
    required TResult Function(String message) firestore,
    required TResult Function(String message) platform,
    required TResult Function(String message) quota,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? index,
    TResult? Function(String message)? firestore,
    TResult? Function(String message)? platform,
    TResult? Function(String message)? quota,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message)? permission,
    TResult Function(String message)? index,
    TResult Function(String message)? firestore,
    TResult Function(String message)? platform,
    TResult Function(String message)? quota,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(IndexFailure value) index,
    required TResult Function(FirestoreFailure value) firestore,
    required TResult Function(PlatformFailure value) platform,
    required TResult Function(QuotaFailure value) quota,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(IndexFailure value)? index,
    TResult? Function(FirestoreFailure value)? firestore,
    TResult? Function(PlatformFailure value)? platform,
    TResult? Function(QuotaFailure value)? quota,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(IndexFailure value)? index,
    TResult Function(FirestoreFailure value)? firestore,
    TResult Function(PlatformFailure value)? platform,
    TResult Function(QuotaFailure value)? quota,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$NetworkFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl extends NetworkFailure {
  const _$NetworkFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.network(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message) permission,
    required TResult Function(String message) index,
    required TResult Function(String message) firestore,
    required TResult Function(String message) platform,
    required TResult Function(String message) quota,
  }) {
    return network(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? index,
    TResult? Function(String message)? firestore,
    TResult? Function(String message)? platform,
    TResult? Function(String message)? quota,
  }) {
    return network?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message)? permission,
    TResult Function(String message)? index,
    TResult Function(String message)? firestore,
    TResult Function(String message)? platform,
    TResult Function(String message)? quota,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(IndexFailure value) index,
    required TResult Function(FirestoreFailure value) firestore,
    required TResult Function(PlatformFailure value) platform,
    required TResult Function(QuotaFailure value) quota,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(IndexFailure value)? index,
    TResult? Function(FirestoreFailure value)? firestore,
    TResult? Function(PlatformFailure value)? platform,
    TResult? Function(QuotaFailure value)? quota,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(IndexFailure value)? index,
    TResult Function(FirestoreFailure value)? firestore,
    TResult Function(PlatformFailure value)? platform,
    TResult Function(QuotaFailure value)? quota,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure extends Failure {
  const factory NetworkFailure(final String message) = _$NetworkFailureImpl;
  const NetworkFailure._() : super._();

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PermissionFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$PermissionFailureImplCopyWith(
    _$PermissionFailureImpl value,
    $Res Function(_$PermissionFailureImpl) then,
  ) = __$$PermissionFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PermissionFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$PermissionFailureImpl>
    implements _$$PermissionFailureImplCopyWith<$Res> {
  __$$PermissionFailureImplCopyWithImpl(
    _$PermissionFailureImpl _value,
    $Res Function(_$PermissionFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$PermissionFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PermissionFailureImpl extends PermissionFailure {
  const _$PermissionFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.permission(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      __$$PermissionFailureImplCopyWithImpl<_$PermissionFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message) permission,
    required TResult Function(String message) index,
    required TResult Function(String message) firestore,
    required TResult Function(String message) platform,
    required TResult Function(String message) quota,
  }) {
    return permission(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? index,
    TResult? Function(String message)? firestore,
    TResult? Function(String message)? platform,
    TResult? Function(String message)? quota,
  }) {
    return permission?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message)? permission,
    TResult Function(String message)? index,
    TResult Function(String message)? firestore,
    TResult Function(String message)? platform,
    TResult Function(String message)? quota,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(IndexFailure value) index,
    required TResult Function(FirestoreFailure value) firestore,
    required TResult Function(PlatformFailure value) platform,
    required TResult Function(QuotaFailure value) quota,
  }) {
    return permission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(IndexFailure value)? index,
    TResult? Function(FirestoreFailure value)? firestore,
    TResult? Function(PlatformFailure value)? platform,
    TResult? Function(QuotaFailure value)? quota,
  }) {
    return permission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(IndexFailure value)? index,
    TResult Function(FirestoreFailure value)? firestore,
    TResult Function(PlatformFailure value)? platform,
    TResult Function(QuotaFailure value)? quota,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this);
    }
    return orElse();
  }
}

abstract class PermissionFailure extends Failure {
  const factory PermissionFailure(final String message) =
      _$PermissionFailureImpl;
  const PermissionFailure._() : super._();

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IndexFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$IndexFailureImplCopyWith(
    _$IndexFailureImpl value,
    $Res Function(_$IndexFailureImpl) then,
  ) = __$$IndexFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$IndexFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$IndexFailureImpl>
    implements _$$IndexFailureImplCopyWith<$Res> {
  __$$IndexFailureImplCopyWithImpl(
    _$IndexFailureImpl _value,
    $Res Function(_$IndexFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$IndexFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$IndexFailureImpl extends IndexFailure {
  const _$IndexFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.index(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndexFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndexFailureImplCopyWith<_$IndexFailureImpl> get copyWith =>
      __$$IndexFailureImplCopyWithImpl<_$IndexFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message) permission,
    required TResult Function(String message) index,
    required TResult Function(String message) firestore,
    required TResult Function(String message) platform,
    required TResult Function(String message) quota,
  }) {
    return index(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? index,
    TResult? Function(String message)? firestore,
    TResult? Function(String message)? platform,
    TResult? Function(String message)? quota,
  }) {
    return index?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message)? permission,
    TResult Function(String message)? index,
    TResult Function(String message)? firestore,
    TResult Function(String message)? platform,
    TResult Function(String message)? quota,
    required TResult orElse(),
  }) {
    if (index != null) {
      return index(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(IndexFailure value) index,
    required TResult Function(FirestoreFailure value) firestore,
    required TResult Function(PlatformFailure value) platform,
    required TResult Function(QuotaFailure value) quota,
  }) {
    return index(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(IndexFailure value)? index,
    TResult? Function(FirestoreFailure value)? firestore,
    TResult? Function(PlatformFailure value)? platform,
    TResult? Function(QuotaFailure value)? quota,
  }) {
    return index?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(IndexFailure value)? index,
    TResult Function(FirestoreFailure value)? firestore,
    TResult Function(PlatformFailure value)? platform,
    TResult Function(QuotaFailure value)? quota,
    required TResult orElse(),
  }) {
    if (index != null) {
      return index(this);
    }
    return orElse();
  }
}

abstract class IndexFailure extends Failure {
  const factory IndexFailure(final String message) = _$IndexFailureImpl;
  const IndexFailure._() : super._();

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndexFailureImplCopyWith<_$IndexFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FirestoreFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$FirestoreFailureImplCopyWith(
    _$FirestoreFailureImpl value,
    $Res Function(_$FirestoreFailureImpl) then,
  ) = __$$FirestoreFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FirestoreFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$FirestoreFailureImpl>
    implements _$$FirestoreFailureImplCopyWith<$Res> {
  __$$FirestoreFailureImplCopyWithImpl(
    _$FirestoreFailureImpl _value,
    $Res Function(_$FirestoreFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FirestoreFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FirestoreFailureImpl extends FirestoreFailure {
  const _$FirestoreFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.firestore(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FirestoreFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FirestoreFailureImplCopyWith<_$FirestoreFailureImpl> get copyWith =>
      __$$FirestoreFailureImplCopyWithImpl<_$FirestoreFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message) permission,
    required TResult Function(String message) index,
    required TResult Function(String message) firestore,
    required TResult Function(String message) platform,
    required TResult Function(String message) quota,
  }) {
    return firestore(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? index,
    TResult? Function(String message)? firestore,
    TResult? Function(String message)? platform,
    TResult? Function(String message)? quota,
  }) {
    return firestore?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message)? permission,
    TResult Function(String message)? index,
    TResult Function(String message)? firestore,
    TResult Function(String message)? platform,
    TResult Function(String message)? quota,
    required TResult orElse(),
  }) {
    if (firestore != null) {
      return firestore(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(IndexFailure value) index,
    required TResult Function(FirestoreFailure value) firestore,
    required TResult Function(PlatformFailure value) platform,
    required TResult Function(QuotaFailure value) quota,
  }) {
    return firestore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(IndexFailure value)? index,
    TResult? Function(FirestoreFailure value)? firestore,
    TResult? Function(PlatformFailure value)? platform,
    TResult? Function(QuotaFailure value)? quota,
  }) {
    return firestore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(IndexFailure value)? index,
    TResult Function(FirestoreFailure value)? firestore,
    TResult Function(PlatformFailure value)? platform,
    TResult Function(QuotaFailure value)? quota,
    required TResult orElse(),
  }) {
    if (firestore != null) {
      return firestore(this);
    }
    return orElse();
  }
}

abstract class FirestoreFailure extends Failure {
  const factory FirestoreFailure(final String message) = _$FirestoreFailureImpl;
  const FirestoreFailure._() : super._();

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FirestoreFailureImplCopyWith<_$FirestoreFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlatformFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$PlatformFailureImplCopyWith(
    _$PlatformFailureImpl value,
    $Res Function(_$PlatformFailureImpl) then,
  ) = __$$PlatformFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PlatformFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$PlatformFailureImpl>
    implements _$$PlatformFailureImplCopyWith<$Res> {
  __$$PlatformFailureImplCopyWithImpl(
    _$PlatformFailureImpl _value,
    $Res Function(_$PlatformFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$PlatformFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PlatformFailureImpl extends PlatformFailure {
  const _$PlatformFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.platform(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformFailureImplCopyWith<_$PlatformFailureImpl> get copyWith =>
      __$$PlatformFailureImplCopyWithImpl<_$PlatformFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message) permission,
    required TResult Function(String message) index,
    required TResult Function(String message) firestore,
    required TResult Function(String message) platform,
    required TResult Function(String message) quota,
  }) {
    return platform(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? index,
    TResult? Function(String message)? firestore,
    TResult? Function(String message)? platform,
    TResult? Function(String message)? quota,
  }) {
    return platform?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message)? permission,
    TResult Function(String message)? index,
    TResult Function(String message)? firestore,
    TResult Function(String message)? platform,
    TResult Function(String message)? quota,
    required TResult orElse(),
  }) {
    if (platform != null) {
      return platform(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(IndexFailure value) index,
    required TResult Function(FirestoreFailure value) firestore,
    required TResult Function(PlatformFailure value) platform,
    required TResult Function(QuotaFailure value) quota,
  }) {
    return platform(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(IndexFailure value)? index,
    TResult? Function(FirestoreFailure value)? firestore,
    TResult? Function(PlatformFailure value)? platform,
    TResult? Function(QuotaFailure value)? quota,
  }) {
    return platform?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(IndexFailure value)? index,
    TResult Function(FirestoreFailure value)? firestore,
    TResult Function(PlatformFailure value)? platform,
    TResult Function(QuotaFailure value)? quota,
    required TResult orElse(),
  }) {
    if (platform != null) {
      return platform(this);
    }
    return orElse();
  }
}

abstract class PlatformFailure extends Failure {
  const factory PlatformFailure(final String message) = _$PlatformFailureImpl;
  const PlatformFailure._() : super._();

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformFailureImplCopyWith<_$PlatformFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuotaFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$QuotaFailureImplCopyWith(
    _$QuotaFailureImpl value,
    $Res Function(_$QuotaFailureImpl) then,
  ) = __$$QuotaFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$QuotaFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$QuotaFailureImpl>
    implements _$$QuotaFailureImplCopyWith<$Res> {
  __$$QuotaFailureImplCopyWithImpl(
    _$QuotaFailureImpl _value,
    $Res Function(_$QuotaFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$QuotaFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$QuotaFailureImpl extends QuotaFailure {
  const _$QuotaFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.quota(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaFailureImplCopyWith<_$QuotaFailureImpl> get copyWith =>
      __$$QuotaFailureImplCopyWithImpl<_$QuotaFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(String message) permission,
    required TResult Function(String message) index,
    required TResult Function(String message) firestore,
    required TResult Function(String message) platform,
    required TResult Function(String message) quota,
  }) {
    return quota(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? index,
    TResult? Function(String message)? firestore,
    TResult? Function(String message)? platform,
    TResult? Function(String message)? quota,
  }) {
    return quota?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(String message)? permission,
    TResult Function(String message)? index,
    TResult Function(String message)? firestore,
    TResult Function(String message)? platform,
    TResult Function(String message)? quota,
    required TResult orElse(),
  }) {
    if (quota != null) {
      return quota(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(IndexFailure value) index,
    required TResult Function(FirestoreFailure value) firestore,
    required TResult Function(PlatformFailure value) platform,
    required TResult Function(QuotaFailure value) quota,
  }) {
    return quota(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(IndexFailure value)? index,
    TResult? Function(FirestoreFailure value)? firestore,
    TResult? Function(PlatformFailure value)? platform,
    TResult? Function(QuotaFailure value)? quota,
  }) {
    return quota?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(IndexFailure value)? index,
    TResult Function(FirestoreFailure value)? firestore,
    TResult Function(PlatformFailure value)? platform,
    TResult Function(QuotaFailure value)? quota,
    required TResult orElse(),
  }) {
    if (quota != null) {
      return quota(this);
    }
    return orElse();
  }
}

abstract class QuotaFailure extends Failure {
  const factory QuotaFailure(final String message) = _$QuotaFailureImpl;
  const QuotaFailure._() : super._();

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuotaFailureImplCopyWith<_$QuotaFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
