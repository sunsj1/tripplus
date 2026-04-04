// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insights_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$InsightsData {
  // Route overview
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  double get routeDistanceKm => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  int get totalStations =>
      throw _privateConstructorUsedError; // Route health (0-100)
  int get healthScore => throw _privateConstructorUsedError;
  String get healthLabel => throw _privateConstructorUsedError; // Metrics
  double get avgSpacingKm => throw _privateConstructorUsedError;
  int get chargingStopsNeeded => throw _privateConstructorUsedError;
  double get estimatedChargingCostRupees => throw _privateConstructorUsedError;
  int get estimatedChargingMinutes =>
      throw _privateConstructorUsedError; // Station quality
  int get fastChargerCount => throw _privateConstructorUsedError;
  int get verifiedCount => throw _privateConstructorUsedError;
  double get avgPowerKw => throw _privateConstructorUsedError;
  int get fastChargerPercent =>
      throw _privateConstructorUsedError; // Gap analysis
  double get maxGapKm => throw _privateConstructorUsedError;
  List<ChargingGap> get gaps =>
      throw _privateConstructorUsedError; // Top stations for quick reference
  List<ChargingStation> get topStations => throw _privateConstructorUsedError;

  /// Create a copy of InsightsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightsDataCopyWith<InsightsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsDataCopyWith<$Res> {
  factory $InsightsDataCopyWith(
    InsightsData value,
    $Res Function(InsightsData) then,
  ) = _$InsightsDataCopyWithImpl<$Res, InsightsData>;
  @useResult
  $Res call({
    String from,
    String to,
    double routeDistanceKm,
    int durationMinutes,
    int totalStations,
    int healthScore,
    String healthLabel,
    double avgSpacingKm,
    int chargingStopsNeeded,
    double estimatedChargingCostRupees,
    int estimatedChargingMinutes,
    int fastChargerCount,
    int verifiedCount,
    double avgPowerKw,
    int fastChargerPercent,
    double maxGapKm,
    List<ChargingGap> gaps,
    List<ChargingStation> topStations,
  });
}

/// @nodoc
class _$InsightsDataCopyWithImpl<$Res, $Val extends InsightsData>
    implements $InsightsDataCopyWith<$Res> {
  _$InsightsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? routeDistanceKm = null,
    Object? durationMinutes = null,
    Object? totalStations = null,
    Object? healthScore = null,
    Object? healthLabel = null,
    Object? avgSpacingKm = null,
    Object? chargingStopsNeeded = null,
    Object? estimatedChargingCostRupees = null,
    Object? estimatedChargingMinutes = null,
    Object? fastChargerCount = null,
    Object? verifiedCount = null,
    Object? avgPowerKw = null,
    Object? fastChargerPercent = null,
    Object? maxGapKm = null,
    Object? gaps = null,
    Object? topStations = null,
  }) {
    return _then(
      _value.copyWith(
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String,
            routeDistanceKm: null == routeDistanceKm
                ? _value.routeDistanceKm
                : routeDistanceKm // ignore: cast_nullable_to_non_nullable
                      as double,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            totalStations: null == totalStations
                ? _value.totalStations
                : totalStations // ignore: cast_nullable_to_non_nullable
                      as int,
            healthScore: null == healthScore
                ? _value.healthScore
                : healthScore // ignore: cast_nullable_to_non_nullable
                      as int,
            healthLabel: null == healthLabel
                ? _value.healthLabel
                : healthLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            avgSpacingKm: null == avgSpacingKm
                ? _value.avgSpacingKm
                : avgSpacingKm // ignore: cast_nullable_to_non_nullable
                      as double,
            chargingStopsNeeded: null == chargingStopsNeeded
                ? _value.chargingStopsNeeded
                : chargingStopsNeeded // ignore: cast_nullable_to_non_nullable
                      as int,
            estimatedChargingCostRupees: null == estimatedChargingCostRupees
                ? _value.estimatedChargingCostRupees
                : estimatedChargingCostRupees // ignore: cast_nullable_to_non_nullable
                      as double,
            estimatedChargingMinutes: null == estimatedChargingMinutes
                ? _value.estimatedChargingMinutes
                : estimatedChargingMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            fastChargerCount: null == fastChargerCount
                ? _value.fastChargerCount
                : fastChargerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            verifiedCount: null == verifiedCount
                ? _value.verifiedCount
                : verifiedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            avgPowerKw: null == avgPowerKw
                ? _value.avgPowerKw
                : avgPowerKw // ignore: cast_nullable_to_non_nullable
                      as double,
            fastChargerPercent: null == fastChargerPercent
                ? _value.fastChargerPercent
                : fastChargerPercent // ignore: cast_nullable_to_non_nullable
                      as int,
            maxGapKm: null == maxGapKm
                ? _value.maxGapKm
                : maxGapKm // ignore: cast_nullable_to_non_nullable
                      as double,
            gaps: null == gaps
                ? _value.gaps
                : gaps // ignore: cast_nullable_to_non_nullable
                      as List<ChargingGap>,
            topStations: null == topStations
                ? _value.topStations
                : topStations // ignore: cast_nullable_to_non_nullable
                      as List<ChargingStation>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InsightsDataImplCopyWith<$Res>
    implements $InsightsDataCopyWith<$Res> {
  factory _$$InsightsDataImplCopyWith(
    _$InsightsDataImpl value,
    $Res Function(_$InsightsDataImpl) then,
  ) = __$$InsightsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String from,
    String to,
    double routeDistanceKm,
    int durationMinutes,
    int totalStations,
    int healthScore,
    String healthLabel,
    double avgSpacingKm,
    int chargingStopsNeeded,
    double estimatedChargingCostRupees,
    int estimatedChargingMinutes,
    int fastChargerCount,
    int verifiedCount,
    double avgPowerKw,
    int fastChargerPercent,
    double maxGapKm,
    List<ChargingGap> gaps,
    List<ChargingStation> topStations,
  });
}

/// @nodoc
class __$$InsightsDataImplCopyWithImpl<$Res>
    extends _$InsightsDataCopyWithImpl<$Res, _$InsightsDataImpl>
    implements _$$InsightsDataImplCopyWith<$Res> {
  __$$InsightsDataImplCopyWithImpl(
    _$InsightsDataImpl _value,
    $Res Function(_$InsightsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? routeDistanceKm = null,
    Object? durationMinutes = null,
    Object? totalStations = null,
    Object? healthScore = null,
    Object? healthLabel = null,
    Object? avgSpacingKm = null,
    Object? chargingStopsNeeded = null,
    Object? estimatedChargingCostRupees = null,
    Object? estimatedChargingMinutes = null,
    Object? fastChargerCount = null,
    Object? verifiedCount = null,
    Object? avgPowerKw = null,
    Object? fastChargerPercent = null,
    Object? maxGapKm = null,
    Object? gaps = null,
    Object? topStations = null,
  }) {
    return _then(
      _$InsightsDataImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
        routeDistanceKm: null == routeDistanceKm
            ? _value.routeDistanceKm
            : routeDistanceKm // ignore: cast_nullable_to_non_nullable
                  as double,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        totalStations: null == totalStations
            ? _value.totalStations
            : totalStations // ignore: cast_nullable_to_non_nullable
                  as int,
        healthScore: null == healthScore
            ? _value.healthScore
            : healthScore // ignore: cast_nullable_to_non_nullable
                  as int,
        healthLabel: null == healthLabel
            ? _value.healthLabel
            : healthLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        avgSpacingKm: null == avgSpacingKm
            ? _value.avgSpacingKm
            : avgSpacingKm // ignore: cast_nullable_to_non_nullable
                  as double,
        chargingStopsNeeded: null == chargingStopsNeeded
            ? _value.chargingStopsNeeded
            : chargingStopsNeeded // ignore: cast_nullable_to_non_nullable
                  as int,
        estimatedChargingCostRupees: null == estimatedChargingCostRupees
            ? _value.estimatedChargingCostRupees
            : estimatedChargingCostRupees // ignore: cast_nullable_to_non_nullable
                  as double,
        estimatedChargingMinutes: null == estimatedChargingMinutes
            ? _value.estimatedChargingMinutes
            : estimatedChargingMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        fastChargerCount: null == fastChargerCount
            ? _value.fastChargerCount
            : fastChargerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        verifiedCount: null == verifiedCount
            ? _value.verifiedCount
            : verifiedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        avgPowerKw: null == avgPowerKw
            ? _value.avgPowerKw
            : avgPowerKw // ignore: cast_nullable_to_non_nullable
                  as double,
        fastChargerPercent: null == fastChargerPercent
            ? _value.fastChargerPercent
            : fastChargerPercent // ignore: cast_nullable_to_non_nullable
                  as int,
        maxGapKm: null == maxGapKm
            ? _value.maxGapKm
            : maxGapKm // ignore: cast_nullable_to_non_nullable
                  as double,
        gaps: null == gaps
            ? _value._gaps
            : gaps // ignore: cast_nullable_to_non_nullable
                  as List<ChargingGap>,
        topStations: null == topStations
            ? _value._topStations
            : topStations // ignore: cast_nullable_to_non_nullable
                  as List<ChargingStation>,
      ),
    );
  }
}

/// @nodoc

class _$InsightsDataImpl implements _InsightsData {
  const _$InsightsDataImpl({
    this.from = '',
    this.to = '',
    this.routeDistanceKm = 0,
    this.durationMinutes = 0,
    this.totalStations = 0,
    this.healthScore = 0,
    this.healthLabel = '',
    this.avgSpacingKm = 0,
    this.chargingStopsNeeded = 0,
    this.estimatedChargingCostRupees = 0,
    this.estimatedChargingMinutes = 0,
    this.fastChargerCount = 0,
    this.verifiedCount = 0,
    this.avgPowerKw = 0,
    this.fastChargerPercent = 0,
    this.maxGapKm = 0,
    final List<ChargingGap> gaps = const [],
    final List<ChargingStation> topStations = const [],
  }) : _gaps = gaps,
       _topStations = topStations;

  // Route overview
  @override
  @JsonKey()
  final String from;
  @override
  @JsonKey()
  final String to;
  @override
  @JsonKey()
  final double routeDistanceKm;
  @override
  @JsonKey()
  final int durationMinutes;
  @override
  @JsonKey()
  final int totalStations;
  // Route health (0-100)
  @override
  @JsonKey()
  final int healthScore;
  @override
  @JsonKey()
  final String healthLabel;
  // Metrics
  @override
  @JsonKey()
  final double avgSpacingKm;
  @override
  @JsonKey()
  final int chargingStopsNeeded;
  @override
  @JsonKey()
  final double estimatedChargingCostRupees;
  @override
  @JsonKey()
  final int estimatedChargingMinutes;
  // Station quality
  @override
  @JsonKey()
  final int fastChargerCount;
  @override
  @JsonKey()
  final int verifiedCount;
  @override
  @JsonKey()
  final double avgPowerKw;
  @override
  @JsonKey()
  final int fastChargerPercent;
  // Gap analysis
  @override
  @JsonKey()
  final double maxGapKm;
  final List<ChargingGap> _gaps;
  @override
  @JsonKey()
  List<ChargingGap> get gaps {
    if (_gaps is EqualUnmodifiableListView) return _gaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gaps);
  }

  // Top stations for quick reference
  final List<ChargingStation> _topStations;
  // Top stations for quick reference
  @override
  @JsonKey()
  List<ChargingStation> get topStations {
    if (_topStations is EqualUnmodifiableListView) return _topStations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topStations);
  }

  @override
  String toString() {
    return 'InsightsData(from: $from, to: $to, routeDistanceKm: $routeDistanceKm, durationMinutes: $durationMinutes, totalStations: $totalStations, healthScore: $healthScore, healthLabel: $healthLabel, avgSpacingKm: $avgSpacingKm, chargingStopsNeeded: $chargingStopsNeeded, estimatedChargingCostRupees: $estimatedChargingCostRupees, estimatedChargingMinutes: $estimatedChargingMinutes, fastChargerCount: $fastChargerCount, verifiedCount: $verifiedCount, avgPowerKw: $avgPowerKw, fastChargerPercent: $fastChargerPercent, maxGapKm: $maxGapKm, gaps: $gaps, topStations: $topStations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsDataImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.routeDistanceKm, routeDistanceKm) ||
                other.routeDistanceKm == routeDistanceKm) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.totalStations, totalStations) ||
                other.totalStations == totalStations) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore) &&
            (identical(other.healthLabel, healthLabel) ||
                other.healthLabel == healthLabel) &&
            (identical(other.avgSpacingKm, avgSpacingKm) ||
                other.avgSpacingKm == avgSpacingKm) &&
            (identical(other.chargingStopsNeeded, chargingStopsNeeded) ||
                other.chargingStopsNeeded == chargingStopsNeeded) &&
            (identical(
                  other.estimatedChargingCostRupees,
                  estimatedChargingCostRupees,
                ) ||
                other.estimatedChargingCostRupees ==
                    estimatedChargingCostRupees) &&
            (identical(
                  other.estimatedChargingMinutes,
                  estimatedChargingMinutes,
                ) ||
                other.estimatedChargingMinutes == estimatedChargingMinutes) &&
            (identical(other.fastChargerCount, fastChargerCount) ||
                other.fastChargerCount == fastChargerCount) &&
            (identical(other.verifiedCount, verifiedCount) ||
                other.verifiedCount == verifiedCount) &&
            (identical(other.avgPowerKw, avgPowerKw) ||
                other.avgPowerKw == avgPowerKw) &&
            (identical(other.fastChargerPercent, fastChargerPercent) ||
                other.fastChargerPercent == fastChargerPercent) &&
            (identical(other.maxGapKm, maxGapKm) ||
                other.maxGapKm == maxGapKm) &&
            const DeepCollectionEquality().equals(other._gaps, _gaps) &&
            const DeepCollectionEquality().equals(
              other._topStations,
              _topStations,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    from,
    to,
    routeDistanceKm,
    durationMinutes,
    totalStations,
    healthScore,
    healthLabel,
    avgSpacingKm,
    chargingStopsNeeded,
    estimatedChargingCostRupees,
    estimatedChargingMinutes,
    fastChargerCount,
    verifiedCount,
    avgPowerKw,
    fastChargerPercent,
    maxGapKm,
    const DeepCollectionEquality().hash(_gaps),
    const DeepCollectionEquality().hash(_topStations),
  );

  /// Create a copy of InsightsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsDataImplCopyWith<_$InsightsDataImpl> get copyWith =>
      __$$InsightsDataImplCopyWithImpl<_$InsightsDataImpl>(this, _$identity);
}

abstract class _InsightsData implements InsightsData {
  const factory _InsightsData({
    final String from,
    final String to,
    final double routeDistanceKm,
    final int durationMinutes,
    final int totalStations,
    final int healthScore,
    final String healthLabel,
    final double avgSpacingKm,
    final int chargingStopsNeeded,
    final double estimatedChargingCostRupees,
    final int estimatedChargingMinutes,
    final int fastChargerCount,
    final int verifiedCount,
    final double avgPowerKw,
    final int fastChargerPercent,
    final double maxGapKm,
    final List<ChargingGap> gaps,
    final List<ChargingStation> topStations,
  }) = _$InsightsDataImpl;

  // Route overview
  @override
  String get from;
  @override
  String get to;
  @override
  double get routeDistanceKm;
  @override
  int get durationMinutes;
  @override
  int get totalStations; // Route health (0-100)
  @override
  int get healthScore;
  @override
  String get healthLabel; // Metrics
  @override
  double get avgSpacingKm;
  @override
  int get chargingStopsNeeded;
  @override
  double get estimatedChargingCostRupees;
  @override
  int get estimatedChargingMinutes; // Station quality
  @override
  int get fastChargerCount;
  @override
  int get verifiedCount;
  @override
  double get avgPowerKw;
  @override
  int get fastChargerPercent; // Gap analysis
  @override
  double get maxGapKm;
  @override
  List<ChargingGap> get gaps; // Top stations for quick reference
  @override
  List<ChargingStation> get topStations;

  /// Create a copy of InsightsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightsDataImplCopyWith<_$InsightsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InsightsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(InsightsData data) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(InsightsData data)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(InsightsData data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsLoaded value) loaded,
    required TResult Function(InsightsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsLoaded value)? loaded,
    TResult? Function(InsightsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsLoaded value)? loaded,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsStateCopyWith<$Res> {
  factory $InsightsStateCopyWith(
    InsightsState value,
    $Res Function(InsightsState) then,
  ) = _$InsightsStateCopyWithImpl<$Res, InsightsState>;
}

/// @nodoc
class _$InsightsStateCopyWithImpl<$Res, $Val extends InsightsState>
    implements $InsightsStateCopyWith<$Res> {
  _$InsightsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InsightsInitialImplCopyWith<$Res> {
  factory _$$InsightsInitialImplCopyWith(
    _$InsightsInitialImpl value,
    $Res Function(_$InsightsInitialImpl) then,
  ) = __$$InsightsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InsightsInitialImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsInitialImpl>
    implements _$$InsightsInitialImplCopyWith<$Res> {
  __$$InsightsInitialImplCopyWithImpl(
    _$InsightsInitialImpl _value,
    $Res Function(_$InsightsInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InsightsInitialImpl implements InsightsInitial {
  const _$InsightsInitialImpl();

  @override
  String toString() {
    return 'InsightsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InsightsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(InsightsData data) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(InsightsData data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(InsightsData data)? loaded,
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
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsLoaded value) loaded,
    required TResult Function(InsightsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsLoaded value)? loaded,
    TResult? Function(InsightsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsLoaded value)? loaded,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InsightsInitial implements InsightsState {
  const factory InsightsInitial() = _$InsightsInitialImpl;
}

/// @nodoc
abstract class _$$InsightsLoadingImplCopyWith<$Res> {
  factory _$$InsightsLoadingImplCopyWith(
    _$InsightsLoadingImpl value,
    $Res Function(_$InsightsLoadingImpl) then,
  ) = __$$InsightsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InsightsLoadingImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsLoadingImpl>
    implements _$$InsightsLoadingImplCopyWith<$Res> {
  __$$InsightsLoadingImplCopyWithImpl(
    _$InsightsLoadingImpl _value,
    $Res Function(_$InsightsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InsightsLoadingImpl implements InsightsLoading {
  const _$InsightsLoadingImpl();

  @override
  String toString() {
    return 'InsightsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InsightsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(InsightsData data) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(InsightsData data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(InsightsData data)? loaded,
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
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsLoaded value) loaded,
    required TResult Function(InsightsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsLoaded value)? loaded,
    TResult? Function(InsightsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsLoaded value)? loaded,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class InsightsLoading implements InsightsState {
  const factory InsightsLoading() = _$InsightsLoadingImpl;
}

/// @nodoc
abstract class _$$InsightsLoadedImplCopyWith<$Res> {
  factory _$$InsightsLoadedImplCopyWith(
    _$InsightsLoadedImpl value,
    $Res Function(_$InsightsLoadedImpl) then,
  ) = __$$InsightsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({InsightsData data});

  $InsightsDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$InsightsLoadedImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsLoadedImpl>
    implements _$$InsightsLoadedImplCopyWith<$Res> {
  __$$InsightsLoadedImplCopyWithImpl(
    _$InsightsLoadedImpl _value,
    $Res Function(_$InsightsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$InsightsLoadedImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as InsightsData,
      ),
    );
  }

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InsightsDataCopyWith<$Res> get data {
    return $InsightsDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$InsightsLoadedImpl implements InsightsLoaded {
  const _$InsightsLoadedImpl(this.data);

  @override
  final InsightsData data;

  @override
  String toString() {
    return 'InsightsState.loaded(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsLoadedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsLoadedImplCopyWith<_$InsightsLoadedImpl> get copyWith =>
      __$$InsightsLoadedImplCopyWithImpl<_$InsightsLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(InsightsData data) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(InsightsData data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(InsightsData data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsLoaded value) loaded,
    required TResult Function(InsightsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsLoaded value)? loaded,
    TResult? Function(InsightsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsLoaded value)? loaded,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class InsightsLoaded implements InsightsState {
  const factory InsightsLoaded(final InsightsData data) = _$InsightsLoadedImpl;

  InsightsData get data;

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightsLoadedImplCopyWith<_$InsightsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InsightsErrorImplCopyWith<$Res> {
  factory _$$InsightsErrorImplCopyWith(
    _$InsightsErrorImpl value,
    $Res Function(_$InsightsErrorImpl) then,
  ) = __$$InsightsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$InsightsErrorImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsErrorImpl>
    implements _$$InsightsErrorImplCopyWith<$Res> {
  __$$InsightsErrorImplCopyWithImpl(
    _$InsightsErrorImpl _value,
    $Res Function(_$InsightsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$InsightsErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$InsightsErrorImpl implements InsightsError {
  const _$InsightsErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'InsightsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsErrorImplCopyWith<_$InsightsErrorImpl> get copyWith =>
      __$$InsightsErrorImplCopyWithImpl<_$InsightsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(InsightsData data) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(InsightsData data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(InsightsData data)? loaded,
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
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsLoaded value) loaded,
    required TResult Function(InsightsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsLoaded value)? loaded,
    TResult? Function(InsightsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsLoaded value)? loaded,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class InsightsError implements InsightsState {
  const factory InsightsError(final String message) = _$InsightsErrorImpl;

  String get message;

  /// Create a copy of InsightsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightsErrorImplCopyWith<_$InsightsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
