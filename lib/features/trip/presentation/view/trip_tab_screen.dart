import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/features/alerts/domain/alert_route_utils.dart';
import 'package:journeyplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/alerts/presentation/view/alert_history_screen.dart';
import 'package:journeyplus/features/plan/presentation/widget/stat_card.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/domain/models/trip_status.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';
import 'package:journeyplus/features/trip/presentation/utils/share_trip.dart';
import 'package:journeyplus/features/trip/presentation/utils/trip_formatters.dart';
import 'package:journeyplus/features/trip/presentation/widget/trip_elapsed_panel.dart';
import 'package:journeyplus/features/trip/presentation/widget/trip_end_dialog.dart';

class TripTabScreen extends ConsumerWidget {
  const TripTabScreen({super.key, required this.onPlanTrip});

  /// Callback that switches to the Plan tab when user taps "Plan a trip".
  final VoidCallback onPlanTrip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(activeTripControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: switch (tripState) {
          ActiveTripIdle() => _IdleView(onPlanTrip: onPlanTrip),
          ActiveTripReady(:final trip) => _ReadyView(trip: trip),
          ActiveTripRunning(:final trip) =>
            _ActiveDashboard(trip: trip, onPlanTrip: onPlanTrip),
          ActiveTripPaused(:final trip) =>
            _ActiveDashboard(trip: trip, onPlanTrip: onPlanTrip),
          ActiveTripCompleted(:final trip) => _CompletedView(trip: trip),
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Idle — no trip planned
// ---------------------------------------------------------------------------
class _IdleView extends StatelessWidget {
  const _IdleView({required this.onPlanTrip});
  final VoidCallback onPlanTrip;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.luggage_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text('No active trip', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Plan a trip and your trip control center lives here — '
              'route, fuel cost, ETA, and predictive alerts.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onPlanTrip,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
              icon: const Icon(Icons.route),
              label: const Text('Plan a trip'),
            ),
            const SizedBox(height: 20),
            // Location permission hint — sets expectations before the trip starts.
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Allow location when driving for ahead-of-you alerts.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ready — trip prepared, waiting for "Start"
// ---------------------------------------------------------------------------
class _ReadyView extends ConsumerWidget {
  const _ReadyView({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(activeTripControllerProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _TripHeader(
            from: trip.from,
            to: trip.to,
            badge: 'READY TO START',
            badgeColor: AppColors.warning,
          ),
          const SizedBox(height: 20),
          _TripEstimateCards(trip: trip),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () => controller.startTrip(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start trip'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => controller.dismissCompleted(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
                child: const Text('Cancel'),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active Dashboard — running or paused
// ---------------------------------------------------------------------------
class _ActiveDashboard extends ConsumerWidget {
  const _ActiveDashboard({required this.trip, required this.onPlanTrip});

  final Trip trip;
  final VoidCallback onPlanTrip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = trip.status == TripStatus.active;
    final controller = ref.read(activeTripControllerProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _TripHeader(
            from: trip.from,
            to: trip.to,
            badge: isRunning ? '● LIVE' : '⏸ PAUSED',
            badgeColor: isRunning ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(height: 12),
          _RouteDriftBanner(onReviewRoutes: onPlanTrip),
          const SizedBox(height: 8),

          // Elapsed time card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isRunning
                    ? AppColors.greenGradient
                    : LinearGradient(
                        colors: [
                          AppColors.warningSurface,
                          AppColors.warningSurface,
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TripElapsedPanel(
                isRunning: isRunning,
                etaMinutes: trip.etaMinutes,
              ),
            ),
          ),
          const SizedBox(height: 20),

          _TripEstimateCards(trip: trip),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AlertHistoryScreen(trip: trip),
                ),
              ),
              icon: const Icon(Icons.notifications_active_outlined, size: 18),
              label: Text(
                trip.firedAlerts.isEmpty
                    ? 'Alert history'
                    : 'Alert history (${trip.firedAlerts.length})',
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Pause / Resume / End buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: isRunning
                          ? () => controller.pauseTrip()
                          : () => controller.resumeTrip(),
                      style: FilledButton.styleFrom(
                        backgroundColor: isRunning
                            ? AppColors.warning
                            : AppColors.primary,
                      ),
                      icon: Icon(isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded),
                      label: Text(isRunning ? 'Pause' : 'Resume'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => showTripEndDialog(
                        context,
                        onConfirm: () async {
                          await controller.endTrip();
                          ref.invalidate(tripHistoryProvider);
                        },
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      icon: const Icon(Icons.stop_circle_outlined),
                      label: const Text('End trip'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Completed — trip summary
// ---------------------------------------------------------------------------
class _CompletedView extends ConsumerWidget {
  const _CompletedView({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(activeTripControllerProvider.notifier);
    final elapsed = trip.elapsed;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('Trip complete!', style: AppTextStyles.h3),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              '${trip.from} → ${trip.to}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),
          // Row 1 — Duration + Distance
          Row(
            children: [
              StatCard(
                icon: Icons.timer_outlined,
                iconColor: AppColors.primary,
                label: 'Duration',
                value: formatElapsedMinutesOnly(elapsed),
              ),
              const SizedBox(width: 12),
              StatCard(
                icon: Icons.straighten_outlined,
                iconColor: AppColors.success,
                label: 'Distance',
                value: '${trip.totalDistanceKm.round()}',
                unit: ' km',
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Row 2 — Stations + Cost (when available)
          Row(
            children: [
              if (trip.stationCount > 0) ...[
                StatCard(
                  icon: trip.isCostCharging
                      ? Icons.ev_station_outlined
                      : Icons.local_gas_station_outlined,
                  iconColor: trip.isCostCharging
                      ? AppColors.success
                      : AppColors.primary,
                  label: trip.isCostCharging ? 'Chargers' : 'Fuel stops',
                  value: '${trip.stationCount}',
                ),
                const SizedBox(width: 12),
              ],
              if (trip.tripCostEstimate != null)
                StatCard(
                  icon: Icons.receipt_long_outlined,
                  iconColor: AppColors.accentAmber,
                  label: trip.isCostCharging ? 'Charging~' : 'Fuel~',
                  value: '₹${trip.tripCostEstimate!.round()}',
                ),
              if (trip.displayHasTolls != null) ...[
                if (trip.tripCostEstimate != null ||
                    trip.stationCount > 0)
                  const SizedBox(width: 12),
                StatCard(
                  icon: Icons.toll_outlined,
                  iconColor: AppColors.accentAmber,
                  label: 'Tolls',
                  value: trip.displayHasTolls! ? 'Yes' : 'No',
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // ETA vs actual comparison (when we have both)
          if (trip.etaMinutes != null && trip.startedAt != null) ...[
            _EtaComparisonBanner(
              plannedMinutes: trip.etaMinutes!,
              actualMinutes: elapsed.inMinutes,
            ),
            const SizedBox(height: 16),
          ],
          // P2-052 — Share completed trip in chat / SMS.
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => shareTrip(context, trip),
              icon: const Icon(Icons.ios_share_outlined),
              label: const Text('Share this trip'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AlertHistoryScreen(trip: trip),
                ),
              ),
              icon: const Icon(Icons.notifications_active_outlined),
              label: Text(
                trip.firedAlerts.isEmpty
                    ? 'View alert history'
                    : 'View alert history (${trip.firedAlerts.length})',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Saved to Trip history in Profile',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () {
                ref.invalidate(tripHistoryProvider);
                controller.dismissCompleted();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Done'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared sub-widgets
// ---------------------------------------------------------------------------

class _TripHeader extends StatelessWidget {
  const _TripHeader({
    required this.from,
    required this.to,
    required this.badge,
    required this.badgeColor,
  });

  final String from;
  final String to;
  final String badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge,
              style: AppTextStyles.caption.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  from,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ),
              Expanded(
                child: Text(
                  to,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripEstimateCards extends StatelessWidget {
  const _TripEstimateCards({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final cost = trip.tripCostEstimate;
    final toll = trip.displayHasTolls;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                children: [
                  if (trip.etaMinutes != null) ...[
                    StatCard(
                      compact: true,
                      icon: Icons.schedule_outlined,
                      iconColor: AppColors.primary,
                      label: 'ETA',
                      value: _fmtDuration(trip.etaMinutes!),
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (toll != null) ...[
                    StatCard(
                      compact: true,
                      icon: Icons.toll_outlined,
                      iconColor: AppColors.warning,
                      label: 'Tolls',
                      value: toll ? 'Yes' : 'No',
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (cost != null)
                    StatCard(
                      compact: true,
                      icon: trip.isCostCharging
                          ? Icons.electric_bolt_outlined
                          : Icons.local_gas_station_outlined,
                      iconColor: trip.isCostCharging
                          ? AppColors.success
                          : AppColors.primary,
                      label: trip.isCostCharging ? 'Charging' : 'Fuel',
                      value: '₹${cost.round()}',
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ETA vs actual comparison banner
// ---------------------------------------------------------------------------
class _EtaComparisonBanner extends StatelessWidget {
  const _EtaComparisonBanner({
    required this.plannedMinutes,
    required this.actualMinutes,
  });

  final int plannedMinutes;
  final int actualMinutes;

  @override
  Widget build(BuildContext context) {
    final diff = actualMinutes - plannedMinutes;
    final onTime = diff.abs() <= 10;
    final faster = diff < -10;

    final (icon, color, message) = onTime
        ? (Icons.check_circle_outline, AppColors.success, 'On time vs. estimate')
        : faster
            ? (
                Icons.rocket_launch_outlined,
                AppColors.success,
                '${(-diff)} min faster than planned'
              )
            : (
                Icons.schedule_outlined,
                AppColors.warning,
                '$diff min longer than planned'
              );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            'Est. ${_fmtDuration(plannedMinutes)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Route drift — GPS far from cached corridor polyline
// ---------------------------------------------------------------------------

class _RouteDriftBanner extends ConsumerWidget {
  const _RouteDriftBanner({required this.onReviewRoutes});

  final VoidCallback onReviewRoutes;

  static const _driftThresholdKm = 3.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position =
        ref.read(activeTripControllerProvider.notifier).lastPosition;
    final cache = CorridorCacheBox.read();
    if (position == null ||
        cache == null ||
        cache.encodedPolyline.isEmpty) {
      return const SizedBox.shrink();
    }

    final polyline = PolylineDecoder.decode(cache.encodedPolyline);
    if (polyline.length < 2) return const SizedBox.shrink();

    final point = LatLng(position.latitude, position.longitude);
    final driftKm = AlertRouteUtils.nearestApproachKm(polyline, point);
    if (driftKm <= _driftThresholdKm) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.warningSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            const Icon(Icons.alt_route, color: AppColors.warning, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'You may be on a different route — review alternatives on Plan.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
            ),
            TextButton(
              onPressed: onReviewRoutes,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Plan'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

String _fmtDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}
