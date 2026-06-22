import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/utils/trip_plan_copy.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';
import 'package:journeyplus/features/plan/domain/timeline_stop.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';

/// Input for building the route timeline (plan + trip context).
@immutable
class TripTimelineKey {
  const TripTimelineKey({
    required this.plan,
    required this.isEv,
    this.preferences,
  });

  final PlanResult plan;
  final bool isEv;
  final UserPreferences? preferences;

  @override
  bool operator ==(Object other) =>
      other is TripTimelineKey &&
      other.plan == plan &&
      other.isEv == isEv &&
      other.preferences == preferences;

  @override
  int get hashCode => Object.hash(plan, isEv, preferences);
}

/// Manages the ordered list of [TimelineStop]s for the current [PlanResult].
class TripTimelineController extends StateNotifier<List<TimelineStop>> {
  TripTimelineController(TripTimelineKey key) : super(_buildStops(key));

  void togglePin(int index) {
    final stops = List<TimelineStop>.from(state);
    if (index < 0 || index >= stops.length) return;
    if (stops[index].isEndpoint) return;
    stops[index] = stops[index].copyWith(pinned: !stops[index].pinned);
    state = stops;
  }

  List<TimelineStop> get pinnedStops =>
      state.where((s) => s.pinned && !s.isEndpoint).toList();

  static List<TimelineStop> _buildStops(TripTimelineKey key) {
    final plan = key.plan;
    final prefs = key.preferences ?? const UserPreferences();
    final prefItems = prefs.timelineItems(forEv: key.isEv);

    final stops = <TimelineStop>[
      TimelineStop(
        type: TimelineStopType.origin,
        label: plan.from.isEmpty ? 'Current location' : plan.from,
        distanceFromStartKm: 0,
      ),
    ];

    // Preference milestones spaced along the corridor
    for (var i = 0; i < prefItems.length; i++) {
      final item = prefItems[i];
      final frac = (i + 1) / (prefItems.length + 1);
      stops.add(
        TimelineStop(
          type: TimelineStopType.preference,
          label: item.label,
          subtitle: item.hint,
          distanceFromStartKm: plan.totalDistanceKm * frac,
          pinned: true,
          accentColor: item.accent,
          iconOverride: item.icon,
        ),
      );
    }

    if (key.isEv) {
      stops.addAll(_chargingStops(plan));
    }

    stops.add(
      TimelineStop(
        type: TimelineStopType.destination,
        label: plan.to,
        distanceFromStartKm: plan.totalDistanceKm,
      ),
    );

    return stops;
  }

  static List<TimelineStop> _chargingStops(PlanResult plan) {
    final sorted = List<ChargingStation>.from(plan.stations)
      ..sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));

    final out = <TimelineStop>[];
    for (var i = 0; i < sorted.length; i++) {
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

      out.add(
        TimelineStop(
          type: TimelineStopType.chargingStation,
          label: station.name,
          distanceFromStartKm: dist,
          distanceToNextKm: nextDist > 0 ? nextDist : null,
          subtitle: subtitle,
          connectorCount: connCount,
          hasFastCharge: hasFast,
          pinned: false,
        ),
      );
    }
    return out;
  }
}

final tripTimelineControllerProvider = StateNotifierProvider.autoDispose
    .family<TripTimelineController, List<TimelineStop>, TripTimelineKey>(
  (ref, key) => TripTimelineController(key),
);
