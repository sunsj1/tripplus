// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  DistanceUnit get distanceUnit => throw _privateConstructorUsedError;

  /// Master switch — when false, no banners, no system notifications.
  bool get alertsEnabled => throw _privateConstructorUsedError;

  /// Per-type mute set (wire values from [AlertType]). Listed types are
  /// suppressed even when [alertsEnabled] is true.
  List<String> get mutedAlertTypes => throw _privateConstructorUsedError;

  /// Whether system notifications (in addition to in-app banners) fire.
  bool get systemNotificationsEnabled => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    DistanceUnit distanceUnit,
    bool alertsEnabled,
    List<String> mutedAlertTypes,
    bool systemNotificationsEnabled,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceUnit = null,
    Object? alertsEnabled = null,
    Object? mutedAlertTypes = null,
    Object? systemNotificationsEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            distanceUnit: null == distanceUnit
                ? _value.distanceUnit
                : distanceUnit // ignore: cast_nullable_to_non_nullable
                      as DistanceUnit,
            alertsEnabled: null == alertsEnabled
                ? _value.alertsEnabled
                : alertsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            mutedAlertTypes: null == mutedAlertTypes
                ? _value.mutedAlertTypes
                : mutedAlertTypes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            systemNotificationsEnabled: null == systemNotificationsEnabled
                ? _value.systemNotificationsEnabled
                : systemNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DistanceUnit distanceUnit,
    bool alertsEnabled,
    List<String> mutedAlertTypes,
    bool systemNotificationsEnabled,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceUnit = null,
    Object? alertsEnabled = null,
    Object? mutedAlertTypes = null,
    Object? systemNotificationsEnabled = null,
  }) {
    return _then(
      _$AppSettingsImpl(
        distanceUnit: null == distanceUnit
            ? _value.distanceUnit
            : distanceUnit // ignore: cast_nullable_to_non_nullable
                  as DistanceUnit,
        alertsEnabled: null == alertsEnabled
            ? _value.alertsEnabled
            : alertsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        mutedAlertTypes: null == mutedAlertTypes
            ? _value._mutedAlertTypes
            : mutedAlertTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        systemNotificationsEnabled: null == systemNotificationsEnabled
            ? _value.systemNotificationsEnabled
            : systemNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    this.distanceUnit = DistanceUnit.km,
    this.alertsEnabled = true,
    final List<String> mutedAlertTypes = const <String>[],
    this.systemNotificationsEnabled = true,
  }) : _mutedAlertTypes = mutedAlertTypes;

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  final DistanceUnit distanceUnit;

  /// Master switch — when false, no banners, no system notifications.
  @override
  @JsonKey()
  final bool alertsEnabled;

  /// Per-type mute set (wire values from [AlertType]). Listed types are
  /// suppressed even when [alertsEnabled] is true.
  final List<String> _mutedAlertTypes;

  /// Per-type mute set (wire values from [AlertType]). Listed types are
  /// suppressed even when [alertsEnabled] is true.
  @override
  @JsonKey()
  List<String> get mutedAlertTypes {
    if (_mutedAlertTypes is EqualUnmodifiableListView) return _mutedAlertTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mutedAlertTypes);
  }

  /// Whether system notifications (in addition to in-app banners) fire.
  @override
  @JsonKey()
  final bool systemNotificationsEnabled;

  @override
  String toString() {
    return 'AppSettings(distanceUnit: $distanceUnit, alertsEnabled: $alertsEnabled, mutedAlertTypes: $mutedAlertTypes, systemNotificationsEnabled: $systemNotificationsEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.distanceUnit, distanceUnit) ||
                other.distanceUnit == distanceUnit) &&
            (identical(other.alertsEnabled, alertsEnabled) ||
                other.alertsEnabled == alertsEnabled) &&
            const DeepCollectionEquality().equals(
              other._mutedAlertTypes,
              _mutedAlertTypes,
            ) &&
            (identical(
                  other.systemNotificationsEnabled,
                  systemNotificationsEnabled,
                ) ||
                other.systemNotificationsEnabled ==
                    systemNotificationsEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    distanceUnit,
    alertsEnabled,
    const DeepCollectionEquality().hash(_mutedAlertTypes),
    systemNotificationsEnabled,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    final DistanceUnit distanceUnit,
    final bool alertsEnabled,
    final List<String> mutedAlertTypes,
    final bool systemNotificationsEnabled,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  DistanceUnit get distanceUnit;

  /// Master switch — when false, no banners, no system notifications.
  @override
  bool get alertsEnabled;

  /// Per-type mute set (wire values from [AlertType]). Listed types are
  /// suppressed even when [alertsEnabled] is true.
  @override
  List<String> get mutedAlertTypes;

  /// Whether system notifications (in addition to in-app banners) fire.
  @override
  bool get systemNotificationsEnabled;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
