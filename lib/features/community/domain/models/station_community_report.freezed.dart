// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_community_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StationCommunityReport {
  String get id => throw _privateConstructorUsedError;
  String get stationKey => throw _privateConstructorUsedError;
  String get stationNameSnapshot => throw _privateConstructorUsedError;
  String get reporterUserId => throw _privateConstructorUsedError;
  String? get reporterDisplayName => throw _privateConstructorUsedError;

  /// 1–5 stars
  int get rating => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  List<String> get availableAmenityLabels => throw _privateConstructorUsedError;
  bool? get washroomAvailable => throw _privateConstructorUsedError;
  bool? get washroomClean => throw _privateConstructorUsedError;
  bool? get womenFriendlyWashroom => throw _privateConstructorUsedError;

  /// JPEG base64, optional (kept small for Firestore document limits).
  String? get photoBase64 => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  String? get costPerKwh => throw _privateConstructorUsedError;
  bool get fastChargerAvailable => throw _privateConstructorUsedError;
  bool? get chargeSuccessful => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  CommunityTargetType get targetType => throw _privateConstructorUsedError;
  String? get targetKey =>
      throw _privateConstructorUsedError; // P2-023 — Mode tags. Null = unanswered (legacy reports + skips).
  bool? get babyFriendly => throw _privateConstructorUsedError;
  bool? get womenSafe => throw _privateConstructorUsedError;
  bool? get hygienic => throw _privateConstructorUsedError;

  /// Create a copy of StationCommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StationCommunityReportCopyWith<StationCommunityReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StationCommunityReportCopyWith<$Res> {
  factory $StationCommunityReportCopyWith(
    StationCommunityReport value,
    $Res Function(StationCommunityReport) then,
  ) = _$StationCommunityReportCopyWithImpl<$Res, StationCommunityReport>;
  @useResult
  $Res call({
    String id,
    String stationKey,
    String stationNameSnapshot,
    String reporterUserId,
    String? reporterDisplayName,
    int rating,
    String condition,
    List<String> availableAmenityLabels,
    bool? washroomAvailable,
    bool? washroomClean,
    bool? womenFriendlyWashroom,
    String? photoBase64,
    String? comment,
    String? costPerKwh,
    bool fastChargerAvailable,
    bool? chargeSuccessful,
    DateTime createdAt,
    CommunityTargetType targetType,
    String? targetKey,
    bool? babyFriendly,
    bool? womenSafe,
    bool? hygienic,
  });
}

/// @nodoc
class _$StationCommunityReportCopyWithImpl<
  $Res,
  $Val extends StationCommunityReport
>
    implements $StationCommunityReportCopyWith<$Res> {
  _$StationCommunityReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StationCommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationKey = null,
    Object? stationNameSnapshot = null,
    Object? reporterUserId = null,
    Object? reporterDisplayName = freezed,
    Object? rating = null,
    Object? condition = null,
    Object? availableAmenityLabels = null,
    Object? washroomAvailable = freezed,
    Object? washroomClean = freezed,
    Object? womenFriendlyWashroom = freezed,
    Object? photoBase64 = freezed,
    Object? comment = freezed,
    Object? costPerKwh = freezed,
    Object? fastChargerAvailable = null,
    Object? chargeSuccessful = freezed,
    Object? createdAt = null,
    Object? targetType = null,
    Object? targetKey = freezed,
    Object? babyFriendly = freezed,
    Object? womenSafe = freezed,
    Object? hygienic = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            stationKey: null == stationKey
                ? _value.stationKey
                : stationKey // ignore: cast_nullable_to_non_nullable
                      as String,
            stationNameSnapshot: null == stationNameSnapshot
                ? _value.stationNameSnapshot
                : stationNameSnapshot // ignore: cast_nullable_to_non_nullable
                      as String,
            reporterUserId: null == reporterUserId
                ? _value.reporterUserId
                : reporterUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            reporterDisplayName: freezed == reporterDisplayName
                ? _value.reporterDisplayName
                : reporterDisplayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as String,
            availableAmenityLabels: null == availableAmenityLabels
                ? _value.availableAmenityLabels
                : availableAmenityLabels // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            washroomAvailable: freezed == washroomAvailable
                ? _value.washroomAvailable
                : washroomAvailable // ignore: cast_nullable_to_non_nullable
                      as bool?,
            washroomClean: freezed == washroomClean
                ? _value.washroomClean
                : washroomClean // ignore: cast_nullable_to_non_nullable
                      as bool?,
            womenFriendlyWashroom: freezed == womenFriendlyWashroom
                ? _value.womenFriendlyWashroom
                : womenFriendlyWashroom // ignore: cast_nullable_to_non_nullable
                      as bool?,
            photoBase64: freezed == photoBase64
                ? _value.photoBase64
                : photoBase64 // ignore: cast_nullable_to_non_nullable
                      as String?,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            costPerKwh: freezed == costPerKwh
                ? _value.costPerKwh
                : costPerKwh // ignore: cast_nullable_to_non_nullable
                      as String?,
            fastChargerAvailable: null == fastChargerAvailable
                ? _value.fastChargerAvailable
                : fastChargerAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            chargeSuccessful: freezed == chargeSuccessful
                ? _value.chargeSuccessful
                : chargeSuccessful // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            targetType: null == targetType
                ? _value.targetType
                : targetType // ignore: cast_nullable_to_non_nullable
                      as CommunityTargetType,
            targetKey: freezed == targetKey
                ? _value.targetKey
                : targetKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            babyFriendly: freezed == babyFriendly
                ? _value.babyFriendly
                : babyFriendly // ignore: cast_nullable_to_non_nullable
                      as bool?,
            womenSafe: freezed == womenSafe
                ? _value.womenSafe
                : womenSafe // ignore: cast_nullable_to_non_nullable
                      as bool?,
            hygienic: freezed == hygienic
                ? _value.hygienic
                : hygienic // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StationCommunityReportImplCopyWith<$Res>
    implements $StationCommunityReportCopyWith<$Res> {
  factory _$$StationCommunityReportImplCopyWith(
    _$StationCommunityReportImpl value,
    $Res Function(_$StationCommunityReportImpl) then,
  ) = __$$StationCommunityReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String stationKey,
    String stationNameSnapshot,
    String reporterUserId,
    String? reporterDisplayName,
    int rating,
    String condition,
    List<String> availableAmenityLabels,
    bool? washroomAvailable,
    bool? washroomClean,
    bool? womenFriendlyWashroom,
    String? photoBase64,
    String? comment,
    String? costPerKwh,
    bool fastChargerAvailable,
    bool? chargeSuccessful,
    DateTime createdAt,
    CommunityTargetType targetType,
    String? targetKey,
    bool? babyFriendly,
    bool? womenSafe,
    bool? hygienic,
  });
}

/// @nodoc
class __$$StationCommunityReportImplCopyWithImpl<$Res>
    extends
        _$StationCommunityReportCopyWithImpl<$Res, _$StationCommunityReportImpl>
    implements _$$StationCommunityReportImplCopyWith<$Res> {
  __$$StationCommunityReportImplCopyWithImpl(
    _$StationCommunityReportImpl _value,
    $Res Function(_$StationCommunityReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StationCommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationKey = null,
    Object? stationNameSnapshot = null,
    Object? reporterUserId = null,
    Object? reporterDisplayName = freezed,
    Object? rating = null,
    Object? condition = null,
    Object? availableAmenityLabels = null,
    Object? washroomAvailable = freezed,
    Object? washroomClean = freezed,
    Object? womenFriendlyWashroom = freezed,
    Object? photoBase64 = freezed,
    Object? comment = freezed,
    Object? costPerKwh = freezed,
    Object? fastChargerAvailable = null,
    Object? chargeSuccessful = freezed,
    Object? createdAt = null,
    Object? targetType = null,
    Object? targetKey = freezed,
    Object? babyFriendly = freezed,
    Object? womenSafe = freezed,
    Object? hygienic = freezed,
  }) {
    return _then(
      _$StationCommunityReportImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        stationKey: null == stationKey
            ? _value.stationKey
            : stationKey // ignore: cast_nullable_to_non_nullable
                  as String,
        stationNameSnapshot: null == stationNameSnapshot
            ? _value.stationNameSnapshot
            : stationNameSnapshot // ignore: cast_nullable_to_non_nullable
                  as String,
        reporterUserId: null == reporterUserId
            ? _value.reporterUserId
            : reporterUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        reporterDisplayName: freezed == reporterDisplayName
            ? _value.reporterDisplayName
            : reporterDisplayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as String,
        availableAmenityLabels: null == availableAmenityLabels
            ? _value._availableAmenityLabels
            : availableAmenityLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        washroomAvailable: freezed == washroomAvailable
            ? _value.washroomAvailable
            : washroomAvailable // ignore: cast_nullable_to_non_nullable
                  as bool?,
        washroomClean: freezed == washroomClean
            ? _value.washroomClean
            : washroomClean // ignore: cast_nullable_to_non_nullable
                  as bool?,
        womenFriendlyWashroom: freezed == womenFriendlyWashroom
            ? _value.womenFriendlyWashroom
            : womenFriendlyWashroom // ignore: cast_nullable_to_non_nullable
                  as bool?,
        photoBase64: freezed == photoBase64
            ? _value.photoBase64
            : photoBase64 // ignore: cast_nullable_to_non_nullable
                  as String?,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        costPerKwh: freezed == costPerKwh
            ? _value.costPerKwh
            : costPerKwh // ignore: cast_nullable_to_non_nullable
                  as String?,
        fastChargerAvailable: null == fastChargerAvailable
            ? _value.fastChargerAvailable
            : fastChargerAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        chargeSuccessful: freezed == chargeSuccessful
            ? _value.chargeSuccessful
            : chargeSuccessful // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        targetType: null == targetType
            ? _value.targetType
            : targetType // ignore: cast_nullable_to_non_nullable
                  as CommunityTargetType,
        targetKey: freezed == targetKey
            ? _value.targetKey
            : targetKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        babyFriendly: freezed == babyFriendly
            ? _value.babyFriendly
            : babyFriendly // ignore: cast_nullable_to_non_nullable
                  as bool?,
        womenSafe: freezed == womenSafe
            ? _value.womenSafe
            : womenSafe // ignore: cast_nullable_to_non_nullable
                  as bool?,
        hygienic: freezed == hygienic
            ? _value.hygienic
            : hygienic // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$StationCommunityReportImpl extends _StationCommunityReport {
  const _$StationCommunityReportImpl({
    required this.id,
    required this.stationKey,
    required this.stationNameSnapshot,
    required this.reporterUserId,
    this.reporterDisplayName,
    required this.rating,
    required this.condition,
    final List<String> availableAmenityLabels = const <String>[],
    this.washroomAvailable,
    this.washroomClean,
    this.womenFriendlyWashroom,
    this.photoBase64,
    this.comment,
    this.costPerKwh,
    this.fastChargerAvailable = false,
    this.chargeSuccessful,
    required this.createdAt,
    this.targetType = CommunityTargetType.station,
    this.targetKey,
    this.babyFriendly,
    this.womenSafe,
    this.hygienic,
  }) : _availableAmenityLabels = availableAmenityLabels,
       super._();

  @override
  final String id;
  @override
  final String stationKey;
  @override
  final String stationNameSnapshot;
  @override
  final String reporterUserId;
  @override
  final String? reporterDisplayName;

  /// 1–5 stars
  @override
  final int rating;
  @override
  final String condition;
  final List<String> _availableAmenityLabels;
  @override
  @JsonKey()
  List<String> get availableAmenityLabels {
    if (_availableAmenityLabels is EqualUnmodifiableListView)
      return _availableAmenityLabels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableAmenityLabels);
  }

  @override
  final bool? washroomAvailable;
  @override
  final bool? washroomClean;
  @override
  final bool? womenFriendlyWashroom;

  /// JPEG base64, optional (kept small for Firestore document limits).
  @override
  final String? photoBase64;
  @override
  final String? comment;
  @override
  final String? costPerKwh;
  @override
  @JsonKey()
  final bool fastChargerAvailable;
  @override
  final bool? chargeSuccessful;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final CommunityTargetType targetType;
  @override
  final String? targetKey;
  // P2-023 — Mode tags. Null = unanswered (legacy reports + skips).
  @override
  final bool? babyFriendly;
  @override
  final bool? womenSafe;
  @override
  final bool? hygienic;

  @override
  String toString() {
    return 'StationCommunityReport(id: $id, stationKey: $stationKey, stationNameSnapshot: $stationNameSnapshot, reporterUserId: $reporterUserId, reporterDisplayName: $reporterDisplayName, rating: $rating, condition: $condition, availableAmenityLabels: $availableAmenityLabels, washroomAvailable: $washroomAvailable, washroomClean: $washroomClean, womenFriendlyWashroom: $womenFriendlyWashroom, photoBase64: $photoBase64, comment: $comment, costPerKwh: $costPerKwh, fastChargerAvailable: $fastChargerAvailable, chargeSuccessful: $chargeSuccessful, createdAt: $createdAt, targetType: $targetType, targetKey: $targetKey, babyFriendly: $babyFriendly, womenSafe: $womenSafe, hygienic: $hygienic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationCommunityReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stationKey, stationKey) ||
                other.stationKey == stationKey) &&
            (identical(other.stationNameSnapshot, stationNameSnapshot) ||
                other.stationNameSnapshot == stationNameSnapshot) &&
            (identical(other.reporterUserId, reporterUserId) ||
                other.reporterUserId == reporterUserId) &&
            (identical(other.reporterDisplayName, reporterDisplayName) ||
                other.reporterDisplayName == reporterDisplayName) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            const DeepCollectionEquality().equals(
              other._availableAmenityLabels,
              _availableAmenityLabels,
            ) &&
            (identical(other.washroomAvailable, washroomAvailable) ||
                other.washroomAvailable == washroomAvailable) &&
            (identical(other.washroomClean, washroomClean) ||
                other.washroomClean == washroomClean) &&
            (identical(other.womenFriendlyWashroom, womenFriendlyWashroom) ||
                other.womenFriendlyWashroom == womenFriendlyWashroom) &&
            (identical(other.photoBase64, photoBase64) ||
                other.photoBase64 == photoBase64) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.costPerKwh, costPerKwh) ||
                other.costPerKwh == costPerKwh) &&
            (identical(other.fastChargerAvailable, fastChargerAvailable) ||
                other.fastChargerAvailable == fastChargerAvailable) &&
            (identical(other.chargeSuccessful, chargeSuccessful) ||
                other.chargeSuccessful == chargeSuccessful) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            (identical(other.targetKey, targetKey) ||
                other.targetKey == targetKey) &&
            (identical(other.babyFriendly, babyFriendly) ||
                other.babyFriendly == babyFriendly) &&
            (identical(other.womenSafe, womenSafe) ||
                other.womenSafe == womenSafe) &&
            (identical(other.hygienic, hygienic) ||
                other.hygienic == hygienic));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    stationKey,
    stationNameSnapshot,
    reporterUserId,
    reporterDisplayName,
    rating,
    condition,
    const DeepCollectionEquality().hash(_availableAmenityLabels),
    washroomAvailable,
    washroomClean,
    womenFriendlyWashroom,
    photoBase64,
    comment,
    costPerKwh,
    fastChargerAvailable,
    chargeSuccessful,
    createdAt,
    targetType,
    targetKey,
    babyFriendly,
    womenSafe,
    hygienic,
  ]);

  /// Create a copy of StationCommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationCommunityReportImplCopyWith<_$StationCommunityReportImpl>
  get copyWith =>
      __$$StationCommunityReportImplCopyWithImpl<_$StationCommunityReportImpl>(
        this,
        _$identity,
      );
}

abstract class _StationCommunityReport extends StationCommunityReport {
  const factory _StationCommunityReport({
    required final String id,
    required final String stationKey,
    required final String stationNameSnapshot,
    required final String reporterUserId,
    final String? reporterDisplayName,
    required final int rating,
    required final String condition,
    final List<String> availableAmenityLabels,
    final bool? washroomAvailable,
    final bool? washroomClean,
    final bool? womenFriendlyWashroom,
    final String? photoBase64,
    final String? comment,
    final String? costPerKwh,
    final bool fastChargerAvailable,
    final bool? chargeSuccessful,
    required final DateTime createdAt,
    final CommunityTargetType targetType,
    final String? targetKey,
    final bool? babyFriendly,
    final bool? womenSafe,
    final bool? hygienic,
  }) = _$StationCommunityReportImpl;
  const _StationCommunityReport._() : super._();

  @override
  String get id;
  @override
  String get stationKey;
  @override
  String get stationNameSnapshot;
  @override
  String get reporterUserId;
  @override
  String? get reporterDisplayName;

  /// 1–5 stars
  @override
  int get rating;
  @override
  String get condition;
  @override
  List<String> get availableAmenityLabels;
  @override
  bool? get washroomAvailable;
  @override
  bool? get washroomClean;
  @override
  bool? get womenFriendlyWashroom;

  /// JPEG base64, optional (kept small for Firestore document limits).
  @override
  String? get photoBase64;
  @override
  String? get comment;
  @override
  String? get costPerKwh;
  @override
  bool get fastChargerAvailable;
  @override
  bool? get chargeSuccessful;
  @override
  DateTime get createdAt;
  @override
  CommunityTargetType get targetType;
  @override
  String? get targetKey; // P2-023 — Mode tags. Null = unanswered (legacy reports + skips).
  @override
  bool? get babyFriendly;
  @override
  bool? get womenSafe;
  @override
  bool? get hygienic;

  /// Create a copy of StationCommunityReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationCommunityReportImplCopyWith<_$StationCommunityReportImpl>
  get copyWith => throw _privateConstructorUsedError;
}
