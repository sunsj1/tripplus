// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommunityReport _$CommunityReportFromJson(Map<String, dynamic> json) {
  return _CommunityReport.fromJson(json);
}

/// @nodoc
mixin _$CommunityReport {
  String get stationId => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  String? get costPerKwh => throw _privateConstructorUsedError;
  bool get fastChargerAvailable => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  int get reportedAtMs => throw _privateConstructorUsedError;

  /// Serializes this CommunityReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityReportCopyWith<CommunityReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityReportCopyWith<$Res> {
  factory $CommunityReportCopyWith(
    CommunityReport value,
    $Res Function(CommunityReport) then,
  ) = _$CommunityReportCopyWithImpl<$Res, CommunityReport>;
  @useResult
  $Res call({
    String stationId,
    String condition,
    String? costPerKwh,
    bool fastChargerAvailable,
    String? comments,
    int reportedAtMs,
  });
}

/// @nodoc
class _$CommunityReportCopyWithImpl<$Res, $Val extends CommunityReport>
    implements $CommunityReportCopyWith<$Res> {
  _$CommunityReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stationId = null,
    Object? condition = null,
    Object? costPerKwh = freezed,
    Object? fastChargerAvailable = null,
    Object? comments = freezed,
    Object? reportedAtMs = null,
  }) {
    return _then(
      _value.copyWith(
            stationId: null == stationId
                ? _value.stationId
                : stationId // ignore: cast_nullable_to_non_nullable
                      as String,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as String,
            costPerKwh: freezed == costPerKwh
                ? _value.costPerKwh
                : costPerKwh // ignore: cast_nullable_to_non_nullable
                      as String?,
            fastChargerAvailable: null == fastChargerAvailable
                ? _value.fastChargerAvailable
                : fastChargerAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as String?,
            reportedAtMs: null == reportedAtMs
                ? _value.reportedAtMs
                : reportedAtMs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommunityReportImplCopyWith<$Res>
    implements $CommunityReportCopyWith<$Res> {
  factory _$$CommunityReportImplCopyWith(
    _$CommunityReportImpl value,
    $Res Function(_$CommunityReportImpl) then,
  ) = __$$CommunityReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String stationId,
    String condition,
    String? costPerKwh,
    bool fastChargerAvailable,
    String? comments,
    int reportedAtMs,
  });
}

/// @nodoc
class __$$CommunityReportImplCopyWithImpl<$Res>
    extends _$CommunityReportCopyWithImpl<$Res, _$CommunityReportImpl>
    implements _$$CommunityReportImplCopyWith<$Res> {
  __$$CommunityReportImplCopyWithImpl(
    _$CommunityReportImpl _value,
    $Res Function(_$CommunityReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stationId = null,
    Object? condition = null,
    Object? costPerKwh = freezed,
    Object? fastChargerAvailable = null,
    Object? comments = freezed,
    Object? reportedAtMs = null,
  }) {
    return _then(
      _$CommunityReportImpl(
        stationId: null == stationId
            ? _value.stationId
            : stationId // ignore: cast_nullable_to_non_nullable
                  as String,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as String,
        costPerKwh: freezed == costPerKwh
            ? _value.costPerKwh
            : costPerKwh // ignore: cast_nullable_to_non_nullable
                  as String?,
        fastChargerAvailable: null == fastChargerAvailable
            ? _value.fastChargerAvailable
            : fastChargerAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as String?,
        reportedAtMs: null == reportedAtMs
            ? _value.reportedAtMs
            : reportedAtMs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityReportImpl implements _CommunityReport {
  const _$CommunityReportImpl({
    required this.stationId,
    required this.condition,
    this.costPerKwh,
    this.fastChargerAvailable = false,
    this.comments,
    required this.reportedAtMs,
  });

  factory _$CommunityReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityReportImplFromJson(json);

  @override
  final String stationId;
  @override
  final String condition;
  @override
  final String? costPerKwh;
  @override
  @JsonKey()
  final bool fastChargerAvailable;
  @override
  final String? comments;
  @override
  final int reportedAtMs;

  @override
  String toString() {
    return 'CommunityReport(stationId: $stationId, condition: $condition, costPerKwh: $costPerKwh, fastChargerAvailable: $fastChargerAvailable, comments: $comments, reportedAtMs: $reportedAtMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityReportImpl &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.costPerKwh, costPerKwh) ||
                other.costPerKwh == costPerKwh) &&
            (identical(other.fastChargerAvailable, fastChargerAvailable) ||
                other.fastChargerAvailable == fastChargerAvailable) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.reportedAtMs, reportedAtMs) ||
                other.reportedAtMs == reportedAtMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    stationId,
    condition,
    costPerKwh,
    fastChargerAvailable,
    comments,
    reportedAtMs,
  );

  /// Create a copy of CommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityReportImplCopyWith<_$CommunityReportImpl> get copyWith =>
      __$$CommunityReportImplCopyWithImpl<_$CommunityReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityReportImplToJson(this);
  }
}

abstract class _CommunityReport implements CommunityReport {
  const factory _CommunityReport({
    required final String stationId,
    required final String condition,
    final String? costPerKwh,
    final bool fastChargerAvailable,
    final String? comments,
    required final int reportedAtMs,
  }) = _$CommunityReportImpl;

  factory _CommunityReport.fromJson(Map<String, dynamic> json) =
      _$CommunityReportImpl.fromJson;

  @override
  String get stationId;
  @override
  String get condition;
  @override
  String? get costPerKwh;
  @override
  bool get fastChargerAvailable;
  @override
  String? get comments;
  @override
  int get reportedAtMs;

  /// Create a copy of CommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityReportImplCopyWith<_$CommunityReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
