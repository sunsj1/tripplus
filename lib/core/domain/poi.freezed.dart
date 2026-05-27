// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Poi _$PoiFromJson(Map<String, dynamic> json) {
  return _Poi.fromJson(json);
}

/// @nodoc
mixin _$Poi {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  PoiCategory get category => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  PoiSource get source => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  bool? get openNow => throw _privateConstructorUsedError;
  int? get priceLevel => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  Map<String, dynamic> get attributes => throw _privateConstructorUsedError;

  /// Distance along the active route polyline, when the POI was fetched as
  /// route-aware. Null for radial / nearby queries.
  double? get distanceAlongRouteKm => throw _privateConstructorUsedError;

  /// Serializes this Poi to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Poi
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoiCopyWith<Poi> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoiCopyWith<$Res> {
  factory $PoiCopyWith(Poi value, $Res Function(Poi) then) =
      _$PoiCopyWithImpl<$Res, Poi>;
  @useResult
  $Res call({
    String id,
    String name,
    PoiCategory category,
    double latitude,
    double longitude,
    String? address,
    PoiSource source,
    double rating,
    int reviewCount,
    bool? openNow,
    int? priceLevel,
    List<String> photos,
    Map<String, dynamic> attributes,
    double? distanceAlongRouteKm,
  });
}

/// @nodoc
class _$PoiCopyWithImpl<$Res, $Val extends Poi> implements $PoiCopyWith<$Res> {
  _$PoiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Poi
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? source = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? openNow = freezed,
    Object? priceLevel = freezed,
    Object? photos = null,
    Object? attributes = null,
    Object? distanceAlongRouteKm = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as PoiCategory,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as PoiSource,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            openNow: freezed == openNow
                ? _value.openNow
                : openNow // ignore: cast_nullable_to_non_nullable
                      as bool?,
            priceLevel: freezed == priceLevel
                ? _value.priceLevel
                : priceLevel // ignore: cast_nullable_to_non_nullable
                      as int?,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            attributes: null == attributes
                ? _value.attributes
                : attributes // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            distanceAlongRouteKm: freezed == distanceAlongRouteKm
                ? _value.distanceAlongRouteKm
                : distanceAlongRouteKm // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoiImplCopyWith<$Res> implements $PoiCopyWith<$Res> {
  factory _$$PoiImplCopyWith(_$PoiImpl value, $Res Function(_$PoiImpl) then) =
      __$$PoiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    PoiCategory category,
    double latitude,
    double longitude,
    String? address,
    PoiSource source,
    double rating,
    int reviewCount,
    bool? openNow,
    int? priceLevel,
    List<String> photos,
    Map<String, dynamic> attributes,
    double? distanceAlongRouteKm,
  });
}

/// @nodoc
class __$$PoiImplCopyWithImpl<$Res> extends _$PoiCopyWithImpl<$Res, _$PoiImpl>
    implements _$$PoiImplCopyWith<$Res> {
  __$$PoiImplCopyWithImpl(_$PoiImpl _value, $Res Function(_$PoiImpl) _then)
    : super(_value, _then);

  /// Create a copy of Poi
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? source = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? openNow = freezed,
    Object? priceLevel = freezed,
    Object? photos = null,
    Object? attributes = null,
    Object? distanceAlongRouteKm = freezed,
  }) {
    return _then(
      _$PoiImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as PoiCategory,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as PoiSource,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        openNow: freezed == openNow
            ? _value.openNow
            : openNow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        priceLevel: freezed == priceLevel
            ? _value.priceLevel
            : priceLevel // ignore: cast_nullable_to_non_nullable
                  as int?,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        attributes: null == attributes
            ? _value._attributes
            : attributes // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        distanceAlongRouteKm: freezed == distanceAlongRouteKm
            ? _value.distanceAlongRouteKm
            : distanceAlongRouteKm // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PoiImpl extends _Poi {
  const _$PoiImpl({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.address,
    this.source = PoiSource.unknown,
    this.rating = 0,
    this.reviewCount = 0,
    this.openNow,
    this.priceLevel,
    final List<String> photos = const <String>[],
    final Map<String, dynamic> attributes = const <String, dynamic>{},
    this.distanceAlongRouteKm,
  }) : _photos = photos,
       _attributes = attributes,
       super._();

  factory _$PoiImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoiImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final PoiCategory category;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? address;
  @override
  @JsonKey()
  final PoiSource source;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  final bool? openNow;
  @override
  final int? priceLevel;
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  final Map<String, dynamic> _attributes;
  @override
  @JsonKey()
  Map<String, dynamic> get attributes {
    if (_attributes is EqualUnmodifiableMapView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_attributes);
  }

  /// Distance along the active route polyline, when the POI was fetched as
  /// route-aware. Null for radial / nearby queries.
  @override
  final double? distanceAlongRouteKm;

  @override
  String toString() {
    return 'Poi(id: $id, name: $name, category: $category, latitude: $latitude, longitude: $longitude, address: $address, source: $source, rating: $rating, reviewCount: $reviewCount, openNow: $openNow, priceLevel: $priceLevel, photos: $photos, attributes: $attributes, distanceAlongRouteKm: $distanceAlongRouteKm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoiImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.openNow, openNow) || other.openNow == openNow) &&
            (identical(other.priceLevel, priceLevel) ||
                other.priceLevel == priceLevel) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality().equals(
              other._attributes,
              _attributes,
            ) &&
            (identical(other.distanceAlongRouteKm, distanceAlongRouteKm) ||
                other.distanceAlongRouteKm == distanceAlongRouteKm));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    category,
    latitude,
    longitude,
    address,
    source,
    rating,
    reviewCount,
    openNow,
    priceLevel,
    const DeepCollectionEquality().hash(_photos),
    const DeepCollectionEquality().hash(_attributes),
    distanceAlongRouteKm,
  );

  /// Create a copy of Poi
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoiImplCopyWith<_$PoiImpl> get copyWith =>
      __$$PoiImplCopyWithImpl<_$PoiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoiImplToJson(this);
  }
}

abstract class _Poi extends Poi {
  const factory _Poi({
    required final String id,
    required final String name,
    required final PoiCategory category,
    required final double latitude,
    required final double longitude,
    final String? address,
    final PoiSource source,
    final double rating,
    final int reviewCount,
    final bool? openNow,
    final int? priceLevel,
    final List<String> photos,
    final Map<String, dynamic> attributes,
    final double? distanceAlongRouteKm,
  }) = _$PoiImpl;
  const _Poi._() : super._();

  factory _Poi.fromJson(Map<String, dynamic> json) = _$PoiImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  PoiCategory get category;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get address;
  @override
  PoiSource get source;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  bool? get openNow;
  @override
  int? get priceLevel;
  @override
  List<String> get photos;
  @override
  Map<String, dynamic> get attributes;

  /// Distance along the active route polyline, when the POI was fetched as
  /// route-aware. Null for radial / nearby queries.
  @override
  double? get distanceAlongRouteKm;

  /// Create a copy of Poi
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoiImplCopyWith<_$PoiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
