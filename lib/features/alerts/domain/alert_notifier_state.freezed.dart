// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_notifier_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AlertNotifierState {
  /// Latest alert surfaced in the in-app banner (if not dismissed).
  Alert? get activeBanner => throw _privateConstructorUsedError;
  bool get bannerDismissed => throw _privateConstructorUsedError;

  /// Create a copy of AlertNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertNotifierStateCopyWith<AlertNotifierState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertNotifierStateCopyWith<$Res> {
  factory $AlertNotifierStateCopyWith(
    AlertNotifierState value,
    $Res Function(AlertNotifierState) then,
  ) = _$AlertNotifierStateCopyWithImpl<$Res, AlertNotifierState>;
  @useResult
  $Res call({Alert? activeBanner, bool bannerDismissed});

  $AlertCopyWith<$Res>? get activeBanner;
}

/// @nodoc
class _$AlertNotifierStateCopyWithImpl<$Res, $Val extends AlertNotifierState>
    implements $AlertNotifierStateCopyWith<$Res> {
  _$AlertNotifierStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activeBanner = freezed, Object? bannerDismissed = null}) {
    return _then(
      _value.copyWith(
            activeBanner: freezed == activeBanner
                ? _value.activeBanner
                : activeBanner // ignore: cast_nullable_to_non_nullable
                      as Alert?,
            bannerDismissed: null == bannerDismissed
                ? _value.bannerDismissed
                : bannerDismissed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of AlertNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlertCopyWith<$Res>? get activeBanner {
    if (_value.activeBanner == null) {
      return null;
    }

    return $AlertCopyWith<$Res>(_value.activeBanner!, (value) {
      return _then(_value.copyWith(activeBanner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AlertNotifierStateImplCopyWith<$Res>
    implements $AlertNotifierStateCopyWith<$Res> {
  factory _$$AlertNotifierStateImplCopyWith(
    _$AlertNotifierStateImpl value,
    $Res Function(_$AlertNotifierStateImpl) then,
  ) = __$$AlertNotifierStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Alert? activeBanner, bool bannerDismissed});

  @override
  $AlertCopyWith<$Res>? get activeBanner;
}

/// @nodoc
class __$$AlertNotifierStateImplCopyWithImpl<$Res>
    extends _$AlertNotifierStateCopyWithImpl<$Res, _$AlertNotifierStateImpl>
    implements _$$AlertNotifierStateImplCopyWith<$Res> {
  __$$AlertNotifierStateImplCopyWithImpl(
    _$AlertNotifierStateImpl _value,
    $Res Function(_$AlertNotifierStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activeBanner = freezed, Object? bannerDismissed = null}) {
    return _then(
      _$AlertNotifierStateImpl(
        activeBanner: freezed == activeBanner
            ? _value.activeBanner
            : activeBanner // ignore: cast_nullable_to_non_nullable
                  as Alert?,
        bannerDismissed: null == bannerDismissed
            ? _value.bannerDismissed
            : bannerDismissed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AlertNotifierStateImpl implements _AlertNotifierState {
  const _$AlertNotifierStateImpl({
    this.activeBanner,
    this.bannerDismissed = false,
  });

  /// Latest alert surfaced in the in-app banner (if not dismissed).
  @override
  final Alert? activeBanner;
  @override
  @JsonKey()
  final bool bannerDismissed;

  @override
  String toString() {
    return 'AlertNotifierState(activeBanner: $activeBanner, bannerDismissed: $bannerDismissed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertNotifierStateImpl &&
            (identical(other.activeBanner, activeBanner) ||
                other.activeBanner == activeBanner) &&
            (identical(other.bannerDismissed, bannerDismissed) ||
                other.bannerDismissed == bannerDismissed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, activeBanner, bannerDismissed);

  /// Create a copy of AlertNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertNotifierStateImplCopyWith<_$AlertNotifierStateImpl> get copyWith =>
      __$$AlertNotifierStateImplCopyWithImpl<_$AlertNotifierStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AlertNotifierState implements AlertNotifierState {
  const factory _AlertNotifierState({
    final Alert? activeBanner,
    final bool bannerDismissed,
  }) = _$AlertNotifierStateImpl;

  /// Latest alert surfaced in the in-app banner (if not dismissed).
  @override
  Alert? get activeBanner;
  @override
  bool get bannerDismissed;

  /// Create a copy of AlertNotifierState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertNotifierStateImplCopyWith<_$AlertNotifierStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
