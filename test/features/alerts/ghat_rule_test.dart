import 'package:flutter_test/flutter_test.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine_input.dart';

void main() {
  group('GhatRule fixture (HA-042)', () {
    test('fires when polyline passes through Bhor / Khandala ghat corridor', () {
      // Approach from SE, then through the Bhor centre, then NW.
      final route = RouteInfo(
        origin: const LatLng(18.70, 73.45),
        destination: const LatLng(18.82, 73.30),
        distanceKm: 30,
        durationMinutes: 45,
        polylinePoints: const [
          LatLng(18.70, 73.45),
          LatLng(18.7558, 73.3739),
          LatLng(18.82, 73.30),
        ],
      );

      final alerts = AlertEngine().evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: const LatLng(18.70, 73.45),
          vehicle: const Vehicle(type: VehicleType.petrol),
          preferences: const UserPreferences(),
          upcomingPois: const {},
          currentDistanceAlongRouteKm: 0,
          evaluatedAt: DateTime(2026, 5, 30, 12),
        ),
      );

      expect(alerts.any((a) => a.type == AlertType.ghat), isTrue);
      final ghat = alerts.firstWhere((a) => a.type == AlertType.ghat);
      // Bhor and Khandala centres are adjacent — either match proves the rule.
      expect(
        ghat.message.contains('Bhor Ghat') ||
            ghat.message.contains('Khandala Ghat'),
        isTrue,
        reason: ghat.message,
      );
      expect(ghat.severity, AlertSeverity.warning);
    });

    test('silent when route never approaches a known ghat', () {
      final route = RouteInfo(
        origin: const LatLng(18.5, 73.8),
        destination: const LatLng(18.6, 73.9),
        distanceKm: 20,
        durationMinutes: 30,
        polylinePoints: const [
          LatLng(18.5, 73.8),
          LatLng(18.55, 73.85),
          LatLng(18.6, 73.9),
        ],
      );

      final alerts = AlertEngine().evaluate(
        AlertEngineInput(
          activeRoute: route,
          currentLocation: const LatLng(18.5, 73.8),
          vehicle: const Vehicle(type: VehicleType.petrol),
          preferences: const UserPreferences(),
          upcomingPois: const {},
          currentDistanceAlongRouteKm: 0,
          evaluatedAt: DateTime(2026, 5, 30, 12),
        ),
      );

      expect(alerts.where((a) => a.type == AlertType.ghat), isEmpty);
    });
  });
}
