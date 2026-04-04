import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';
import 'package:tripplus/features/insights/presentation/controller/insights_state.dart';

class InsightsController extends StateNotifier<InsightsState> {
  final _logger = Logger();

  InsightsController() : super(const InsightsState.initial());

  void loadFromRouteAnalysis({
    required String from,
    required String to,
    required List<ChargingStation> stations,
    required List<ChargingGap> gaps,
    required double routeDistanceKm,
    required int durationMinutes,
  }) {
    if (stations.isEmpty) {
      state = InsightsState.loaded(InsightsData(
        from: from,
        to: to,
        routeDistanceKm: routeDistanceKm,
        durationMinutes: durationMinutes,
        healthScore: 0,
        healthLabel: 'No Coverage',
        maxGapKm: routeDistanceKm,
        gaps: gaps,
      ));
      return;
    }

    final sorted = [...stations]
      ..sort((a, b) => (a.distanceKm ?? double.infinity)
          .compareTo(b.distanceKm ?? double.infinity));

    // ── Compute metrics ──
    final maxGap = gaps.isNotEmpty ? gaps.first.gapKm : 0.0;

    // Average spacing between stations
    double avgSpacing = 0;
    if (sorted.length > 1) {
      final firstKm = sorted.first.distanceKm ?? 0;
      final lastKm = sorted.last.distanceKm ?? 0;
      avgSpacing = (lastKm - firstKm) / (sorted.length - 1);
    } else {
      avgSpacing = routeDistanceKm;
    }

    // Charging stops needed (assume ~200 km range per charge, stop every ~150 km)
    final stopsNeeded = max(0, (routeDistanceKm / 150).ceil() - 1);

    // Estimated cost: ~₹8.5/kWh × ~15 kWh/100 km × distance
    final chargingKm = min(routeDistanceKm, stopsNeeded * 150.0);
    final estimatedCost = (chargingKm / 100) * 15 * 8.5;

    // Estimated charging time: ~30 min per stop for fast, ~60 min for slow
    final fastCount = stations.where((s) =>
        s.connections.any((c) => c.isFastCharge == true)).length;
    final avgChargeMin = fastCount > stopsNeeded / 2 ? 30 : 50;
    final chargingMinutes = stopsNeeded * avgChargeMin;

    // Station quality
    final verifiedCount = stations.where((s) =>
        s.isRecentlyVerified == true).length;
    final totalPower = stations.fold<double>(0, (sum, s) {
      final maxP = s.connections.fold<double>(
          0, (m, c) => (c.powerKw ?? 0) > m ? (c.powerKw ?? 0) : m);
      return sum + maxP;
    });
    final avgPower = stations.isNotEmpty ? totalPower / stations.length : 0.0;
    final fastPercent = stations.isNotEmpty
        ? (fastCount / stations.length * 100).round()
        : 0;

    // Health score (0-100)
    int health = 100;
    // Penalty for large gaps
    if (maxGap > 100) {
      health -= 40;
    } else if (maxGap > 60) {
      health -= 25;
    } else if (maxGap > 40) {
      health -= 10;
    }
    // Penalty for few stations
    if (sorted.length < 3) {
      health -= 20;
    } else if (sorted.length < 6) {
      health -= 10;
    }
    // Bonus for fast chargers
    if (fastPercent > 50) health += 5;
    // Penalty for poor coverage at start/end
    if (sorted.first.distanceKm != null && sorted.first.distanceKm! > 50) {
      health -= 10;
    }
    health = health.clamp(0, 100);

    String healthLabel;
    if (health >= 80) {
      healthLabel = 'Excellent';
    } else if (health >= 60) {
      healthLabel = 'Good';
    } else if (health >= 40) {
      healthLabel = 'Moderate';
    } else {
      healthLabel = 'Poor';
    }

    state = InsightsState.loaded(InsightsData(
      from: from,
      to: to,
      routeDistanceKm: routeDistanceKm,
      durationMinutes: durationMinutes,
      totalStations: stations.length,
      healthScore: health,
      healthLabel: healthLabel,
      avgSpacingKm: avgSpacing,
      chargingStopsNeeded: stopsNeeded,
      estimatedChargingCostRupees: estimatedCost,
      estimatedChargingMinutes: chargingMinutes,
      fastChargerCount: fastCount,
      verifiedCount: verifiedCount,
      avgPowerKw: avgPower,
      fastChargerPercent: fastPercent,
      maxGapKm: maxGap,
      gaps: gaps,
      topStations: sorted.take(3).toList(),
    ));

    _logger.i(
      'Insights: health=$health ($healthLabel), '
      '${stations.length} stations, maxGap=${maxGap.round()} km, '
      'cost=₹${estimatedCost.round()}, stops=$stopsNeeded',
    );
  }
}
