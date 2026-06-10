import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/trip/domain/models/trip.dart';

/// P3-004 — Compact snapshot of the current trip state sent with every AI
/// call so the model can ground its answers in real user context.
class TripContextPacket {
  const TripContextPacket({
    required this.from,
    required this.to,
    required this.totalDistanceKm,
    required this.etaMinutes,
    required this.vehicleType,
    required this.isEv,
    required this.preferencesDigest,
    required this.recentAlerts,
    this.encodedRoutePolyline,
    this.tripStatus,
  });

  final String from;
  final String to;
  final double totalDistanceKm;
  final int etaMinutes;
  final String vehicleType;
  final bool isEv;

  /// Sparse map — only non-default preference flags are included to save tokens.
  final Map<String, dynamic> preferencesDigest;

  /// Last 5 fired alerts on this trip.
  final List<Map<String, dynamic>> recentAlerts;

  /// Google-encoded overview polyline when available (enables server-side
  /// corridor-proximity queries for "stops near my route").
  final String? encodedRoutePolyline;

  /// `'ready'` | `'running'` | `'paused'` | `'completed'`
  final String? tripStatus;

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'distanceKm': totalDistanceKm.round(),
        'etaMinutes': etaMinutes,
        'vehicle': vehicleType,
        'isEv': isEv,
        if (preferencesDigest.isNotEmpty) 'prefs': preferencesDigest,
        if (recentAlerts.isNotEmpty) 'alerts': recentAlerts,
        if (encodedRoutePolyline != null) 'polyline': encodedRoutePolyline,
        if (tripStatus != null) 'status': tripStatus,
      };
}

class TripContextPacker {
  const TripContextPacker._();

  /// Builds a [TripContextPacket] from an active [Trip] + current [prefs].
  static TripContextPacket pack({
    required Trip trip,
    required UserPreferences prefs,
  }) =>
      TripContextPacket(
        from: trip.from,
        to: trip.to,
        totalDistanceKm: trip.totalDistanceKm,
        etaMinutes: trip.etaMinutes ?? trip.drivingMinutes,
        vehicleType: trip.vehicle.type.name,
        isEv: trip.vehicle.type == VehicleType.ev,
        preferencesDigest: _packPrefs(prefs),
        recentAlerts: _packAlerts(trip.firedAlerts),
        tripStatus: trip.status.name,
      );

  /// Builds a packet from plan-level data before a trip has started.
  static TripContextPacket fromPlan({
    required String from,
    required String to,
    required double distanceKm,
    required int durationMinutes,
    required Vehicle vehicle,
    required UserPreferences prefs,
    String? encodedPolyline,
    List<Alert> alerts = const [],
  }) =>
      TripContextPacket(
        from: from,
        to: to,
        totalDistanceKm: distanceKm,
        etaMinutes: durationMinutes,
        vehicleType: vehicle.type.name,
        isEv: vehicle.type == VehicleType.ev,
        preferencesDigest: _packPrefs(prefs),
        recentAlerts: _packAlerts(alerts),
        encodedRoutePolyline: encodedPolyline,
      );

  static Map<String, dynamic> _packPrefs(UserPreferences p) => {
        if (p.pureVeg) 'pureVeg': true,
        if (p.familyMode) 'familyMode': true,
        if (p.womenSafe) 'womenSafe': true,
        if (p.fastChargersOnly) 'fastChargersOnly': true,
        if (p.petFriendly) 'petFriendly': true,
        if (p.nightSafe) 'nightSafe': true,
        if (p.scenicRoute) 'scenicRoute': true,
        'budget': p.budgetTier.name,
        if (p.preferredFuelBrands.isNotEmpty) 'fuelBrands': p.preferredFuelBrands,
      };

  static List<Map<String, dynamic>> _packAlerts(List<Alert> alerts) =>
      alerts
          .take(5)
          .map((a) => {
                'type': a.type.name,
                'severity': a.severity.name,
                'message': a.message,
              })
          .toList();
}
