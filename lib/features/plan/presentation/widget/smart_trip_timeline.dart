import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/plan/domain/preference_corridor_insight.dart';
import 'package:tripplus/features/plan/domain/timeline_stop.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/plan/presentation/controller/route_preference_insights_provider.dart';
import 'package:tripplus/features/plan/presentation/controller/trip_timeline_controller.dart';
import 'package:tripplus/features/plan/presentation/view/preference_stops_screen.dart';

/// Collapsible corridor timeline: origin → preferences → (EV) chargers → destination.
class SmartTripTimeline extends ConsumerStatefulWidget {
  const SmartTripTimeline({
    super.key,
    required this.plan,
    required this.isEv,
    this.preferences,
  });

  final PlanResult plan;
  final bool isEv;
  final UserPreferences? preferences;

  @override
  ConsumerState<SmartTripTimeline> createState() => _SmartTripTimelineState();
}

class _SmartTripTimelineState extends ConsumerState<SmartTripTimeline> {
  bool _stopsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final key = TripTimelineKey(
      plan: widget.plan,
      isEv: widget.isEv,
      preferences: widget.preferences,
    );
    final stops = ref.watch(tripTimelineControllerProvider(key));
    final controller = ref.read(tripTimelineControllerProvider(key).notifier);

    if (stops.isEmpty) return const SizedBox.shrink();

    final origin = stops.first;
    final destination = stops.last;
    final middle = stops.length > 2 ? stops.sublist(1, stops.length - 1) : <TimelineStop>[];
    final stationStops = middle
        .where((s) => s.type == TimelineStopType.chargingStation)
        .toList();

    final autoExpandStations = stationStops.length <= 2;
    final stationsExpanded = _stopsExpanded || autoExpandStations;

    final insightsKey = RoutePreferenceInsightsKey(
      plan: widget.plan,
      isEv: widget.isEv,
      preferences: widget.preferences,
    );
    final insightsAsync = ref.watch(routePreferenceInsightsProvider(insightsKey));
    final routeLabel =
        '${widget.plan.from.isEmpty ? 'Start' : widget.plan.from} → ${widget.plan.to}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JOURNEY',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _EndpointCard(stop: origin, isOrigin: true),
          insightsAsync.when(
            data: (insights) {
              if (insights.isEmpty) {
                if (!widget.isEv && stationStops.isEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      _TripHintBanner(
                        text:
                            'Tip: turn on preferences (pure veg, family, night safe…) on the plan screen to see them mapped along this route.',
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  const SizedBox(height: 12),
                  _PreferencesSection(
                    insights: insights,
                    routeLabel: routeLabel,
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (e, st) => const SizedBox.shrink(),
          ),
          if (stationStops.isNotEmpty) ...[
            const SizedBox(height: 12),
            _CollapsibleStopsHeader(
              count: stationStops.length,
              isEv: widget.isEv,
              expanded: stationsExpanded,
              onToggle: () =>
                  setState(() => _stopsExpanded = !stationsExpanded),
            ),
            if (stationsExpanded) ...[
              const SizedBox(height: 8),
              ...stationStops.map((stop) {
                final index = stops.indexOf(stop);
                return _StationStopCard(
                  stop: stop,
                  onTogglePin: () => controller.togglePin(index),
                );
              }),
            ],
          ],
          const SizedBox(height: 12),
          _EndpointCard(stop: destination, isOrigin: false),
        ],
      ),
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection({
    required this.insights,
    required this.routeLabel,
  });

  final List<PreferenceCorridorInsight> insights;
  final String routeLabel;

  static const _sectionDisclaimer =
      'Suggestions only — verify on the ground before you stop. '
      'Counts are places within ~5 km of your driving corridor.';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, size: 16, color: AppColors.accentIndigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Along your route',
                  style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _sectionDisclaimer,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          ...insights.map(
            (insight) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _PreferenceInsightRow(
                insight: insight,
                routeLabel: routeLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripHintBanner extends StatelessWidget {
  const _TripHintBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primarySurfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline,
              size: 18, color: AppColors.accentAmber),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceInsightRow extends StatelessWidget {
  const _PreferenceInsightRow({
    required this.insight,
    required this.routeLabel,
  });

  final PreferenceCorridorInsight insight;
  final String routeLabel;

  @override
  Widget build(BuildContext context) {
    final color = insight.item.accent;
    final item = insight.item;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PreferenceStopsScreen(
                insight: insight,
                routeLabel: routeLabel,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            insight.countLabel,
                            style: AppTextStyles.caption.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.hint,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight.milestoneLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to see places · take your call on the ground',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollapsibleStopsHeader extends StatelessWidget {
  const _CollapsibleStopsHeader({
    required this.count,
    required this.isEv,
    required this.expanded,
    required this.onToggle,
  });

  final int count;
  final bool isEv;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final label = isEv ? '$count chargers on corridor' : '$count stops';
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Icon(
                isEv ? Icons.ev_station_outlined : Icons.place_outlined,
                size: 18,
                color: AppColors.accentTeal,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                ),
              ),
              Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EndpointCard extends StatelessWidget {
  const _EndpointCard({required this.stop, required this.isOrigin});

  final TimelineStop stop;
  final bool isOrigin;

  @override
  Widget build(BuildContext context) {
    final color = isOrigin ? AppColors.accentBlue : AppColors.accentAmber;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(stop.icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOrigin ? 'Start' : 'Destination',
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  stop.label,
                  style: AppTextStyles.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!isOrigin)
            Text(
              '${stop.distanceFromStartKm.round()} km',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _StationStopCard extends StatelessWidget {
  const _StationStopCard({required this.stop, this.onTogglePin});

  final TimelineStop stop;
  final VoidCallback? onTogglePin;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.accentTeal;
    final pinned = stop.pinned;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: pinned
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.ev_station, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.label,
                  style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (stop.subtitle != null)
                  Text(
                    stop.subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  '${stop.distanceFromStartKm.round()} km · '
                  '${stop.distanceToNextKm?.round() ?? '—'} km to next',
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          if (onTogglePin != null)
            GestureDetector(
              onTap: onTogglePin,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pinned
                      ? AppColors.primarySurface
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  pinned ? 'Pinned' : 'Optional',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: pinned ? AppColors.primary : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
