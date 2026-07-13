import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/services/route_station_service.dart';
import 'package:journeyplus/core/utils/result.dart';
import 'package:journeyplus/core/utils/trip_plan_copy.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/tolls/domain/toll_estimator.dart';

// Petrol/diesel price per litre (₹) — rough Indian highway average.
const _petrolPricePerLitre = 103.0;
const _dieselPricePerLitre = 90.0;
// Charging cost per stop (₹) — rough mid-range DC fast-charge estimate.
const _chargingCostPerStop = 250.0;
// Time added per charging stop for an EV (minutes).
const _chargingMinutesPerStop = 30;
// Time added for petrol/diesel/bike fill-up stop (minutes).
const _fuelStopMinutes = 15;

class PlanController extends StateNotifier<PlanState> {
  final RouteStationService _routeService;
  final DirectionsService _directions;
  final _logger = Logger();

  PlanController({
    required RouteStationService routeService,
    required DirectionsService directions,
  })  : _routeService = routeService,
        _directions = directions,
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

    switch (result) {
      case Success(:final data):
        final analysis = data;
        if (isEv && analysis.stations.isEmpty) {
          state = PlanState.empty(from: from, to: to, vehicleType: vehicleType);
          return;
        }

        final distKm = analysis.route.distanceKm;
        final driveMins = analysis.route.durationMinutes;
        final driveMinsForEta = analysis.route.effectiveDurationMinutes;
        final stationCount = analysis.stations.length;
        final isBike = vehicle?.type == VehicleType.bike;

        final stopMins = isEv
            ? stationCount * _chargingMinutesPerStop
            : _fuelStopMinutes;
        final etaMins = driveMinsForEta + stopMins;

        double? tollsEst;
        String? tollCorridorName;
        var noTollsOnRoute = false;
        if (!isBike) {
          final tollOutcome = await _resolveTollEstimate(analysis.route);
          tollsEst = tollOutcome.amount;
          tollCorridorName = tollOutcome.sourceLabel;
          noTollsOnRoute = tollOutcome.noTollsOnRoute;
        }

        double? fuelEst;
        double? fuelEfficiencyUsed;
        if (!isEv && vehicle != null) {
          fuelEfficiencyUsed = vehicle.effectiveFuelEfficiencyKmpl;
          final pricePerLitre = vehicle.type == VehicleType.diesel
              ? _dieselPricePerLitre
              : _petrolPricePerLitre;
          fuelEst = (distKm / fuelEfficiencyUsed) * pricePerLitre;
        }

        final chargingEst = isEv ? stationCount * _chargingCostPerStop : null;

        final liveTrafficMins = analysis.route.durationInTrafficMinutes;
        double ratio;
        if (liveTrafficMins != null && driveMins > 0) {
          ratio = liveTrafficMins / driveMins;
        } else {
          final theoreticalMins = (distKm / 80.0) * 60;
          ratio = driveMins / theoreticalMins;
        }
        final trafficLevel = ratio >= 1.4
            ? 'High'
            : ratio >= 1.15
                ? 'Moderate'
                : 'Low';

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
          tollCorridorName: tollCorridorName,
          noTollsOnRoute: noTollsOnRoute,
          fuelEfficiencyKmpl: fuelEfficiencyUsed,
        );
      case Failure(:final message):
        state = PlanState.error(message);
    }
  }

  Future<_TollOutcome> _resolveTollEstimate(RouteInfo route) async {
    final googleToll = await _directions.getRouteTollInfo(
      route.origin,
      route.destination,
    );

    if (googleToll?.estimatedRupees != null && googleToll!.estimatedRupees! > 0) {
      return _TollOutcome(
        amount: googleToll.estimatedRupees,
        sourceLabel: 'Google Maps estimate',
      );
    }

    final corridor = const TollEstimator().estimate(
      polylinePoints: route.polylinePoints,
      totalDistanceKm: route.distanceKm,
    );
    if (corridor.isCorridorMatch && corridor.totalRupees != null) {
      return _TollOutcome(
        amount: corridor.totalRupees,
        sourceLabel: corridor.matchedCorridor,
      );
    }

    if (googleToll?.detected == true) {
      return const _TollOutcome(
        sourceLabel: 'Tolls likely on route',
      );
    }

    return const _TollOutcome(noTollsOnRoute: true);
  }

  void reset() => state = const PlanState.idle();
}

class _TollOutcome {
  const _TollOutcome({
    this.amount,
    this.sourceLabel,
    this.noTollsOnRoute = false,
  });

  final double? amount;
  final String? sourceLabel;
  final bool noTollsOnRoute;
}
