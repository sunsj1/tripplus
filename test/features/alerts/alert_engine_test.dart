import 'package:flutter_test/flutter_test.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';

void main() {
  final route = RouteInfo(
    origin: const LatLng(18.5, 73.8),
    destination: const LatLng(19.5, 74.8),
    distanceKm: 120,
    durationMinutes: 90,
    polylinePoints: [
      const LatLng(18.5, 73.8),
      const LatLng(19.0, 74.3),
      const LatLng(19.5, 74.8),
    ],
  );

  const current = LatLng(18.5, 73.8);

  group('AlertEngine', () {
    test('fuel low fires when next trusted pump is beyond 40 km', () {
      final engine = AlertEngine();
      final alerts = engine.evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: current,
          vehicle: const Vehicle(type: VehicleType.petrol),
          preferences: const UserPreferences(),
          upcomingPois: {
            PoiCategory.fuel: [
              _poi(
                id: 'f1',
                category: PoiCategory.fuel,
                distanceKm: 55,
                rating: 4.2,
                reviewCount: 10,
              ),
            ],
          },
          currentDistanceAlongRouteKm: 0,
          evaluatedAt: DateTime(2026, 5, 30),
        ),
      );

      expect(alerts.length, 1);
      expect(alerts.first.type, AlertType.fuelLow);
      expect(alerts.first.distanceKm, 55);
      expect(alerts.first.message, contains('trusted fuel'));
    });

    test('fuel low does not fire for EV', () {
      final engine = AlertEngine();
      final alerts = engine.evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: current,
          vehicle: const Vehicle(type: VehicleType.ev),
          preferences: const UserPreferences(),
          upcomingPois: {
            PoiCategory.fuel: [
              _poi(
                id: 'f1',
                category: PoiCategory.fuel,
                distanceKm: 80,
              ),
            ],
          },
          currentDistanceAlongRouteKm: 0,
        ),
      );

      expect(alerts.where((a) => a.type == AlertType.fuelLow), isEmpty);
    });

    test('ev gap fires when next charger is beyond 40 km', () {
      final engine = AlertEngine();
      final alerts = engine.evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: current,
          vehicle: const Vehicle(type: VehicleType.ev),
          preferences: const UserPreferences(),
          upcomingPois: {
            PoiCategory.ev: [
              _poi(
                id: 'e1',
                name: 'Highway Fast Charge',
                category: PoiCategory.ev,
                distanceKm: 65,
                attributes: {
                  'connections': [
                    {'isFast': true, 'powerKw': 120},
                  ],
                },
              ),
            ],
          },
          currentDistanceAlongRouteKm: 0,
        ),
      );

      expect(alerts.any((a) => a.type == AlertType.evGap), isTrue);
      final ev = alerts.firstWhere((a) => a.type == AlertType.evGap);
      expect(ev.message.toLowerCase(), contains('charger'));
    });

    test('food window honors pureVeg category', () {
      final engine = AlertEngine();
      final alerts = engine.evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: current,
          vehicle: const Vehicle(type: VehicleType.petrol),
          preferences: const UserPreferences(pureVeg: true),
          upcomingPois: {
            PoiCategory.pureVeg: [
              _poi(
                id: 'v1',
                name: 'Shree Veg Dhaba',
                category: PoiCategory.pureVeg,
                distanceKm: 60,
                rating: 4.5,
                reviewCount: 20,
              ),
            ],
            PoiCategory.restaurant: [
              _poi(
                id: 'r1',
                name: 'Non Veg Hotel',
                category: PoiCategory.restaurant,
                distanceKm: 30,
                rating: 4.8,
                reviewCount: 100,
              ),
            ],
          },
          currentDistanceAlongRouteKm: 0,
        ),
      );

      final food = alerts.firstWhere((a) => a.type == AlertType.foodWindow);
      expect(food.message.toLowerCase(), contains('veg'));
      expect(food.message, contains('Shree Veg Dhaba'));
    });
  });
}

Poi _poi({
  required String id,
  required PoiCategory category,
  required double distanceKm,
  String name = 'Test POI',
  double rating = 0,
  int reviewCount = 0,
  Map<String, dynamic> attributes = const {},
}) {
  return Poi(
    id: id,
    name: name,
    category: category,
    latitude: 18.5 + distanceKm * 0.01,
    longitude: 73.8,
    rating: rating,
    reviewCount: reviewCount,
    distanceAlongRouteKm: distanceKm,
    attributes: attributes,
  );
}
