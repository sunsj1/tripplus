// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poi_category_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PoiCategoryUiState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Poi> pois, PoiQuerySource source) data,
    required TResult Function(String reason) empty,
    required TResult Function(Failure failure) errored,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult? Function(String reason)? empty,
    TResult? Function(Failure failure)? errored,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult Function(String reason)? empty,
    TResult Function(Failure failure)? errored,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoiCategoryLoading value) loading,
    required TResult Function(PoiCategoryData value) data,
    required TResult Function(PoiCategoryEmpty value) empty,
    required TResult Function(PoiCategoryErrored value) errored,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoiCategoryLoading value)? loading,
    TResult? Function(PoiCategoryData value)? data,
    TResult? Function(PoiCategoryEmpty value)? empty,
    TResult? Function(PoiCategoryErrored value)? errored,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoiCategoryLoading value)? loading,
    TResult Function(PoiCategoryData value)? data,
    TResult Function(PoiCategoryEmpty value)? empty,
    TResult Function(PoiCategoryErrored value)? errored,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoiCategoryUiStateCopyWith<$Res> {
  factory $PoiCategoryUiStateCopyWith(
    PoiCategoryUiState value,
    $Res Function(PoiCategoryUiState) then,
  ) = _$PoiCategoryUiStateCopyWithImpl<$Res, PoiCategoryUiState>;
}

/// @nodoc
class _$PoiCategoryUiStateCopyWithImpl<$Res, $Val extends PoiCategoryUiState>
    implements $PoiCategoryUiStateCopyWith<$Res> {
  _$PoiCategoryUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PoiCategoryLoadingImplCopyWith<$Res> {
  factory _$$PoiCategoryLoadingImplCopyWith(
    _$PoiCategoryLoadingImpl value,
    $Res Function(_$PoiCategoryLoadingImpl) then,
  ) = __$$PoiCategoryLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoiCategoryLoadingImplCopyWithImpl<$Res>
    extends _$PoiCategoryUiStateCopyWithImpl<$Res, _$PoiCategoryLoadingImpl>
    implements _$$PoiCategoryLoadingImplCopyWith<$Res> {
  __$$PoiCategoryLoadingImplCopyWithImpl(
    _$PoiCategoryLoadingImpl _value,
    $Res Function(_$PoiCategoryLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoiCategoryLoadingImpl implements PoiCategoryLoading {
  const _$PoiCategoryLoadingImpl();

  @override
  String toString() {
    return 'PoiCategoryUiState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoiCategoryLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Poi> pois, PoiQuerySource source) data,
    required TResult Function(String reason) empty,
    required TResult Function(Failure failure) errored,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult? Function(String reason)? empty,
    TResult? Function(Failure failure)? errored,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult Function(String reason)? empty,
    TResult Function(Failure failure)? errored,
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
    required TResult Function(PoiCategoryLoading value) loading,
    required TResult Function(PoiCategoryData value) data,
    required TResult Function(PoiCategoryEmpty value) empty,
    required TResult Function(PoiCategoryErrored value) errored,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoiCategoryLoading value)? loading,
    TResult? Function(PoiCategoryData value)? data,
    TResult? Function(PoiCategoryEmpty value)? empty,
    TResult? Function(PoiCategoryErrored value)? errored,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoiCategoryLoading value)? loading,
    TResult Function(PoiCategoryData value)? data,
    TResult Function(PoiCategoryEmpty value)? empty,
    TResult Function(PoiCategoryErrored value)? errored,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PoiCategoryLoading implements PoiCategoryUiState {
  const factory PoiCategoryLoading() = _$PoiCategoryLoadingImpl;
}

/// @nodoc
abstract class _$$PoiCategoryDataImplCopyWith<$Res> {
  factory _$$PoiCategoryDataImplCopyWith(
    _$PoiCategoryDataImpl value,
    $Res Function(_$PoiCategoryDataImpl) then,
  ) = __$$PoiCategoryDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Poi> pois, PoiQuerySource source});
}

/// @nodoc
class __$$PoiCategoryDataImplCopyWithImpl<$Res>
    extends _$PoiCategoryUiStateCopyWithImpl<$Res, _$PoiCategoryDataImpl>
    implements _$$PoiCategoryDataImplCopyWith<$Res> {
  __$$PoiCategoryDataImplCopyWithImpl(
    _$PoiCategoryDataImpl _value,
    $Res Function(_$PoiCategoryDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pois = null, Object? source = null}) {
    return _then(
      _$PoiCategoryDataImpl(
        pois: null == pois
            ? _value._pois
            : pois // ignore: cast_nullable_to_non_nullable
                  as List<Poi>,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as PoiQuerySource,
      ),
    );
  }
}

/// @nodoc

class _$PoiCategoryDataImpl implements PoiCategoryData {
  const _$PoiCategoryDataImpl({
    required final List<Poi> pois,
    required this.source,
  }) : _pois = pois;

  final List<Poi> _pois;
  @override
  List<Poi> get pois {
    if (_pois is EqualUnmodifiableListView) return _pois;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pois);
  }

  @override
  final PoiQuerySource source;

  @override
  String toString() {
    return 'PoiCategoryUiState.data(pois: $pois, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoiCategoryDataImpl &&
            const DeepCollectionEquality().equals(other._pois, _pois) &&
            (identical(other.source, source) || other.source == source));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_pois),
    source,
  );

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoiCategoryDataImplCopyWith<_$PoiCategoryDataImpl> get copyWith =>
      __$$PoiCategoryDataImplCopyWithImpl<_$PoiCategoryDataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Poi> pois, PoiQuerySource source) data,
    required TResult Function(String reason) empty,
    required TResult Function(Failure failure) errored,
  }) {
    return data(pois, source);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult? Function(String reason)? empty,
    TResult? Function(Failure failure)? errored,
  }) {
    return data?.call(pois, source);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult Function(String reason)? empty,
    TResult Function(Failure failure)? errored,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(pois, source);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoiCategoryLoading value) loading,
    required TResult Function(PoiCategoryData value) data,
    required TResult Function(PoiCategoryEmpty value) empty,
    required TResult Function(PoiCategoryErrored value) errored,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoiCategoryLoading value)? loading,
    TResult? Function(PoiCategoryData value)? data,
    TResult? Function(PoiCategoryEmpty value)? empty,
    TResult? Function(PoiCategoryErrored value)? errored,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoiCategoryLoading value)? loading,
    TResult Function(PoiCategoryData value)? data,
    TResult Function(PoiCategoryEmpty value)? empty,
    TResult Function(PoiCategoryErrored value)? errored,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class PoiCategoryData implements PoiCategoryUiState {
  const factory PoiCategoryData({
    required final List<Poi> pois,
    required final PoiQuerySource source,
  }) = _$PoiCategoryDataImpl;

  List<Poi> get pois;
  PoiQuerySource get source;

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoiCategoryDataImplCopyWith<_$PoiCategoryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoiCategoryEmptyImplCopyWith<$Res> {
  factory _$$PoiCategoryEmptyImplCopyWith(
    _$PoiCategoryEmptyImpl value,
    $Res Function(_$PoiCategoryEmptyImpl) then,
  ) = __$$PoiCategoryEmptyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$PoiCategoryEmptyImplCopyWithImpl<$Res>
    extends _$PoiCategoryUiStateCopyWithImpl<$Res, _$PoiCategoryEmptyImpl>
    implements _$$PoiCategoryEmptyImplCopyWith<$Res> {
  __$$PoiCategoryEmptyImplCopyWithImpl(
    _$PoiCategoryEmptyImpl _value,
    $Res Function(_$PoiCategoryEmptyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$PoiCategoryEmptyImpl(
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PoiCategoryEmptyImpl implements PoiCategoryEmpty {
  const _$PoiCategoryEmptyImpl({required this.reason});

  @override
  final String reason;

  @override
  String toString() {
    return 'PoiCategoryUiState.empty(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoiCategoryEmptyImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoiCategoryEmptyImplCopyWith<_$PoiCategoryEmptyImpl> get copyWith =>
      __$$PoiCategoryEmptyImplCopyWithImpl<_$PoiCategoryEmptyImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Poi> pois, PoiQuerySource source) data,
    required TResult Function(String reason) empty,
    required TResult Function(Failure failure) errored,
  }) {
    return empty(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult? Function(String reason)? empty,
    TResult? Function(Failure failure)? errored,
  }) {
    return empty?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult Function(String reason)? empty,
    TResult Function(Failure failure)? errored,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoiCategoryLoading value) loading,
    required TResult Function(PoiCategoryData value) data,
    required TResult Function(PoiCategoryEmpty value) empty,
    required TResult Function(PoiCategoryErrored value) errored,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoiCategoryLoading value)? loading,
    TResult? Function(PoiCategoryData value)? data,
    TResult? Function(PoiCategoryEmpty value)? empty,
    TResult? Function(PoiCategoryErrored value)? errored,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoiCategoryLoading value)? loading,
    TResult Function(PoiCategoryData value)? data,
    TResult Function(PoiCategoryEmpty value)? empty,
    TResult Function(PoiCategoryErrored value)? errored,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class PoiCategoryEmpty implements PoiCategoryUiState {
  const factory PoiCategoryEmpty({required final String reason}) =
      _$PoiCategoryEmptyImpl;

  String get reason;

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoiCategoryEmptyImplCopyWith<_$PoiCategoryEmptyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoiCategoryErroredImplCopyWith<$Res> {
  factory _$$PoiCategoryErroredImplCopyWith(
    _$PoiCategoryErroredImpl value,
    $Res Function(_$PoiCategoryErroredImpl) then,
  ) = __$$PoiCategoryErroredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$PoiCategoryErroredImplCopyWithImpl<$Res>
    extends _$PoiCategoryUiStateCopyWithImpl<$Res, _$PoiCategoryErroredImpl>
    implements _$$PoiCategoryErroredImplCopyWith<$Res> {
  __$$PoiCategoryErroredImplCopyWithImpl(
    _$PoiCategoryErroredImpl _value,
    $Res Function(_$PoiCategoryErroredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$PoiCategoryErroredImpl(
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of PoiCategoryUiState
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

class _$PoiCategoryErroredImpl implements PoiCategoryErrored {
  const _$PoiCategoryErroredImpl(this.failure);

  @override
  final Failure failure;

  @override
  String toString() {
    return 'PoiCategoryUiState.errored(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoiCategoryErroredImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoiCategoryErroredImplCopyWith<_$PoiCategoryErroredImpl> get copyWith =>
      __$$PoiCategoryErroredImplCopyWithImpl<_$PoiCategoryErroredImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Poi> pois, PoiQuerySource source) data,
    required TResult Function(String reason) empty,
    required TResult Function(Failure failure) errored,
  }) {
    return errored(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult? Function(String reason)? empty,
    TResult? Function(Failure failure)? errored,
  }) {
    return errored?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Poi> pois, PoiQuerySource source)? data,
    TResult Function(String reason)? empty,
    TResult Function(Failure failure)? errored,
    required TResult orElse(),
  }) {
    if (errored != null) {
      return errored(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoiCategoryLoading value) loading,
    required TResult Function(PoiCategoryData value) data,
    required TResult Function(PoiCategoryEmpty value) empty,
    required TResult Function(PoiCategoryErrored value) errored,
  }) {
    return errored(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoiCategoryLoading value)? loading,
    TResult? Function(PoiCategoryData value)? data,
    TResult? Function(PoiCategoryEmpty value)? empty,
    TResult? Function(PoiCategoryErrored value)? errored,
  }) {
    return errored?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoiCategoryLoading value)? loading,
    TResult Function(PoiCategoryData value)? data,
    TResult Function(PoiCategoryEmpty value)? empty,
    TResult Function(PoiCategoryErrored value)? errored,
    required TResult orElse(),
  }) {
    if (errored != null) {
      return errored(this);
    }
    return orElse();
  }
}

abstract class PoiCategoryErrored implements PoiCategoryUiState {
  const factory PoiCategoryErrored(final Failure failure) =
      _$PoiCategoryErroredImpl;

  Failure get failure;

  /// Create a copy of PoiCategoryUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoiCategoryErroredImplCopyWith<_$PoiCategoryErroredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
