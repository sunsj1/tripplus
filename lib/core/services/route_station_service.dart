import 'dart:math';

import 'package:logger/logger.dart';
import 'package:journeyplus/core/services/directions_service.dart';
import 'package:journeyplus/core/services/geocoding_service.dart';
import 'package:journeyplus/core/services/google_ev_station_service.dart';
import 'package:journeyplus/core/utils/location_helper.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/core/utils/result.dart';
import 'package:journeyplus/core/utils/station_merger.dart';
import 'package:journeyplus/features/charging/data/repository/charging_repository.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';

class RouteAnalysis {
  final RouteInfo route;
  final List<ChargingStation> stations;
  final List<ChargingGap> gaps;

  const RouteAnalysis({
    required this.route,
    required this.stations,
    required this.gaps,
  });
}

class ChargingGap {
  final String afterStation;
  final double gapKm;
  final LatLng midpoint;

  const ChargingGap({
    required this.afterStation,
    required this.gapKm,
    required this.midpoint,
  });
}

class RouteStationService {
  final GeocodingService _geocoding;
  final DirectionsService _directions;
  final ChargingRepository _repository;
  final GoogleEvStationService? _googleEvService;
  final _logger = Logger();

  RouteStationService({
    required GeocodingService geocoding,
    required DirectionsService directions,
    required ChargingRepository repository,
    GoogleEvStationService? googleEvService,
  })  : _geocoding = geocoding,
        _directions = directions,
        _repository = repository,
        _googleEvService = googleEvService;

  /// Analyzes a route for charging station coverage.
  ///
  /// 1. Geocodes [from] and [to] into coordinates
  /// 2. Gets the driving route between them
  /// 3. Samples points along the route
  /// 4. Fetches stations near each sample point
  /// 5. Deduplicates and sorts by distance from start
  Future<Result<RouteAnalysis>> analyzeRoute({
    required String from,
    required String to,
    bool includeEvStations = true,
  }) async {
    try {
      // 1. Geocode locations
      final origin = await _resolveLocation(from);
      final destination = await _geocoding.geocode(to);
      _logger.i('Route: $from ($origin) → $to ($destination)');

      // 2. Get driving route
      final route = await _directions.getRoute(origin, destination);
      _logger.i('Route distance: ${route.distanceKm.round()} km');

      if (!includeEvStations) {
        return Result.success(
          RouteAnalysis(route: route, stations: const [], gaps: const []),
        );
      }

      // 3. Determine sample points along the route
      final sampleInterval = _sampleInterval(route.distanceKm);
      final sampleCount = max(2, (route.distanceKm / sampleInterval).ceil() + 1);
      final samplePoints = PolylineDecoder.samplePoints(
        route.polylinePoints,
        min(sampleCount, 12),
      );
      _logger.i('Sampling ${samplePoints.length} points along route');

      // 4. Fetch stations near each sample point (parallel) from both sources
      final searchRadius = min(sampleInterval * 0.75, 80.0);

      // Open Charge Map queries
      final ocmFutures = samplePoints.map(
        (point) => _repository.getChargingStations(
          latitude: point.latitude,
          longitude: point.longitude,
          radiusKm: searchRadius,
          maxResults: 30,
        ),
      );

      // Google Places EV queries (in parallel)
      final googleFutures = _googleEvService != null
          ? samplePoints.map(
              (point) => _googleEvService.fetchStationsNear(
                latitude: point.latitude,
                longitude: point.longitude,
                radiusMeters: searchRadius * 1000,
              ),
            )
          : <Future<List<ChargingStation>>>[];

      final ocmResults = await Future.wait(ocmFutures);
      final googleResults = await Future.wait(googleFutures);

      // 5. Collect OCM stations
      final ocmStations = <ChargingStation>[];
      for (final result in ocmResults) {
        result.when(
          success: (stations) => ocmStations.addAll(stations),
          failure: (_) {},
        );
      }

      // Deduplicate OCM by id
      final ocmMap = <int, ChargingStation>{};
      for (final s in ocmStations) {
        ocmMap.putIfAbsent(s.id, () => s);
      }

      // Collect Google stations
      final allGoogle = <ChargingStation>[];
      for (final list in googleResults) {
        allGoogle.addAll(list);
      }

      // Deduplicate Google by uuid
      final googleMap = <String, ChargingStation>{};
      for (final s in allGoogle) {
        googleMap.putIfAbsent(s.uuid ?? s.id.toString(), () => s);
      }

      // 6. Merge both sources
      final mergedStations = StationMerger.mergeAndDeduplicate(
        ocmStations: ocmMap.values.toList(),
        googleStations: googleMap.values.toList(),
      );

      _logger.i(
        'Sources: ${ocmMap.length} OCM + ${googleMap.length} Google '
        '→ ${mergedStations.length} merged',
      );

      if (mergedStations.isEmpty) {
        return Result.success(RouteAnalysis(
          route: route,
          stations: [],
          gaps: [],
        ));
      }

      // 7. Compute distance from start for each station and sort
      final stations = mergedStations.map((s) {
        final distFromStart = _distanceAlongRoute(
          route.polylinePoints,
          LatLng(s.latitude, s.longitude),
        );
        return _withRouteDistance(s, distFromStart);
      }).toList()
        ..sort((a, b) =>
            (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));

      // 8. Detect gaps > 40 km
      final gaps = _detectGaps(stations, route.distanceKm);
      _logger.i(
        'Found ${stations.length} unique stations, '
        '${gaps.length} gaps > 40 km',
      );

      return Result.success(RouteAnalysis(
        route: route,
        stations: stations,
        gaps: gaps,
      ));
    } on GeocodingException catch (e) {
      return Result.failure(e.message);
    } on DirectionsException catch (e) {
      return Result.failure(e.message);
    } on LocationException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      _logger.e('Route analysis error: $e');
      return Result.failure('Failed to analyze route. Please try again.');
    }
  }

  /// If [text] is "Current Location", uses device GPS; otherwise geocodes.
  Future<LatLng> _resolveLocation(String text) async {
    if (text.toLowerCase().contains('current location')) {
      final pos = await LocationHelper.getCurrentLocation();
      return LatLng(pos.latitude, pos.longitude);
    }
    return _geocoding.geocode(text);
  }

  /// Determines how far apart sample points should be (in km).
  double _sampleInterval(double totalKm) {
    if (totalKm < 100) return 30;
    if (totalKm < 300) return 60;
    if (totalKm < 800) return 100;
    return 150;
  }

  /// Approximate distance from route start to a station by projecting
  /// the station onto the polyline.
  double _distanceAlongRoute(List<LatLng> polyline, LatLng station) {
    double cumulativeKm = 0;
    double bestProjection = 0;
    double bestPerpendicularDist = double.infinity;

    for (int i = 0; i < polyline.length - 1; i++) {
      final segLen = _haversine(polyline[i], polyline[i + 1]);
      final dToStation = _haversine(polyline[i], station);
      final dFromEnd = _haversine(station, polyline[i + 1]);

      // Project station onto this segment
      if (segLen > 0) {
        final t = ((dToStation * dToStation - dFromEnd * dFromEnd + segLen * segLen) /
                (2 * segLen))
            .clamp(0.0, segLen);
        final perpDist = sqrt(max(0, dToStation * dToStation - t * t));

        if (perpDist < bestPerpendicularDist) {
          bestPerpendicularDist = perpDist;
          bestProjection = cumulativeKm + t;
        }
      }

      cumulativeKm += segLen;
    }

    return bestProjection;
  }

  ChargingStation _withRouteDistance(ChargingStation s, double km) {
    return s.copyWith(distanceKm: double.parse(km.toStringAsFixed(1)));
  }

  List<ChargingGap> _detectGaps(List<ChargingStation> sorted, double totalKm) {
    final gaps = <ChargingGap>[];

    // Gap from start to first station
    if (sorted.isNotEmpty && (sorted.first.distanceKm ?? 0) > 40) {
      gaps.add(ChargingGap(
        afterStation: 'Start',
        gapKm: sorted.first.distanceKm ?? 0,
        midpoint: LatLng(0, 0),
      ));
    }

    for (int i = 1; i < sorted.length; i++) {
      final prevKm = sorted[i - 1].distanceKm ?? 0;
      final currKm = sorted[i].distanceKm ?? 0;
      final gap = currKm - prevKm;
      if (gap > 40) {
        gaps.add(ChargingGap(
          afterStation: sorted[i - 1].name,
          gapKm: gap,
          midpoint: LatLng(
            (sorted[i - 1].latitude + sorted[i].latitude) / 2,
            (sorted[i - 1].longitude + sorted[i].longitude) / 2,
          ),
        ));
      }
    }

    // Gap from last station to destination
    if (sorted.isNotEmpty) {
      final lastKm = sorted.last.distanceKm ?? 0;
      final gapToEnd = totalKm - lastKm;
      if (gapToEnd > 40) {
        gaps.add(ChargingGap(
          afterStation: sorted.last.name,
          gapKm: gapToEnd,
          midpoint: LatLng(0, 0),
        ));
      }
    }

    gaps.sort((a, b) => b.gapKm.compareTo(a.gapKm));
    return gaps;
  }

  static double _haversine(LatLng a, LatLng b) {
    const r = 6371.0;
    final dLat = _rad(b.latitude - a.latitude);
    final dLng = _rad(b.longitude - a.longitude);
    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(a.latitude)) *
            cos(_rad(b.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return 2 * r * asin(sqrt(h));
  }

  static double _rad(double deg) => deg * pi / 180;
}
