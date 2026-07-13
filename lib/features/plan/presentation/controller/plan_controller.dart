import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:journeyplus/core/domain/route_option.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/services/geocoding_service.dart';
import 'package:journeyplus/core/services/route_station_service.dart';
import 'package:journeyplus/core/utils/location_helper.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/core/utils/result.dart';
import 'package:journeyplus/core/utils/route_option_matcher.dart';
import 'package:journeyplus/core/utils/trip_plan_copy.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/tolls/domain/toll_estimator.dart';

// Petrol/diesel price per litre (₹) — rough Indian highway average.
const _petrolPricePerLitre = 103.0;
const _dieselPricePerLitre = 90.0;
const _chargingCostPerStop = 250.0;
const _chargingMinutesPerStop = 30;
const _fuelStopMinutes = 15;

class PlanController extends StateNotifier<PlanState> {
  final RouteStationService _routeService;
  final DirectionsService _directions;
  final _logger = Logger();

  LatLng? _origin;
  LatLng? _destination;

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
    state = PlanState.calculating(from: from, to: to, vehicleType: vehicleType);

    _logger.i('Analyzing route: "$from" → "$to" | vehicle: $vehicleType');

    try {
      final endpoints =
          await _routeService.resolveEndpoints(from: from, to: to);
      _origin = endpoints.origin;
      _destination = endpoints.destination;

      final routeOptions = await _directions.getRouteAlternatives(
        endpoints.origin,
        endpoints.destination,
      );

      final suggestedIdx = routeOptions.indexWhere((r) => r.isSuggested);
      var selectedIdx = suggestedIdx >= 0 ? suggestedIdx : 0;
      var gpsMatched = false;

      if (routeOptions.length > 1) {
        final gpsIdx = await _tryGpsRouteMatch(routeOptions);
        if (gpsIdx != null) {
          selectedIdx = gpsIdx;
          gpsMatched = true;
        }
      }

      await _applySelectedRoute(
        from: from,
        to: to,
        vehicle: vehicle,
        tripPreferences: tripPreferences,
        routeOptions: routeOptions,
        selectedIndex: selectedIdx,
        routeMatchedToGps: gpsMatched,
      );
    } on GeocodingException catch (e) {
      state = PlanState.error(e.message);
    } on DirectionsException catch (e) {
      state = PlanState.error(e.message);
    } on LocationException catch (e) {
      state = PlanState.error(e.message);
    } catch (e) {
      _logger.e('Plan analyze error: $e');
      state = PlanState.error('Failed to analyze route. Please try again.');
    }
  }

  /// Recomputes plan details for another driving alternative.
  Future<void> selectRoute(int index) async {
    final current = state;
    if (current is! PlanResult) return;
    if (index == current.selectedRouteIndex) return;
    if (index < 0 || index >= current.routeOptions.length) return;

    state = current.copyWith(
      isUpdatingRoute: true,
      selectedRouteIndex: index,
      routeMatchedToGps: false,
    );

    await _applySelectedRoute(
      from: current.from,
      to: current.to,
      vehicle: current.vehicle,
      tripPreferences: current.tripPreferences,
      routeOptions: current.routeOptions,
      selectedIndex: index,
      routeMatchedToGps: false,
    );
  }

  Future<int?> _tryGpsRouteMatch(List<RouteOption> options) async {
    try {
      final pos = await LocationHelper.getCurrentLocation();
      final point = LatLng(pos.latitude, pos.longitude);
      final idx = RouteOptionMatcher.nearestIndexToPosition(point, options);
      if (RouteOptionMatcher.isOnRouteCorridor(options[idx], point)) {
        return idx;
      }
    } on LocationException catch (_) {
      // GPS unavailable — keep suggested route.
    } catch (e) {
      _logger.d('GPS route match skipped: $e');
    }
    return null;
  }

  Future<void> _applySelectedRoute({
    required String from,
    required String to,
    required List<RouteOption> routeOptions,
    required int selectedIndex,
    Vehicle? vehicle,
    UserPreferences? tripPreferences,
    bool routeMatchedToGps = false,
  }) async {
    if (_origin == null || _destination == null) {
      state = PlanState.error('Route endpoints lost. Please search again.');
      return;
    }

    final option = routeOptions[selectedIndex];
    final presetRoute = _routeInfoFromOption(option, _origin!, _destination!);
    final isEv = TripPlanCopy.isEv(vehicle?.type);

    final result = await _routeService.analyzeRoute(
      from: from,
      to: to,
      includeEvStations: isEv,
      presetRoute: presetRoute,
    );

    switch (result) {
      case Success(:final data):
        final analysis = data;
        if (isEv && analysis.stations.isEmpty) {
          state = PlanState.empty(
            from: from,
            to: to,
            vehicleType: vehicle?.type,
          );
          return;
        }

        final distKm = option.distanceKm;
        final driveMins = option.durationMinutes;
        final driveMinsForEta = option.effectiveDurationMinutes;
        final stationCount = analysis.stations.length;
        final isBike = vehicle?.type == VehicleType.bike;

        final stopMins = isEv
            ? stationCount * _chargingMinutesPerStop
            : _fuelStopMinutes;
        final etaMins = driveMinsForEta + stopMins;

        bool? hasTolls;
        String? tollCorridorName;
        if (!isBike) {
          final tollMeta = _tollMetaForOption(option, presetRoute);
          hasTolls = tollMeta.hasTolls;
          tollCorridorName = tollMeta.sourceLabel;
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

        final liveTrafficMins = option.durationInTrafficMinutes;
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
          vehicleType: vehicle?.type,
          tripPreferences: tripPreferences,
          vehicle: vehicle,
          totalDistanceKm: distKm,
          durationMinutes: driveMinsForEta,
          gaps: isEv ? analysis.gaps : const [],
          etaMinutes: etaMins,
          hasTolls: hasTolls,
          fuelEstimateCost: fuelEst,
          chargingEstimate: chargingEst,
          trafficLevel: trafficLevel,
          encodedRoutePolyline: option.encodedPolyline,
          tollCorridorName: tollCorridorName,
          fuelEfficiencyKmpl: fuelEfficiencyUsed,
          routeOptions: routeOptions,
          selectedRouteIndex: selectedIndex,
          isUpdatingRoute: false,
          routeMatchedToGps: routeMatchedToGps,
        );
      case Failure(:final message):
        state = PlanState.error(message);
    }
  }

  RouteInfo _routeInfoFromOption(
    RouteOption option,
    LatLng origin,
    LatLng destination,
  ) {
    final points = option.polylinePoints.isNotEmpty
        ? option.polylinePoints
        : PolylineDecoder.decode(option.encodedPolyline);
    return RouteInfo(
      origin: origin,
      destination: destination,
      distanceKm: option.distanceKm,
      durationMinutes: option.durationMinutes,
      durationInTrafficMinutes: option.durationInTrafficMinutes,
      polylinePoints: points,
      encodedPolyline: option.encodedPolyline,
    );
  }

  _TollMeta _tollMetaForOption(RouteOption option, RouteInfo route) {
    if (option.hasTolls) {
      final corridor = const TollEstimator().estimate(
        polylinePoints: route.polylinePoints,
        totalDistanceKm: route.distanceKm,
      );
      return _TollMeta(
        hasTolls: true,
        sourceLabel: corridor.isCorridorMatch
            ? corridor.matchedCorridor
            : 'Google Maps',
      );
    }

    final corridor = const TollEstimator().estimate(
      polylinePoints: route.polylinePoints,
      totalDistanceKm: route.distanceKm,
    );
    if (corridor.isCorridorMatch) {
      return _TollMeta(hasTolls: true, sourceLabel: corridor.matchedCorridor);
    }

    return const _TollMeta(hasTolls: false);
  }

  void reset() {
    _origin = null;
    _destination = null;
    state = const PlanState.idle();
  }
}

class _TollMeta {
  const _TollMeta({required this.hasTolls, this.sourceLabel});
  final bool hasTolls;
  final String? sourceLabel;
}
