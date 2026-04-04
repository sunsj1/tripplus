import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';

class PlanController extends StateNotifier<PlanState> {
  final RouteStationService _routeService;
  final _logger = Logger();

  PlanController({required RouteStationService routeService})
      : _routeService = routeService,
        super(const PlanState.idle());

  Future<void> analyzeRoute({
    required String from,
    required String to,
  }) async {
    state = PlanState.calculating(from: from, to: to);

    _logger.i('Analyzing route: "$from" → "$to"');

    final result = await _routeService.analyzeRoute(from: from, to: to);

    result.when(
      success: (analysis) {
        if (analysis.stations.isEmpty) {
          state = PlanState.empty(from: from, to: to);
        } else {
          state = PlanState.result(
            from: from,
            to: to,
            stations: analysis.stations,
            totalDistanceKm: analysis.route.distanceKm,
            durationMinutes: analysis.route.durationMinutes,
            gaps: analysis.gaps,
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
