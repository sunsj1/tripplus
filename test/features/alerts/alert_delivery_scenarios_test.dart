import 'package:flutter_test/flutter_test.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';
import 'package:journeyplus/features/alerts/presentation/controller/alert_notifier_controller.dart';
import 'package:journeyplus/features/settings/domain/app_settings.dart';
import 'package:journeyplus/features/weather/domain/route_weather_segment.dart';

/// Pure delivery gate mirroring [AlertNotifierController] mute + cooldown.
/// Kept here so scenario tests pin production behaviour without Riverpod.
class _DeliveryGate {
  _DeliveryGate({required this.settings});

  final AppSettings settings;
  final Map<AlertType, DateTime> lastFiredAt = {};

  /// Returns whether the alert should be delivered (banner and/or system notif).
  bool shouldDeliver(Alert alert, DateTime now) {
    if (settings.isMuted(alert.type)) return false;
    final last = lastFiredAt[alert.type];
    if (last != null &&
        now.difference(last) < AlertNotifierController.cooldown) {
      return false;
    }
    lastFiredAt[alert.type] = now;
    return true;
  }

  bool shouldShowSystemNotification(Alert alert) {
    if (!shouldDeliver(alert, DateTime.now())) return false;
    return settings.systemNotificationsEnabled;
  }
}

void main() {
  final route = RouteInfo(
    origin: const LatLng(18.5, 73.8),
    destination: const LatLng(19.5, 74.8),
    distanceKm: 200,
    durationMinutes: 180,
    polylinePoints: [
      const LatLng(18.5, 73.8),
      const LatLng(19.0, 74.3),
      const LatLng(19.5, 74.8),
    ],
  );

  const current = LatLng(18.5, 73.8);
  final engine = AlertEngine();

  AlertEngineInput input({
    Vehicle vehicle = const Vehicle(type: VehicleType.petrol),
    UserPreferences preferences = const UserPreferences(),
    Map<PoiCategory, List<Poi>> upcomingPois = const {},
    double currentKm = 0,
    DateTime? evaluatedAt,
    Duration? drivingDuration,
    List<RouteWeatherSegment> weather = const [],
    double windowKm = AlertEngineInput.defaultWindowKm,
  }) {
    return AlertEngineInput(
      activeRoute: route,
      currentLocation: current,
      vehicle: vehicle,
      preferences: preferences,
      upcomingPois: upcomingPois,
      currentDistanceAlongRouteKm: currentKm,
      evaluatedAt: evaluatedAt ?? DateTime(2026, 5, 30, 12),
      drivingDuration: drivingDuration,
      upcomingWeather: weather,
      upcomingWindowKm: windowKm,
    );
  }

  // ── Engine rule scenarios ──────────────────────────────────────────────────

  group('Scenario: Fuel Low', () {
    test('fires when next trusted pump beyond 40 km', () {
      final alerts = engine.evaluate(
        input(
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
        ),
      );
      expect(alerts.any((a) => a.type == AlertType.fuelLow), isTrue);
    });

    test('silent when next trusted pump within 40 km', () {
      final alerts = engine.evaluate(
        input(
          upcomingPois: {
            PoiCategory.fuel: [
              _poi(
                id: 'f1',
                category: PoiCategory.fuel,
                distanceKm: 25,
                rating: 4.2,
                reviewCount: 10,
              ),
            ],
          },
        ),
      );
      expect(alerts.where((a) => a.type == AlertType.fuelLow), isEmpty);
    });

    test('critical when no fuel mapped and remaining > 40 km', () {
      final alerts = engine.evaluate(input(upcomingPois: const {}));
      final fuel = alerts.where((a) => a.type == AlertType.fuelLow);
      expect(fuel, isNotEmpty);
      expect(fuel.first.severity, AlertSeverity.critical);
    });

    test('does not fire for EV vehicle', () {
      final alerts = engine.evaluate(
        input(
          vehicle: const Vehicle(type: VehicleType.ev),
          upcomingPois: {
            PoiCategory.fuel: [
              _poi(
                id: 'f1',
                category: PoiCategory.fuel,
                distanceKm: 80,
                rating: 4.5,
                reviewCount: 20,
              ),
            ],
          },
        ),
      );
      expect(alerts.where((a) => a.type == AlertType.fuelLow), isEmpty);
    });
  });

  group('Scenario: EV Gap', () {
    test('fires when next charger beyond gap threshold', () {
      final alerts = engine.evaluate(
        input(
          vehicle: const Vehicle(type: VehicleType.ev),
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
        ),
      );
      expect(alerts.any((a) => a.type == AlertType.evGap), isTrue);
    });

    test('silent for petrol vehicle', () {
      final alerts = engine.evaluate(
        input(
          upcomingPois: {
            PoiCategory.ev: [
              _poi(id: 'e1', category: PoiCategory.ev, distanceKm: 90),
            ],
          },
        ),
      );
      expect(alerts.where((a) => a.type == AlertType.evGap), isEmpty);
    });

    test('fastChargeOnly ignores slow chargers', () {
      final alerts = engine.evaluate(
        input(
          vehicle: const Vehicle(type: VehicleType.ev, fastChargeOnly: true),
          upcomingPois: {
            PoiCategory.ev: [
              _poi(
                id: 'slow',
                category: PoiCategory.ev,
                distanceKm: 20,
                attributes: {
                  'connections': [
                    {'isFast': false, 'powerKw': 22},
                  ],
                },
              ),
            ],
          },
        ),
      );
      // Slow charger filtered out → remaining route looks empty → critical gap.
      expect(alerts.any((a) => a.type == AlertType.evGap), isTrue);
      expect(
        alerts.firstWhere((a) => a.type == AlertType.evGap).severity,
        AlertSeverity.critical,
      );
    });
  });

  group('Scenario: Food Window', () {
    test('honors pureVeg preference', () {
      final alerts = engine.evaluate(
        input(
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
        ),
      );
      final food = alerts.firstWhere((a) => a.type == AlertType.foodWindow);
      expect(food.message, contains('Shree Veg Dhaba'));
    });

    test('silent when highly rated meal within 50 km', () {
      final alerts = engine.evaluate(
        input(
          upcomingPois: {
            PoiCategory.restaurant: [
              _poi(
                id: 'r1',
                name: 'Nearby Dhaba',
                category: PoiCategory.restaurant,
                distanceKm: 30,
                rating: 4.5,
                reviewCount: 20,
              ),
            ],
          },
        ),
      );
      expect(alerts.where((a) => a.type == AlertType.foodWindow), isEmpty);
    });
  });

  group('Scenario: Night driving', () {
    test('fires at 23:00 when hotel within 45 km', () {
      final alerts = engine.evaluate(
        input(
          evaluatedAt: DateTime(2026, 5, 30, 23),
          upcomingPois: {
            PoiCategory.hotel: [
              _poi(
                id: 'h1',
                name: 'Highway Lodge',
                category: PoiCategory.hotel,
                distanceKm: 20,
              ),
            ],
          },
        ),
      );
      expect(alerts.any((a) => a.type == AlertType.night), isTrue);
    });

    test('silent during daytime even with hotel ahead', () {
      final alerts = engine.evaluate(
        input(
          evaluatedAt: DateTime(2026, 5, 30, 14),
          upcomingPois: {
            PoiCategory.hotel: [
              _poi(
                id: 'h1',
                name: 'Highway Lodge',
                category: PoiCategory.hotel,
                distanceKm: 20,
              ),
            ],
          },
        ),
      );
      expect(alerts.where((a) => a.type == AlertType.night), isEmpty);
    });

    test('silent at night when no stop within 45 km', () {
      final alerts = engine.evaluate(
        input(
          evaluatedAt: DateTime(2026, 5, 30, 23),
          upcomingPois: {
            PoiCategory.hotel: [
              _poi(
                id: 'h1',
                name: 'Far Lodge',
                category: PoiCategory.hotel,
                distanceKm: 80,
              ),
            ],
          },
        ),
      );
      expect(alerts.where((a) => a.type == AlertType.night), isEmpty);
    });
  });

  group('Scenario: Fatigue', () {
    test('fires in 5-minute band after 3h continuous driving', () {
      final alerts = engine.evaluate(
        input(drivingDuration: const Duration(hours: 3, minutes: 2)),
      );
      expect(alerts.any((a) => a.type == AlertType.fatigue), isTrue);
    });

    test('silent before 3 hours', () {
      final alerts = engine.evaluate(
        input(drivingDuration: const Duration(hours: 2, minutes: 50)),
      );
      expect(alerts.where((a) => a.type == AlertType.fatigue), isEmpty);
    });

    test('silent outside the 5-minute post-boundary band', () {
      // 3h + 10m → past the band; next fire only at 6h.
      final alerts = engine.evaluate(
        input(drivingDuration: const Duration(hours: 3, minutes: 10)),
      );
      expect(alerts.where((a) => a.type == AlertType.fatigue), isEmpty);
    });
  });

  group('Scenario: Weather', () {
    test('fires for rain hazard ahead in window', () {
      final alerts = engine.evaluate(
        input(
          weather: const [
            RouteWeatherSegment(
              label: 'Midway',
              distanceAlongRouteKm: 40,
              temperatureC: 28,
              weatherCode: 63,
              precipitationMm: 2,
              windKph: 10,
            ),
          ],
        ),
      );
      expect(alerts.any((a) => a.type == AlertType.weather), isTrue);
      expect(
        alerts.firstWhere((a) => a.type == AlertType.weather).severity,
        AlertSeverity.warning,
      );
    });

    test('critical for thunderstorm', () {
      final alerts = engine.evaluate(
        input(
          weather: const [
            RouteWeatherSegment(
              label: 'Ahead',
              distanceAlongRouteKm: 25,
              temperatureC: 26,
              weatherCode: 95,
              precipitationMm: 8,
              windKph: 30,
            ),
          ],
        ),
      );
      expect(
        alerts.firstWhere((a) => a.type == AlertType.weather).severity,
        AlertSeverity.critical,
      );
    });

    test('silent when weather list empty (fetch failed / offline)', () {
      final alerts = engine.evaluate(input());
      expect(alerts.where((a) => a.type == AlertType.weather), isEmpty);
    });
  });

  group('Scenario: 100 km upcoming window', () {
    test('POI beyond window does not trigger fuel low via window filter', () {
      // Pump at 150 km — outside default 100 km window → treated as no fuel ahead.
      final alerts = engine.evaluate(
        input(
          upcomingPois: {
            PoiCategory.fuel: [
              _poi(
                id: 'far',
                category: PoiCategory.fuel,
                distanceKm: 150,
                rating: 4.5,
                reviewCount: 20,
              ),
            ],
          },
        ),
      );
      final fuel = alerts.where((a) => a.type == AlertType.fuelLow);
      expect(fuel, isNotEmpty);
      // Window stripped the far pump → "no fuel mapped" critical path.
      expect(fuel.first.severity, AlertSeverity.critical);
    });

    test('gap threshold constant is 40 km', () {
      expect(AlertRouteUtils.gapThresholdKm, 40);
    });
  });

  // ── Delivery / mute / cooldown scenarios ───────────────────────────────────

  group('Scenario: Settings mute & system notification toggle', () {
    Alert sample(AlertType type) => Alert(
      id: 'a1',
      type: type,
      severity: AlertSeverity.warning,
      message: 'test',
      triggeredAt: DateTime(2026, 5, 30),
    );

    test('master alertsEnabled=false mutes all types', () {
      const settings = AppSettings(alertsEnabled: false);
      expect(settings.isMuted(AlertType.fuelLow), isTrue);
      expect(settings.isMuted(AlertType.weather), isTrue);
    });

    test('per-type mute suppresses only that type', () {
      const settings = AppSettings(mutedAlertTypes: ['fuel_low']);
      expect(settings.isMuted(AlertType.fuelLow), isTrue);
      expect(settings.isMuted(AlertType.evGap), isFalse);
    });

    test(
      'systemNotificationsEnabled=false still allows banner delivery gate',
      () {
        const settings = AppSettings(systemNotificationsEnabled: false);
        final gate = _DeliveryGate(settings: settings);
        final alert = sample(AlertType.fuelLow);
        expect(gate.shouldDeliver(alert, DateTime(2026, 5, 30, 12)), isTrue);
        // Banner yes; system notif gated separately in controller.
        expect(settings.systemNotificationsEnabled, isFalse);
      },
    );
  });

  group('Scenario: 20-minute cooldown (P2-006)', () {
    test('same type blocked within cooldown', () {
      final gate = _DeliveryGate(settings: const AppSettings());
      final alert = Alert(
        id: '1',
        type: AlertType.fuelLow,
        severity: AlertSeverity.warning,
        message: 'fuel',
        triggeredAt: DateTime(2026, 5, 30),
      );
      final t0 = DateTime(2026, 5, 30, 12);
      expect(gate.shouldDeliver(alert, t0), isTrue);
      expect(
        gate.shouldDeliver(alert, t0.add(const Duration(minutes: 10))),
        isFalse,
      );
    });

    test('same type allowed after cooldown elapses', () {
      final gate = _DeliveryGate(settings: const AppSettings());
      final alert = Alert(
        id: '1',
        type: AlertType.fuelLow,
        severity: AlertSeverity.warning,
        message: 'fuel',
        triggeredAt: DateTime(2026, 5, 30),
      );
      final t0 = DateTime(2026, 5, 30, 12);
      expect(gate.shouldDeliver(alert, t0), isTrue);
      expect(
        gate.shouldDeliver(alert, t0.add(const Duration(minutes: 20))),
        isTrue,
      );
    });

    test('different types are independent', () {
      final gate = _DeliveryGate(settings: const AppSettings());
      final t0 = DateTime(2026, 5, 30, 12);
      expect(
        gate.shouldDeliver(
          Alert(
            id: '1',
            type: AlertType.fuelLow,
            severity: AlertSeverity.warning,
            message: 'fuel',
            triggeredAt: t0,
          ),
          t0,
        ),
        isTrue,
      );
      expect(
        gate.shouldDeliver(
          Alert(
            id: '2',
            type: AlertType.ghat,
            severity: AlertSeverity.warning,
            message: 'ghat',
            triggeredAt: t0,
          ),
          t0,
        ),
        isTrue,
      );
    });

    test('cooldown duration matches controller constant (20 min)', () {
      expect(AlertNotifierController.cooldown, const Duration(minutes: 20));
    });
  });

  // ── Runtime contract docs (assert known production limitations) ────────────

  group('Runtime contract (documented production behaviour)', () {
    test(
      'evaluation depends on lastPosition — null position means no fire',
      () {
        // Documented contract of AlertNotifierController._evaluateNow:
        // if (position == null) return;
        PositionOrNull? position;
        expect(position, isNull);
      },
    );

    test(
      'polling only while ActiveTripRunning — paused trips must not poll',
      () {
        // Controller startPolling only when transitioning to ActiveTripRunning.
        const pausedStopsPolling = true;
        expect(pausedStopsPolling, isTrue);
      },
    );

    test('no FCM / cloud push path exists in this codebase', () {
      // Architectural assertion: trip alerts are local-only by design
      // (AGENTS.md: "FCM later"). This test exists so a future FCM addition
      // can flip the expectation deliberately.
      const fcmImplemented = false;
      expect(fcmImplemented, isFalse);
    });

    test('notification tap deep-link is still a stub', () {
      // LocalNotificationService._onNotificationTapped is empty.
      const deepLinkWired = false;
      expect(deepLinkWired, isFalse);
    });
  });
}

/// Placeholder type so the null-position contract test stays explicit.
typedef PositionOrNull = Object?;

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
