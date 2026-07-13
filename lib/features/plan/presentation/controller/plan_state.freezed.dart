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
    required TResult Function(String from, String to, VehicleType? vehicleType)
    calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )
    result,
    required TResult Function(String from, String to, VehicleType? vehicleType)
    empty,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult? Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult Function(String from, String to, VehicleType? vehicleType)? empty,
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
    required TResult Function(String from, String to, VehicleType? vehicleType)
    calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )
    result,
    required TResult Function(String from, String to, VehicleType? vehicleType)
    empty,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult? Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult Function(String from, String to, VehicleType? vehicleType)? empty,
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
  $Res call({String from, String to, VehicleType? vehicleType});
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
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? vehicleType = freezed,
  }) {
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
        vehicleType: freezed == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as VehicleType?,
      ),
    );
  }
}

/// @nodoc

class _$PlanCalculatingImpl implements PlanCalculating {
  const _$PlanCalculatingImpl({
    required this.from,
    required this.to,
    this.vehicleType,
  });

  @override
  final String from;
  @override
  final String to;
  @override
  final VehicleType? vehicleType;

  @override
  String toString() {
    return 'PlanState.calculating(from: $from, to: $to, vehicleType: $vehicleType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanCalculatingImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to, vehicleType);

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
    required TResult Function(String from, String to, VehicleType? vehicleType)
    calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )
    result,
    required TResult Function(String from, String to, VehicleType? vehicleType)
    empty,
    required TResult Function(String message) error,
  }) {
    return calculating(from, to, vehicleType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult? Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult? Function(String message)? error,
  }) {
    return calculating?.call(from, to, vehicleType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (calculating != null) {
      return calculating(from, to, vehicleType);
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
    final VehicleType? vehicleType,
  }) = _$PlanCalculatingImpl;

  String get from;
  String get to;
  VehicleType? get vehicleType;

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
    VehicleType? vehicleType,
    UserPreferences? tripPreferences,
    double totalDistanceKm,
    int durationMinutes,
    List<ChargingGap> gaps,
    int? etaMinutes,
    bool? hasTolls,
    double? fuelEstimateCost,
    double? chargingEstimate,
    String? weatherTag,
    String? trafficLevel,
    String? encodedRoutePolyline,
    String? tollCorridorName,
    double? fuelEfficiencyKmpl,
    List<RouteOption> routeOptions,
    int selectedRouteIndex,
    bool isUpdatingRoute,
    Vehicle? vehicle,
    bool routeMatchedToGps,
  });

  $UserPreferencesCopyWith<$Res>? get tripPreferences;
  $VehicleCopyWith<$Res>? get vehicle;
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
    Object? vehicleType = freezed,
    Object? tripPreferences = freezed,
    Object? totalDistanceKm = null,
    Object? durationMinutes = null,
    Object? gaps = null,
    Object? etaMinutes = freezed,
    Object? hasTolls = freezed,
    Object? fuelEstimateCost = freezed,
    Object? chargingEstimate = freezed,
    Object? weatherTag = freezed,
    Object? trafficLevel = freezed,
    Object? encodedRoutePolyline = freezed,
    Object? tollCorridorName = freezed,
    Object? fuelEfficiencyKmpl = freezed,
    Object? routeOptions = null,
    Object? selectedRouteIndex = null,
    Object? isUpdatingRoute = null,
    Object? vehicle = freezed,
    Object? routeMatchedToGps = null,
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
        vehicleType: freezed == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as VehicleType?,
        tripPreferences: freezed == tripPreferences
            ? _value.tripPreferences
            : tripPreferences // ignore: cast_nullable_to_non_nullable
                  as UserPreferences?,
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
        etaMinutes: freezed == etaMinutes
            ? _value.etaMinutes
            : etaMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        hasTolls: freezed == hasTolls
            ? _value.hasTolls
            : hasTolls // ignore: cast_nullable_to_non_nullable
                  as bool?,
        fuelEstimateCost: freezed == fuelEstimateCost
            ? _value.fuelEstimateCost
            : fuelEstimateCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        chargingEstimate: freezed == chargingEstimate
            ? _value.chargingEstimate
            : chargingEstimate // ignore: cast_nullable_to_non_nullable
                  as double?,
        weatherTag: freezed == weatherTag
            ? _value.weatherTag
            : weatherTag // ignore: cast_nullable_to_non_nullable
                  as String?,
        trafficLevel: freezed == trafficLevel
            ? _value.trafficLevel
            : trafficLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        encodedRoutePolyline: freezed == encodedRoutePolyline
            ? _value.encodedRoutePolyline
            : encodedRoutePolyline // ignore: cast_nullable_to_non_nullable
                  as String?,
        tollCorridorName: freezed == tollCorridorName
            ? _value.tollCorridorName
            : tollCorridorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        fuelEfficiencyKmpl: freezed == fuelEfficiencyKmpl
            ? _value.fuelEfficiencyKmpl
            : fuelEfficiencyKmpl // ignore: cast_nullable_to_non_nullable
                  as double?,
        routeOptions: null == routeOptions
            ? _value._routeOptions
            : routeOptions // ignore: cast_nullable_to_non_nullable
                  as List<RouteOption>,
        selectedRouteIndex: null == selectedRouteIndex
            ? _value.selectedRouteIndex
            : selectedRouteIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        isUpdatingRoute: null == isUpdatingRoute
            ? _value.isUpdatingRoute
            : isUpdatingRoute // ignore: cast_nullable_to_non_nullable
                  as bool,
        vehicle: freezed == vehicle
            ? _value.vehicle
            : vehicle // ignore: cast_nullable_to_non_nullable
                  as Vehicle?,
        routeMatchedToGps: null == routeMatchedToGps
            ? _value.routeMatchedToGps
            : routeMatchedToGps // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesCopyWith<$Res>? get tripPreferences {
    if (_value.tripPreferences == null) {
      return null;
    }

    return $UserPreferencesCopyWith<$Res>(_value.tripPreferences!, (value) {
      return _then(_value.copyWith(tripPreferences: value));
    });
  }

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleCopyWith<$Res>? get vehicle {
    if (_value.vehicle == null) {
      return null;
    }

    return $VehicleCopyWith<$Res>(_value.vehicle!, (value) {
      return _then(_value.copyWith(vehicle: value));
    });
  }
}

/// @nodoc

class _$PlanResultImpl implements PlanResult {
  const _$PlanResultImpl({
    required this.from,
    required this.to,
    required final List<ChargingStation> stations,
    this.vehicleType,
    this.tripPreferences,
    required this.totalDistanceKm,
    required this.durationMinutes,
    final List<ChargingGap> gaps = const [],
    this.etaMinutes,
    this.hasTolls,
    this.fuelEstimateCost,
    this.chargingEstimate,
    this.weatherTag,
    this.trafficLevel,
    this.encodedRoutePolyline,
    this.tollCorridorName,
    this.fuelEfficiencyKmpl,
    final List<RouteOption> routeOptions = const <RouteOption>[],
    this.selectedRouteIndex = 0,
    this.isUpdatingRoute = false,
    this.vehicle,
    this.routeMatchedToGps = false,
  }) : _stations = stations,
       _gaps = gaps,
       _routeOptions = routeOptions;

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
  final VehicleType? vehicleType;
  @override
  final UserPreferences? tripPreferences;
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

  // P1-018: cost / time picture ------------------------------------------------
  /// Total journey time including estimated charging/fuel stops (minutes).
  @override
  final int? etaMinutes;

  /// Toll roads on route. Null for bikes; true/false for cars.
  @override
  final bool? hasTolls;

  /// Estimated fuel cost (₹) using vehicle.fuelEfficiencyKmpl. Null for EVs.
  @override
  final double? fuelEstimateCost;

  /// Estimated charging cost (₹) based on station count. Null for ICE vehicles.
  @override
  final double? chargingEstimate;

  /// Brief weather descriptor e.g. "Clear", "Rainy". Null until weather API wired.
  @override
  final String? weatherTag;

  /// Traffic descriptor derived from route duration: "Low" | "Moderate" | "High".
  @override
  final String? trafficLevel;

  /// Google-encoded route polyline for corridor cache + alert engine (P1-028).
  @override
  final String? encodedRoutePolyline;

  /// P2-042 — Matched toll corridor name when [hasTolls] is true.
  @override
  final String? tollCorridorName;

  /// km/l used for the fuel estimate (profile override or vehicle default).
  @override
  final double? fuelEfficiencyKmpl;

  /// Driving alternatives from Google (Batch 3).
  final List<RouteOption> _routeOptions;

  /// Driving alternatives from Google (Batch 3).
  @override
  @JsonKey()
  List<RouteOption> get routeOptions {
    if (_routeOptions is EqualUnmodifiableListView) return _routeOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routeOptions);
  }

  @override
  @JsonKey()
  final int selectedRouteIndex;
  @override
  @JsonKey()
  final bool isUpdatingRoute;

  /// Vehicle used for fuel estimates; preserved across route switches.
  @override
  final Vehicle? vehicle;

  /// True when [selectedRouteIndex] was chosen via GPS corridor match.
  @override
  @JsonKey()
  final bool routeMatchedToGps;

  @override
  String toString() {
    return 'PlanState.result(from: $from, to: $to, stations: $stations, vehicleType: $vehicleType, tripPreferences: $tripPreferences, totalDistanceKm: $totalDistanceKm, durationMinutes: $durationMinutes, gaps: $gaps, etaMinutes: $etaMinutes, hasTolls: $hasTolls, fuelEstimateCost: $fuelEstimateCost, chargingEstimate: $chargingEstimate, weatherTag: $weatherTag, trafficLevel: $trafficLevel, encodedRoutePolyline: $encodedRoutePolyline, tollCorridorName: $tollCorridorName, fuelEfficiencyKmpl: $fuelEfficiencyKmpl, routeOptions: $routeOptions, selectedRouteIndex: $selectedRouteIndex, isUpdatingRoute: $isUpdatingRoute, vehicle: $vehicle, routeMatchedToGps: $routeMatchedToGps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanResultImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            const DeepCollectionEquality().equals(other._stations, _stations) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.tripPreferences, tripPreferences) ||
                other.tripPreferences == tripPreferences) &&
            (identical(other.totalDistanceKm, totalDistanceKm) ||
                other.totalDistanceKm == totalDistanceKm) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            const DeepCollectionEquality().equals(other._gaps, _gaps) &&
            (identical(other.etaMinutes, etaMinutes) ||
                other.etaMinutes == etaMinutes) &&
            (identical(other.hasTolls, hasTolls) ||
                other.hasTolls == hasTolls) &&
            (identical(other.fuelEstimateCost, fuelEstimateCost) ||
                other.fuelEstimateCost == fuelEstimateCost) &&
            (identical(other.chargingEstimate, chargingEstimate) ||
                other.chargingEstimate == chargingEstimate) &&
            (identical(other.weatherTag, weatherTag) ||
                other.weatherTag == weatherTag) &&
            (identical(other.trafficLevel, trafficLevel) ||
                other.trafficLevel == trafficLevel) &&
            (identical(other.encodedRoutePolyline, encodedRoutePolyline) ||
                other.encodedRoutePolyline == encodedRoutePolyline) &&
            (identical(other.tollCorridorName, tollCorridorName) ||
                other.tollCorridorName == tollCorridorName) &&
            (identical(other.fuelEfficiencyKmpl, fuelEfficiencyKmpl) ||
                other.fuelEfficiencyKmpl == fuelEfficiencyKmpl) &&
            const DeepCollectionEquality().equals(
              other._routeOptions,
              _routeOptions,
            ) &&
            (identical(other.selectedRouteIndex, selectedRouteIndex) ||
                other.selectedRouteIndex == selectedRouteIndex) &&
            (identical(other.isUpdatingRoute, isUpdatingRoute) ||
                other.isUpdatingRoute == isUpdatingRoute) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            (identical(other.routeMatchedToGps, routeMatchedToGps) ||
                other.routeMatchedToGps == routeMatchedToGps));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    from,
    to,
    const DeepCollectionEquality().hash(_stations),
    vehicleType,
    tripPreferences,
    totalDistanceKm,
    durationMinutes,
    const DeepCollectionEquality().hash(_gaps),
    etaMinutes,
    hasTolls,
    fuelEstimateCost,
    chargingEstimate,
    weatherTag,
    trafficLevel,
    encodedRoutePolyline,
    tollCorridorName,
    fuelEfficiencyKmpl,
    const DeepCollectionEquality().hash(_routeOptions),
    selectedRouteIndex,
    isUpdatingRoute,
    vehicle,
    routeMatchedToGps,
  ]);

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
    required TResult Function(String from, String to, VehicleType? vehicleType)
    calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )
    result,
    required TResult Function(String from, String to, VehicleType? vehicleType)
    empty,
    required TResult Function(String message) error,
  }) {
    return result(
      from,
      to,
      stations,
      vehicleType,
      tripPreferences,
      totalDistanceKm,
      durationMinutes,
      gaps,
      etaMinutes,
      hasTolls,
      fuelEstimateCost,
      chargingEstimate,
      weatherTag,
      trafficLevel,
      encodedRoutePolyline,
      tollCorridorName,
      fuelEfficiencyKmpl,
      routeOptions,
      selectedRouteIndex,
      isUpdatingRoute,
      vehicle,
      routeMatchedToGps,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult? Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult? Function(String message)? error,
  }) {
    return result?.call(
      from,
      to,
      stations,
      vehicleType,
      tripPreferences,
      totalDistanceKm,
      durationMinutes,
      gaps,
      etaMinutes,
      hasTolls,
      fuelEstimateCost,
      chargingEstimate,
      weatherTag,
      trafficLevel,
      encodedRoutePolyline,
      tollCorridorName,
      fuelEfficiencyKmpl,
      routeOptions,
      selectedRouteIndex,
      isUpdatingRoute,
      vehicle,
      routeMatchedToGps,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(
        from,
        to,
        stations,
        vehicleType,
        tripPreferences,
        totalDistanceKm,
        durationMinutes,
        gaps,
        etaMinutes,
        hasTolls,
        fuelEstimateCost,
        chargingEstimate,
        weatherTag,
        trafficLevel,
        encodedRoutePolyline,
        tollCorridorName,
        fuelEfficiencyKmpl,
        routeOptions,
        selectedRouteIndex,
        isUpdatingRoute,
        vehicle,
        routeMatchedToGps,
      );
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
    final VehicleType? vehicleType,
    final UserPreferences? tripPreferences,
    required final double totalDistanceKm,
    required final int durationMinutes,
    final List<ChargingGap> gaps,
    final int? etaMinutes,
    final bool? hasTolls,
    final double? fuelEstimateCost,
    final double? chargingEstimate,
    final String? weatherTag,
    final String? trafficLevel,
    final String? encodedRoutePolyline,
    final String? tollCorridorName,
    final double? fuelEfficiencyKmpl,
    final List<RouteOption> routeOptions,
    final int selectedRouteIndex,
    final bool isUpdatingRoute,
    final Vehicle? vehicle,
    final bool routeMatchedToGps,
  }) = _$PlanResultImpl;

  String get from;
  String get to;
  List<ChargingStation> get stations;
  VehicleType? get vehicleType;
  UserPreferences? get tripPreferences;
  double get totalDistanceKm;
  int get durationMinutes;
  List<ChargingGap>
  get gaps; // P1-018: cost / time picture ------------------------------------------------
  /// Total journey time including estimated charging/fuel stops (minutes).
  int? get etaMinutes;

  /// Toll roads on route. Null for bikes; true/false for cars.
  bool? get hasTolls;

  /// Estimated fuel cost (₹) using vehicle.fuelEfficiencyKmpl. Null for EVs.
  double? get fuelEstimateCost;

  /// Estimated charging cost (₹) based on station count. Null for ICE vehicles.
  double? get chargingEstimate;

  /// Brief weather descriptor e.g. "Clear", "Rainy". Null until weather API wired.
  String? get weatherTag;

  /// Traffic descriptor derived from route duration: "Low" | "Moderate" | "High".
  String? get trafficLevel;

  /// Google-encoded route polyline for corridor cache + alert engine (P1-028).
  String? get encodedRoutePolyline;

  /// P2-042 — Matched toll corridor name when [hasTolls] is true.
  String? get tollCorridorName;

  /// km/l used for the fuel estimate (profile override or vehicle default).
  double? get fuelEfficiencyKmpl;

  /// Driving alternatives from Google (Batch 3).
  List<RouteOption> get routeOptions;
  int get selectedRouteIndex;
  bool get isUpdatingRoute;

  /// Vehicle used for fuel estimates; preserved across route switches.
  Vehicle? get vehicle;

  /// True when [selectedRouteIndex] was chosen via GPS corridor match.
  bool get routeMatchedToGps;

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
  $Res call({String from, String to, VehicleType? vehicleType});
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
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? vehicleType = freezed,
  }) {
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
        vehicleType: freezed == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as VehicleType?,
      ),
    );
  }
}

/// @nodoc

class _$PlanEmptyImpl implements PlanEmpty {
  const _$PlanEmptyImpl({
    required this.from,
    required this.to,
    this.vehicleType,
  });

  @override
  final String from;
  @override
  final String to;
  @override
  final VehicleType? vehicleType;

  @override
  String toString() {
    return 'PlanState.empty(from: $from, to: $to, vehicleType: $vehicleType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanEmptyImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to, vehicleType);

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
    required TResult Function(String from, String to, VehicleType? vehicleType)
    calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )
    result,
    required TResult Function(String from, String to, VehicleType? vehicleType)
    empty,
    required TResult Function(String message) error,
  }) {
    return empty(from, to, vehicleType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult? Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult? Function(String message)? error,
  }) {
    return empty?.call(from, to, vehicleType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(from, to, vehicleType);
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
    final VehicleType? vehicleType,
  }) = _$PlanEmptyImpl;

  String get from;
  String get to;
  VehicleType? get vehicleType;

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
    required TResult Function(String from, String to, VehicleType? vehicleType)
    calculating,
    required TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )
    result,
    required TResult Function(String from, String to, VehicleType? vehicleType)
    empty,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult? Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult? Function(String from, String to, VehicleType? vehicleType)? empty,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String from, String to, VehicleType? vehicleType)?
    calculating,
    TResult Function(
      String from,
      String to,
      List<ChargingStation> stations,
      VehicleType? vehicleType,
      UserPreferences? tripPreferences,
      double totalDistanceKm,
      int durationMinutes,
      List<ChargingGap> gaps,
      int? etaMinutes,
      bool? hasTolls,
      double? fuelEstimateCost,
      double? chargingEstimate,
      String? weatherTag,
      String? trafficLevel,
      String? encodedRoutePolyline,
      String? tollCorridorName,
      double? fuelEfficiencyKmpl,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      bool isUpdatingRoute,
      Vehicle? vehicle,
      bool routeMatchedToGps,
    )?
    result,
    TResult Function(String from, String to, VehicleType? vehicleType)? empty,
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
