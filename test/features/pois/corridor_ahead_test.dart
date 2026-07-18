import 'package:flutter_test/flutter_test.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/domain/trip_position.dart';
import 'package:journeyplus/core/utils/corridor_ahead.dart';

void main() {
  group('CorridorAhead', () {
    Poi poi(String id, double? km) => Poi(
          id: id,
          name: id,
          category: PoiCategory.fuel,
          latitude: 18.5,
          longitude: 73.8,
          source: PoiSource.googlePlaces,
          rating: 0,
          reviewCount: 0,
          photos: const [],
          distanceAlongRouteKm: km,
        );

    test('keeps edge items within hysteresis and drops unknown distance', () {
      final ahead = CorridorAhead.filterPois([
        poi('behind', 49.5),
        poi('edge', 49.8),
        poi('near', 55),
        poi('unknown', null),
        poi('far', 80),
      ], 50);

      expect(ahead.map((p) => p.id), ['edge', 'near', 'far']);
    });

    test('excludes stops more than hysteresis behind currentKm', () {
      final ahead = CorridorAhead.filterPois([
        poi('passed', 49.6),
        poi('still', 50.1),
      ], 50);

      expect(ahead.map((p) => p.id), ['still']);
    });

    test('empty ahead when all stops are behind', () {
      final ahead = CorridorAhead.filterPois([
        poi('a', 10),
        poi('b', 20),
      ], 50);
      expect(ahead, isEmpty);
    });
  });

  group('TripPosition.isStale', () {
    test('fresh fix is not stale', () {
      final pos = TripPosition(
        latitude: 18.5,
        longitude: 73.8,
        accuracyMeters: 10,
        capturedAt: DateTime.now().toUtc(),
      );
      expect(pos.isStale(), isFalse);
    });

    test('old fix is stale', () {
      final pos = TripPosition(
        latitude: 18.5,
        longitude: 73.8,
        accuracyMeters: 10,
        capturedAt:
            DateTime.now().toUtc().subtract(const Duration(seconds: 90)),
      );
      expect(pos.isStale(maxAge: const Duration(seconds: 60)), isTrue);
    });
  });
}
