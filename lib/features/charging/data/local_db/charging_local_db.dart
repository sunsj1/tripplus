import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/constants/cache_constants.dart';
import 'package:tripplus/core/utils/location_helper.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';

class ChargingLocalDb {
  final Box _box;
  final _logger = Logger();

  ChargingLocalDb(this._box);

  Future<void> saveStations({
    required List<ChargingStation> stations,
    required double latitude,
    required double longitude,
  }) async {
    final jsonList = stations.map((s) => jsonEncode(s.toJson())).toList();
    await _box.put(CacheConstants.cacheKey, jsonList);
    await _box.put(CacheConstants.latitudeKey, latitude);
    await _box.put(CacheConstants.longitudeKey, longitude);
    await _box.put(
      CacheConstants.timestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    _logger.d('Saved ${stations.length} stations to cache');
  }

  List<ChargingStation>? getStations() {
    final jsonList = _box.get(CacheConstants.cacheKey) as List?;
    if (jsonList == null) return null;
    return jsonList
        .cast<String>()
        .map((s) => ChargingStation.fromJson(jsonDecode(s)))
        .toList();
  }

  bool isCacheValid(double currentLat, double currentLon) {
    final cachedLat = _box.get(CacheConstants.latitudeKey) as double?;
    final cachedLon = _box.get(CacheConstants.longitudeKey) as double?;
    final cachedTimestamp = _box.get(CacheConstants.timestampKey) as int?;

    if (cachedLat == null || cachedLon == null || cachedTimestamp == null) {
      _logger.d('Cache miss: no cached data');
      return false;
    }

    final cachedTime =
        DateTime.fromMillisecondsSinceEpoch(cachedTimestamp);
    final isExpired =
        DateTime.now().difference(cachedTime) > CacheConstants.cacheExpiry;
    if (isExpired) {
      _logger.d('Cache expired');
      return false;
    }

    final distance = LocationHelper.distanceInKm(
      currentLat,
      currentLon,
      cachedLat,
      cachedLon,
    );
    final isTooFar = distance > CacheConstants.cacheRadiusKm;
    if (isTooFar) {
      _logger.d('Cache invalid: moved ${distance.toStringAsFixed(1)} km');
      return false;
    }

    _logger.d('Cache hit: valid (${distance.toStringAsFixed(1)} km away)');
    return true;
  }

  Future<void> clearCache() async {
    await _box.clear();
    _logger.d('Cache cleared');
  }
}
