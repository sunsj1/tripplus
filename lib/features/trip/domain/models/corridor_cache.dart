/// P1-043 — Corridor cache model.
///
/// A snapshot of all data needed to navigate the trip offline:
/// the encoded route polyline, station IDs, and the timestamp so stale
/// caches can be evicted.
///
/// Deliberately a plain Dart class (no Freezed) — cached only in Hive and
/// never sent over the wire, so manual JSON serialisation is sufficient.
class CorridorCache {
  const CorridorCache({
    required this.tripId,
    required this.encodedPolyline,
    required this.stationIds,
    required this.totalDistanceKm,
    required this.cachedAt,
  });

  /// ID of the [Trip] this cache belongs to.
  final String tripId;

  /// Google-encoded polyline string for the full route.
  final String encodedPolyline;

  /// Stable IDs of charging/fuel stations along the corridor.
  final List<String> stationIds;

  /// Total route distance — used for offline range estimation.
  final double totalDistanceKm;

  /// When this cache was written; used to evict entries older than 24 h.
  final DateTime cachedAt;

  // ---------------------------------------------------------------------------
  // Staleness check
  // ---------------------------------------------------------------------------

  static const _maxAgeHours = 24;

  bool get isStale =>
      DateTime.now().difference(cachedAt).inHours >= _maxAgeHours;

  // ---------------------------------------------------------------------------
  // JSON serialisation
  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() => {
        'tripId': tripId,
        'encodedPolyline': encodedPolyline,
        'stationIds': stationIds,
        'totalDistanceKm': totalDistanceKm,
        'cachedAt': cachedAt.toIso8601String(),
      };

  factory CorridorCache.fromJson(Map<String, dynamic> json) => CorridorCache(
        tripId: json['tripId'] as String,
        encodedPolyline: json['encodedPolyline'] as String? ?? '',
        stationIds: (json['stationIds'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(),
        totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble() ?? 0.0,
        cachedAt: DateTime.parse(json['cachedAt'] as String),
      );
}
