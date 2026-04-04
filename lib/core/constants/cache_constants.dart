class CacheConstants {
  CacheConstants._();

  static const String chargingBoxName = 'charging_cache';

  static const String cacheKey = 'charging_stations';
  static const String latitudeKey = 'cached_latitude';
  static const String longitudeKey = 'cached_longitude';
  static const String timestampKey = 'cached_timestamp';

  static const Duration cacheExpiry = Duration(hours: 24);

  static const double cacheRadiusKm = 100;
}
