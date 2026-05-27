// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoiImpl _$$PoiImplFromJson(Map<String, dynamic> json) => _$PoiImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  category: $enumDecode(_$PoiCategoryEnumMap, json['category']),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
  source:
      $enumDecodeNullable(_$PoiSourceEnumMap, json['source']) ??
      PoiSource.unknown,
  rating: (json['rating'] as num?)?.toDouble() ?? 0,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  openNow: json['openNow'] as bool?,
  priceLevel: (json['priceLevel'] as num?)?.toInt(),
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  attributes:
      json['attributes'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  distanceAlongRouteKm: (json['distanceAlongRouteKm'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$PoiImplToJson(_$PoiImpl instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': _$PoiCategoryEnumMap[instance.category]!,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'source': _$PoiSourceEnumMap[instance.source]!,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'openNow': instance.openNow,
  'priceLevel': instance.priceLevel,
  'photos': instance.photos,
  'attributes': instance.attributes,
  'distanceAlongRouteKm': instance.distanceAlongRouteKm,
};

const _$PoiCategoryEnumMap = {
  PoiCategory.fuel: 'fuel',
  PoiCategory.ev: 'ev',
  PoiCategory.restaurant: 'restaurant',
  PoiCategory.pureVeg: 'pure_veg',
  PoiCategory.washroom: 'washroom',
  PoiCategory.atm: 'atm',
  PoiCategory.hotel: 'hotel',
  PoiCategory.medical: 'medical',
  PoiCategory.scenic: 'scenic',
  PoiCategory.temple: 'temple',
  PoiCategory.kidsStop: 'kids_stop',
  PoiCategory.mechanic: 'mechanic',
  PoiCategory.parking: 'parking',
  PoiCategory.cafe: 'cafe',
  PoiCategory.tourist: 'tourist',
  PoiCategory.police: 'police',
};

const _$PoiSourceEnumMap = {
  PoiSource.googlePlaces: 'google_places',
  PoiSource.ocm: 'ocm',
  PoiSource.community: 'community',
  PoiSource.curated: 'curated',
  PoiSource.unknown: 'unknown',
};
