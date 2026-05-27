import 'package:freezed_annotation/freezed_annotation.dart';

part 'poi.freezed.dart';
part 'poi.g.dart';

/// The 16 grid categories from the PDF Smart Intelligence Grid.
enum PoiCategory {
  @JsonValue('fuel')
  fuel,
  @JsonValue('ev')
  ev,
  @JsonValue('restaurant')
  restaurant,
  @JsonValue('pure_veg')
  pureVeg,
  @JsonValue('washroom')
  washroom,
  @JsonValue('atm')
  atm,
  @JsonValue('hotel')
  hotel,
  @JsonValue('medical')
  medical,
  @JsonValue('scenic')
  scenic,
  @JsonValue('temple')
  temple,
  @JsonValue('kids_stop')
  kidsStop,
  @JsonValue('mechanic')
  mechanic,
  @JsonValue('parking')
  parking,
  @JsonValue('cafe')
  cafe,
  @JsonValue('tourist')
  tourist,
  @JsonValue('police')
  police,
}

extension PoiCategoryX on PoiCategory {
  String get label {
    switch (this) {
      case PoiCategory.fuel:
        return 'Fuel';
      case PoiCategory.ev:
        return 'EV Charging';
      case PoiCategory.restaurant:
        return 'Restaurants';
      case PoiCategory.pureVeg:
        return 'Pure Veg';
      case PoiCategory.washroom:
        return 'Washrooms';
      case PoiCategory.atm:
        return 'ATMs';
      case PoiCategory.hotel:
        return 'Hotels';
      case PoiCategory.medical:
        return 'Medical';
      case PoiCategory.scenic:
        return 'Scenic';
      case PoiCategory.temple:
        return 'Temples';
      case PoiCategory.kidsStop:
        return 'Kids Stop';
      case PoiCategory.mechanic:
        return 'Mechanic';
      case PoiCategory.parking:
        return 'Parking';
      case PoiCategory.cafe:
        return 'Cafes';
      case PoiCategory.tourist:
        return 'Tourist';
      case PoiCategory.police:
        return 'Police';
    }
  }

  /// Stored value used in Firestore / Hive / `targetKey` prefixes. Stable.
  String get wireValue {
    switch (this) {
      case PoiCategory.fuel:
        return 'fuel';
      case PoiCategory.ev:
        return 'ev';
      case PoiCategory.restaurant:
        return 'restaurant';
      case PoiCategory.pureVeg:
        return 'pure_veg';
      case PoiCategory.washroom:
        return 'washroom';
      case PoiCategory.atm:
        return 'atm';
      case PoiCategory.hotel:
        return 'hotel';
      case PoiCategory.medical:
        return 'medical';
      case PoiCategory.scenic:
        return 'scenic';
      case PoiCategory.temple:
        return 'temple';
      case PoiCategory.kidsStop:
        return 'kids_stop';
      case PoiCategory.mechanic:
        return 'mechanic';
      case PoiCategory.parking:
        return 'parking';
      case PoiCategory.cafe:
        return 'cafe';
      case PoiCategory.tourist:
        return 'tourist';
      case PoiCategory.police:
        return 'police';
    }
  }
}

/// Where the POI record originated. Powers source badge UI in Phase 2.
enum PoiSource {
  @JsonValue('google_places')
  googlePlaces,
  @JsonValue('ocm')
  ocm,
  @JsonValue('community')
  community,
  @JsonValue('curated')
  curated,
  @JsonValue('unknown')
  unknown,
}

extension PoiSourceX on PoiSource {
  String get label {
    switch (this) {
      case PoiSource.googlePlaces:
        return 'Official';
      case PoiSource.ocm:
        return 'Official';
      case PoiSource.community:
        return 'Community-verified';
      case PoiSource.curated:
        return 'Curated';
      case PoiSource.unknown:
        return 'Unverified';
    }
  }
}

/// Generic point-of-interest covering every category in the Smart Intelligence Grid.
/// `attributes` is a free-form map for category-specific facets (e.g. fuel brand,
/// charging connector, dietary flag) so the schema can evolve without churn.
@freezed
abstract class Poi with _$Poi {
  const Poi._();

  const factory Poi({
    required String id,
    required String name,
    required PoiCategory category,
    required double latitude,
    required double longitude,
    String? address,
    @Default(PoiSource.unknown) PoiSource source,
    @Default(0) double rating,
    @Default(0) int reviewCount,
    bool? openNow,
    int? priceLevel,
    @Default(<String>[]) List<String> photos,
    @Default(<String, dynamic>{}) Map<String, dynamic> attributes,
    /// Distance along the active route polyline, when the POI was fetched as
    /// route-aware. Null for radial / nearby queries.
    double? distanceAlongRouteKm,
  }) = _Poi;

  factory Poi.fromJson(Map<String, dynamic> json) => _$PoiFromJson(json);
}
