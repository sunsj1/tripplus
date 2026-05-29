import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/core/utils/trip_plan_copy.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';

// Petrol/diesel price per litre (₹) — rough Indian highway average.
const _petrolPricePerLitre = 103.0;
const _dieselPricePerLitre = 90.0;
// Toll cost per km on national highways (₹).
const _tollPerKm = 1.5;
// Charging cost per stop (₹) — rough mid-range DC fast-charge estimate.
const _chargingCostPerStop = 250.0;
// Time added per charging stop for an EV (minutes).
const _chargingMinutesPerStop = 30;
// Time added for petrol/diesel/bike fill-up stop (minutes).
const _fuelStopMinutes = 15;

class PlanController extends StateNotifier<PlanState> {
  final RouteStationService _routeService;
  final _logger = Logger();

  PlanController({required RouteStationService routeService})
      : _routeService = routeService,
        super(const PlanState.idle());

  Future<void> analyzeRoute({
    required String from,
    required String to,
    Vehicle? vehicle,
    UserPreferences? tripPreferences,
  }) async {
    final vehicleType = vehicle?.type;
    final isEv = TripPlanCopy.isEv(vehicleType);

    state = PlanState.calculating(from: from, to: to, vehicleType: vehicleType);

    _logger.i('Analyzing route: "$from" → "$to" | vehicle: $vehicleType');

    final result = await _routeService.analyzeRoute(
      from: from,
      to: to,
      includeEvStations: isEv,
    );

    result.when(
      success: (analysis) {
        if (isEv && analysis.stations.isEmpty) {
          state = PlanState.empty(from: from, to: to, vehicleType: vehicleType);
        } else {
          final distKm = analysis.route.distanceKm;
          final driveMins = analysis.route.durationMinutes;
          final stationCount = analysis.stations.length;

          // --- P1-018: compute estimates -----------------------------------------
          final isBike = vehicle?.type == VehicleType.bike;

          // ETA: driving time + stop time
          final stopMins = isEv
              ? stationCount * _chargingMinutesPerStop
              : _fuelStopMinutes; // one fuel stop assumed for ICE
          final etaMins = driveMins + stopMins;

          // Toll (₹) — not applicable for bikes
          final tollsEst = isBike ? null : distKm * _tollPerKm;

          // Fuel cost (₹) — only for ICE vehicles
          double? fuelEst;
          if (!isEv && vehicle != null) {
            final efficiency = vehicle.fuelEfficiencyKmpl ?? 15.0;
            final pricePerLitre = vehicle.type == VehicleType.diesel
                ? _dieselPricePerLitre
                : _petrolPricePerLitre;
            fuelEst = (distKm / efficiency) * pricePerLitre;
          }

          // Charging cost (₹) — only for EVs
          final chargingEst =
              isEv ? stationCount * _chargingCostPerStop : null;

          // Traffic level derived from duration vs. theoretical 80 km/h speed
          final theoreticalMins = (distKm / 80.0) * 60;
          final ratio = driveMins / theoreticalMins;
          final trafficLevel = ratio >= 1.5
              ? 'High'
              : ratio >= 1.2
                  ? 'Moderate'
                  : 'Low';
          // -----------------------------------------------------------------------

          state = PlanState.result(
            from: from,
            to: to,
            stations: isEv ? analysis.stations : const [],
            vehicleType: vehicleType,
            tripPreferences: tripPreferences,
            totalDistanceKm: distKm,
            durationMinutes: driveMins,
            gaps: isEv ? analysis.gaps : const [],
            etaMinutes: etaMins,
            tollsEstimate: tollsEst,
            fuelEstimateCost: fuelEst,
            chargingEstimate: chargingEst,
            trafficLevel: trafficLevel,
            encodedRoutePolyline: analysis.route.encodedPolyline,
          );
        }
      },
      failure: (message) {
        state = PlanState.error(message);
      },
    );
  }

  void reset() => state = const PlanState.idle();
}
