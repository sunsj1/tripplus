// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_community_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StationCommunityUiState {
  bool get loading => throw _privateConstructorUsedError;
  bool get submitting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<StationCommunityReport> get reports =>
      throw _privateConstructorUsedError;

  /// Create a copy of StationCommunityUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StationCommunityUiStateCopyWith<StationCommunityUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StationCommunityUiStateCopyWith<$Res> {
  factory $StationCommunityUiStateCopyWith(
    StationCommunityUiState value,
    $Res Function(StationCommunityUiState) then,
  ) = _$StationCommunityUiStateCopyWithImpl<$Res, StationCommunityUiState>;
  @useResult
  $Res call({
    bool loading,
    bool submitting,
    String? errorMessage,
    List<StationCommunityReport> reports,
  });
}

/// @nodoc
class _$StationCommunityUiStateCopyWithImpl<
  $Res,
  $Val extends StationCommunityUiState
>
    implements $StationCommunityUiStateCopyWith<$Res> {
  _$StationCommunityUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StationCommunityUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? submitting = null,
    Object? errorMessage = freezed,
    Object? reports = null,
  }) {
    return _then(
      _value.copyWith(
            loading: null == loading
                ? _value.loading
                : loading // ignore: cast_nullable_to_non_nullable
                      as bool,
            submitting: null == submitting
                ? _value.submitting
                : submitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            reports: null == reports
                ? _value.reports
                : reports // ignore: cast_nullable_to_non_nullable
                      as List<StationCommunityReport>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StationCommunityUiStateImplCopyWith<$Res>
    implements $StationCommunityUiStateCopyWith<$Res> {
  factory _$$StationCommunityUiStateImplCopyWith(
    _$StationCommunityUiStateImpl value,
    $Res Function(_$StationCommunityUiStateImpl) then,
  ) = __$$StationCommunityUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool loading,
    bool submitting,
    String? errorMessage,
    List<StationCommunityReport> reports,
  });
}

/// @nodoc
class __$$StationCommunityUiStateImplCopyWithImpl<$Res>
    extends
        _$StationCommunityUiStateCopyWithImpl<
          $Res,
          _$StationCommunityUiStateImpl
        >
    implements _$$StationCommunityUiStateImplCopyWith<$Res> {
  __$$StationCommunityUiStateImplCopyWithImpl(
    _$StationCommunityUiStateImpl _value,
    $Res Function(_$StationCommunityUiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StationCommunityUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? submitting = null,
    Object? errorMessage = freezed,
    Object? reports = null,
  }) {
    return _then(
      _$StationCommunityUiStateImpl(
        loading: null == loading
            ? _value.loading
            : loading // ignore: cast_nullable_to_non_nullable
                  as bool,
        submitting: null == submitting
            ? _value.submitting
            : submitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        reports: null == reports
            ? _value._reports
            : reports // ignore: cast_nullable_to_non_nullable
                  as List<StationCommunityReport>,
      ),
    );
  }
}

/// @nodoc

class _$StationCommunityUiStateImpl implements _StationCommunityUiState {
  const _$StationCommunityUiStateImpl({
    this.loading = true,
    this.submitting = false,
    this.errorMessage,
    final List<StationCommunityReport> reports =
        const <StationCommunityReport>[],
  }) : _reports = reports;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool submitting;
  @override
  final String? errorMessage;
  final List<StationCommunityReport> _reports;
  @override
  @JsonKey()
  List<StationCommunityReport> get reports {
    if (_reports is EqualUnmodifiableListView) return _reports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reports);
  }

  @override
  String toString() {
    return 'StationCommunityUiState(loading: $loading, submitting: $submitting, errorMessage: $errorMessage, reports: $reports)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationCommunityUiStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.submitting, submitting) ||
                other.submitting == submitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._reports, _reports));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    loading,
    submitting,
    errorMessage,
    const DeepCollectionEquality().hash(_reports),
  );

  /// Create a copy of StationCommunityUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationCommunityUiStateImplCopyWith<_$StationCommunityUiStateImpl>
  get copyWith =>
      __$$StationCommunityUiStateImplCopyWithImpl<
        _$StationCommunityUiStateImpl
      >(this, _$identity);
}

abstract class _StationCommunityUiState implements StationCommunityUiState {
  const factory _StationCommunityUiState({
    final bool loading,
    final bool submitting,
    final String? errorMessage,
    final List<StationCommunityReport> reports,
  }) = _$StationCommunityUiStateImpl;

  @override
  bool get loading;
  @override
  bool get submitting;
  @override
  String? get errorMessage;
  @override
  List<StationCommunityReport> get reports;

  /// Create a copy of StationCommunityUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationCommunityUiStateImplCopyWith<_$StationCommunityUiStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
