import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';
import 'package:tripplus/features/plan/domain/timeline_stop.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';

/// Manages the ordered list of [TimelineStop]s for the current [PlanResult].
///
/// Handles P1-020 (display) and P1-021 (pin/unpin editing). The state is
/// rebuilt fresh whenever [PlanResult] changes and never persisted — it is
/// purely UI session state.
class TripTimelineController extends StateNotifier<List<TimelineStop>> {
  TripTimelineController(PlanResult plan) : super(_buildStops(plan));

  // ---------------------------------------------------------------------------
  // P1-021 — Pin / unpin
  // ---------------------------------------------------------------------------

  /// Toggles the [pinned] flag for the stop at [index].
  ///
  /// Origin and destination nodes are always pinned; toggling them is a no-op.
  void togglePin(int index) {
    final stops = List<TimelineStop>.from(state);
    if (index < 0 || index >= stops.length) return;
    if (stops[index].isEndpoint) return; // endpoints cannot be unpinned
    stops[index] = stops[index].copyWith(pinned: !stops[index].pinned);
    state = stops;
  }

  /// Returns only pinned stops (excluding origin and destination).
  List<TimelineStop> get pinnedStops =>
      state.where((s) => s.pinned && !s.isEndpoint).toList();

  // ---------------------------------------------------------------------------
  // Builder
  // ---------------------------------------------------------------------------

  static List<TimelineStop> _buildStops(PlanResult plan) {
    final stops = <TimelineStop>[];

    // Origin
    stops.add(TimelineStop(
      type: TimelineStopType.origin,
      label: plan.from.isEmpty ? 'Current location' : plan.from,
      distanceFromStartKm: 0,
      distanceToNextKm: plan.stations.isEmpty ? plan.totalDistanceKm : null,
    ));

    // Charging / fuel stations sorted by ascending distance from origin
    final sorted = List<ChargingStation>.from(plan.stations)
      ..sort(
          (a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));

    for (int i = 0; i < sorted.length; i++) {
      final station = sorted[i];
      final dist = station.distanceKm ?? 0;
      final nextDist = i + 1 < sorted.length
          ? (sorted[i + 1].distanceKm ?? 0) - dist
          : plan.totalDistanceKm - dist;

      final hasFast =
          station.connections.any((c) => c.isFastCharge == true);
      final connCount = station.connections.length;
      final subtitle = hasFast
          ? 'Fast charge · $connCount connector${connCount != 1 ? 's' : ''}'
          : '$connCount connector${connCount != 1 ? 's' : ''}';

      stops.add(TimelineStop(
        type: TimelineStopType.chargingStation,
        label: station.name,
        distanceFromStartKm: dist,
        distanceToNextKm: nextDist > 0 ? nextDist : null,
        subtitle: subtitle,
        connectorCount: connCount,
        hasFastCharge: hasFast,
      ));

    }

    // Destination
    stops.add(TimelineStop(
      type: TimelineStopType.destination,
      label: plan.to,
      distanceFromStartKm: plan.totalDistanceKm,
    ));

    return stops;
  }
}

/// Auto-disposed per [PlanResult] instance.
///
/// Keyed by the [PlanResult] object so it rebuilds if the plan changes.
final tripTimelineControllerProvider = StateNotifierProvider.autoDispose
    .family<TripTimelineController, List<TimelineStop>, PlanResult>(
  (ref, plan) => TripTimelineController(plan),
);
