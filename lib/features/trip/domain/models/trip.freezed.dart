// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  /// Unique ID — UUID v4 generated at creation time.
  String get id => throw _privateConstructorUsedError;

  /// Human-readable origin label from the plan.
  String get from => throw _privateConstructorUsedError;

  /// Human-readable destination label from the plan.
  String get to => throw _privateConstructorUsedError;

  /// Vehicle used for this trip.
  Vehicle get vehicle => throw _privateConstructorUsedError;

  /// Lifecycle state.
  TripStatus get status =>
      throw _privateConstructorUsedError; // --- Plan estimates (from P1-018) -----------------------------------------
  /// Total planned distance (km).
  double get totalDistanceKm => throw _privateConstructorUsedError;

  /// Driving-only duration from Google Directions (minutes).
  int get drivingMinutes => throw _privateConstructorUsedError;

  /// Total ETA including stop time (minutes). Null only if estimator failed.
  int? get etaMinutes => throw _privateConstructorUsedError;

  /// Estimated toll cost (₹). Null for bikes.
  double? get tollsEstimate => throw _privateConstructorUsedError;

  /// Estimated fuel or charging cost (₹).
  double? get tripCostEstimate => throw _privateConstructorUsedError;

  /// Whether [tripCostEstimate] represents charging (true) or fuel (false).
  bool get isCostCharging => throw _privateConstructorUsedError;

  /// Number of charging / fuel stations on the route.
  int get stationCount =>
      throw _privateConstructorUsedError; // --- Timeline -------------------------------------------------------------
  /// When the trip record was created.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When the user tapped "Start trip".
  DateTime? get startedAt => throw _privateConstructorUsedError;

  /// When the user last tapped "Pause".
  DateTime? get pausedAt => throw _privateConstructorUsedError;

  /// When the user tapped "End trip".
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Cumulative milliseconds spent in paused state (for accurate elapsed).
  int get elapsedPausedMs => throw _privateConstructorUsedError;

  /// Predictive alerts fired during this trip (`P1-028` / `P1-034`).
  List<Alert> get firedAlerts => throw _privateConstructorUsedError;

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call({
    String id,
    String from,
    String to,
    Vehicle vehicle,
    TripStatus status,
    double totalDistanceKm,
    int drivingMinutes,
    int? etaMinutes,
    double? tollsEstimate,
    double? tripCostEstimate,
    bool isCostCharging,
    int stationCount,
    DateTime createdAt,
    DateTime? startedAt,
    DateTime? pausedAt,
    DateTime? completedAt,
    int elapsedPausedMs,
    List<Alert> firedAlerts,
  });

  $VehicleCopyWith<$Res> get vehicle;
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? from = null,
    Object? to = null,
    Object? vehicle = null,
    Object? status = null,
    Object? totalDistanceKm = null,
    Object? drivingMinutes = null,
    Object? etaMinutes = freezed,
    Object? tollsEstimate = freezed,
    Object? tripCostEstimate = freezed,
    Object? isCostCharging = null,
    Object? stationCount = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? pausedAt = freezed,
    Object? completedAt = freezed,
    Object? elapsedPausedMs = null,
    Object? firedAlerts = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicle: null == vehicle
                ? _value.vehicle
                : vehicle // ignore: cast_nullable_to_non_nullable
                      as Vehicle,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TripStatus,
            totalDistanceKm: null == totalDistanceKm
                ? _value.totalDistanceKm
                : totalDistanceKm // ignore: cast_nullable_to_non_nullable
                      as double,
            drivingMinutes: null == drivingMinutes
                ? _value.drivingMinutes
                : drivingMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            etaMinutes: freezed == etaMinutes
                ? _value.etaMinutes
                : etaMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            tollsEstimate: freezed == tollsEstimate
                ? _value.tollsEstimate
                : tollsEstimate // ignore: cast_nullable_to_non_nullable
                      as double?,
            tripCostEstimate: freezed == tripCostEstimate
                ? _value.tripCostEstimate
                : tripCostEstimate // ignore: cast_nullable_to_non_nullable
                      as double?,
            isCostCharging: null == isCostCharging
                ? _value.isCostCharging
                : isCostCharging // ignore: cast_nullable_to_non_nullable
                      as bool,
            stationCount: null == stationCount
                ? _value.stationCount
                : stationCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            pausedAt: freezed == pausedAt
                ? _value.pausedAt
                : pausedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            elapsedPausedMs: null == elapsedPausedMs
                ? _value.elapsedPausedMs
                : elapsedPausedMs // ignore: cast_nullable_to_non_nullable
                      as int,
            firedAlerts: null == firedAlerts
                ? _value.firedAlerts
                : firedAlerts // ignore: cast_nullable_to_non_nullable
                      as List<Alert>,
          )
          as $Val,
    );
  }

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleCopyWith<$Res> get vehicle {
    return $VehicleCopyWith<$Res>(_value.vehicle, (value) {
      return _then(_value.copyWith(vehicle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
    _$TripImpl value,
    $Res Function(_$TripImpl) then,
  ) = __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String from,
    String to,
    Vehicle vehicle,
    TripStatus status,
    double totalDistanceKm,
    int drivingMinutes,
    int? etaMinutes,
    double? tollsEstimate,
    double? tripCostEstimate,
    bool isCostCharging,
    int stationCount,
    DateTime createdAt,
    DateTime? startedAt,
    DateTime? pausedAt,
    DateTime? completedAt,
    int elapsedPausedMs,
    List<Alert> firedAlerts,
  });

  @override
  $VehicleCopyWith<$Res> get vehicle;
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
    : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? from = null,
    Object? to = null,
    Object? vehicle = null,
    Object? status = null,
    Object? totalDistanceKm = null,
    Object? drivingMinutes = null,
    Object? etaMinutes = freezed,
    Object? tollsEstimate = freezed,
    Object? tripCostEstimate = freezed,
    Object? isCostCharging = null,
    Object? stationCount = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? pausedAt = freezed,
    Object? completedAt = freezed,
    Object? elapsedPausedMs = null,
    Object? firedAlerts = null,
  }) {
    return _then(
      _$TripImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicle: null == vehicle
            ? _value.vehicle
            : vehicle // ignore: cast_nullable_to_non_nullable
                  as Vehicle,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TripStatus,
        totalDistanceKm: null == totalDistanceKm
            ? _value.totalDistanceKm
            : totalDistanceKm // ignore: cast_nullable_to_non_nullable
                  as double,
        drivingMinutes: null == drivingMinutes
            ? _value.drivingMinutes
            : drivingMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        etaMinutes: freezed == etaMinutes
            ? _value.etaMinutes
            : etaMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        tollsEstimate: freezed == tollsEstimate
            ? _value.tollsEstimate
            : tollsEstimate // ignore: cast_nullable_to_non_nullable
                  as double?,
        tripCostEstimate: freezed == tripCostEstimate
            ? _value.tripCostEstimate
            : tripCostEstimate // ignore: cast_nullable_to_non_nullable
                  as double?,
        isCostCharging: null == isCostCharging
            ? _value.isCostCharging
            : isCostCharging // ignore: cast_nullable_to_non_nullable
                  as bool,
        stationCount: null == stationCount
            ? _value.stationCount
            : stationCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pausedAt: freezed == pausedAt
            ? _value.pausedAt
            : pausedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        elapsedPausedMs: null == elapsedPausedMs
            ? _value.elapsedPausedMs
            : elapsedPausedMs // ignore: cast_nullable_to_non_nullable
                  as int,
        firedAlerts: null == firedAlerts
            ? _value._firedAlerts
            : firedAlerts // ignore: cast_nullable_to_non_nullable
                  as List<Alert>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripImpl extends _Trip {
  const _$TripImpl({
    required this.id,
    required this.from,
    required this.to,
    required this.vehicle,
    this.status = TripStatus.notStarted,
    required this.totalDistanceKm,
    required this.drivingMinutes,
    this.etaMinutes,
    this.tollsEstimate,
    this.tripCostEstimate,
    this.isCostCharging = false,
    this.stationCount = 0,
    required this.createdAt,
    this.startedAt,
    this.pausedAt,
    this.completedAt,
    this.elapsedPausedMs = 0,
    final List<Alert> firedAlerts = const <Alert>[],
  }) : _firedAlerts = firedAlerts,
       super._();

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  /// Unique ID — UUID v4 generated at creation time.
  @override
  final String id;

  /// Human-readable origin label from the plan.
  @override
  final String from;

  /// Human-readable destination label from the plan.
  @override
  final String to;

  /// Vehicle used for this trip.
  @override
  final Vehicle vehicle;

  /// Lifecycle state.
  @override
  @JsonKey()
  final TripStatus status;
  // --- Plan estimates (from P1-018) -----------------------------------------
  /// Total planned distance (km).
  @override
  final double totalDistanceKm;

  /// Driving-only duration from Google Directions (minutes).
  @override
  final int drivingMinutes;

  /// Total ETA including stop time (minutes). Null only if estimator failed.
  @override
  final int? etaMinutes;

  /// Estimated toll cost (₹). Null for bikes.
  @override
  final double? tollsEstimate;

  /// Estimated fuel or charging cost (₹).
  @override
  final double? tripCostEstimate;

  /// Whether [tripCostEstimate] represents charging (true) or fuel (false).
  @override
  @JsonKey()
  final bool isCostCharging;

  /// Number of charging / fuel stations on the route.
  @override
  @JsonKey()
  final int stationCount;
  // --- Timeline -------------------------------------------------------------
  /// When the trip record was created.
  @override
  final DateTime createdAt;

  /// When the user tapped "Start trip".
  @override
  final DateTime? startedAt;

  /// When the user last tapped "Pause".
  @override
  final DateTime? pausedAt;

  /// When the user tapped "End trip".
  @override
  final DateTime? completedAt;

  /// Cumulative milliseconds spent in paused state (for accurate elapsed).
  @override
  @JsonKey()
  final int elapsedPausedMs;

  /// Predictive alerts fired during this trip (`P1-028` / `P1-034`).
  final List<Alert> _firedAlerts;

  /// Predictive alerts fired during this trip (`P1-028` / `P1-034`).
  @override
  @JsonKey()
  List<Alert> get firedAlerts {
    if (_firedAlerts is EqualUnmodifiableListView) return _firedAlerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_firedAlerts);
  }

  @override
  String toString() {
    return 'Trip(id: $id, from: $from, to: $to, vehicle: $vehicle, status: $status, totalDistanceKm: $totalDistanceKm, drivingMinutes: $drivingMinutes, etaMinutes: $etaMinutes, tollsEstimate: $tollsEstimate, tripCostEstimate: $tripCostEstimate, isCostCharging: $isCostCharging, stationCount: $stationCount, createdAt: $createdAt, startedAt: $startedAt, pausedAt: $pausedAt, completedAt: $completedAt, elapsedPausedMs: $elapsedPausedMs, firedAlerts: $firedAlerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalDistanceKm, totalDistanceKm) ||
                other.totalDistanceKm == totalDistanceKm) &&
            (identical(other.drivingMinutes, drivingMinutes) ||
                other.drivingMinutes == drivingMinutes) &&
            (identical(other.etaMinutes, etaMinutes) ||
                other.etaMinutes == etaMinutes) &&
            (identical(other.tollsEstimate, tollsEstimate) ||
                other.tollsEstimate == tollsEstimate) &&
            (identical(other.tripCostEstimate, tripCostEstimate) ||
                other.tripCostEstimate == tripCostEstimate) &&
            (identical(other.isCostCharging, isCostCharging) ||
                other.isCostCharging == isCostCharging) &&
            (identical(other.stationCount, stationCount) ||
                other.stationCount == stationCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.pausedAt, pausedAt) ||
                other.pausedAt == pausedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.elapsedPausedMs, elapsedPausedMs) ||
                other.elapsedPausedMs == elapsedPausedMs) &&
            const DeepCollectionEquality().equals(
              other._firedAlerts,
              _firedAlerts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    from,
    to,
    vehicle,
    status,
    totalDistanceKm,
    drivingMinutes,
    etaMinutes,
    tollsEstimate,
    tripCostEstimate,
    isCostCharging,
    stationCount,
    createdAt,
    startedAt,
    pausedAt,
    completedAt,
    elapsedPausedMs,
    const DeepCollectionEquality().hash(_firedAlerts),
  );

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(this);
  }
}

abstract class _Trip extends Trip {
  const factory _Trip({
    required final String id,
    required final String from,
    required final String to,
    required final Vehicle vehicle,
    final TripStatus status,
    required final double totalDistanceKm,
    required final int drivingMinutes,
    final int? etaMinutes,
    final double? tollsEstimate,
    final double? tripCostEstimate,
    final bool isCostCharging,
    final int stationCount,
    required final DateTime createdAt,
    final DateTime? startedAt,
    final DateTime? pausedAt,
    final DateTime? completedAt,
    final int elapsedPausedMs,
    final List<Alert> firedAlerts,
  }) = _$TripImpl;
  const _Trip._() : super._();

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  /// Unique ID — UUID v4 generated at creation time.
  @override
  String get id;

  /// Human-readable origin label from the plan.
  @override
  String get from;

  /// Human-readable destination label from the plan.
  @override
  String get to;

  /// Vehicle used for this trip.
  @override
  Vehicle get vehicle;

  /// Lifecycle state.
  @override
  TripStatus get status; // --- Plan estimates (from P1-018) -----------------------------------------
  /// Total planned distance (km).
  @override
  double get totalDistanceKm;

  /// Driving-only duration from Google Directions (minutes).
  @override
  int get drivingMinutes;

  /// Total ETA including stop time (minutes). Null only if estimator failed.
  @override
  int? get etaMinutes;

  /// Estimated toll cost (₹). Null for bikes.
  @override
  double? get tollsEstimate;

  /// Estimated fuel or charging cost (₹).
  @override
  double? get tripCostEstimate;

  /// Whether [tripCostEstimate] represents charging (true) or fuel (false).
  @override
  bool get isCostCharging;

  /// Number of charging / fuel stations on the route.
  @override
  int get stationCount; // --- Timeline -------------------------------------------------------------
  /// When the trip record was created.
  @override
  DateTime get createdAt;

  /// When the user tapped "Start trip".
  @override
  DateTime? get startedAt;

  /// When the user last tapped "Pause".
  @override
  DateTime? get pausedAt;

  /// When the user tapped "End trip".
  @override
  DateTime? get completedAt;

  /// Cumulative milliseconds spent in paused state (for accurate elapsed).
  @override
  int get elapsedPausedMs;

  /// Predictive alerts fired during this trip (`P1-028` / `P1-034`).
  @override
  List<Alert> get firedAlerts;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
