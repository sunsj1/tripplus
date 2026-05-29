import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/plan/presentation/widget/stat_card.dart';
import 'package:tripplus/features/trip/domain/models/trip.dart';
import 'package:tripplus/features/trip/domain/models/trip_status.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_controller.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:tripplus/features/trip/presentation/controller/trip_providers.dart';

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
          ActiveTripRunning(:final trip) => _ActiveDashboard(trip: trip),
          ActiveTripPaused(:final trip) => _ActiveDashboard(trip: trip),
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
class _ActiveDashboard extends ConsumerStatefulWidget {
  const _ActiveDashboard({required this.trip});
  final Trip trip;

  @override
  ConsumerState<_ActiveDashboard> createState() => _ActiveDashboardState();
}

class _ActiveDashboardState extends ConsumerState<_ActiveDashboard> {
  late Timer _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _elapsed = widget.trip.elapsed;
    // Tick every second when running; when paused elapsed is frozen anyway.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final trip = ref.read(activeTripControllerProvider).trip;
      if (trip != null && trip.status == TripStatus.active) {
        setState(() => _elapsed = trip.elapsed);
      }
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
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
          const SizedBox(height: 20),

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRunning ? 'ELAPSED TIME' : 'PAUSED',
                    style: AppTextStyles.caption.copyWith(
                      color: isRunning
                          ? Colors.white70
                          : AppColors.warning,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatElapsed(_elapsed),
                    style: AppTextStyles.h2.copyWith(
                      color: isRunning ? Colors.white : AppColors.warning,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (trip.etaMinutes != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Total ETA: ${_fmtDuration(trip.etaMinutes!)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color:
                            isRunning ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          _TripEstimateCards(trip: trip),
          const SizedBox(height: 28),

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
                      onPressed: () => _confirmEnd(context, controller),
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

  void _confirmEnd(BuildContext context, ActiveTripController controller) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End trip?'),
        content: const Text(
          'This will finalise your trip summary. You can\'t resume after ending.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.endTrip();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('End trip'),
          ),
        ],
      ),
    );
  }

  String _formatElapsed(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
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
          Row(
            children: [
              StatCard(
                icon: Icons.timer_outlined,
                iconColor: AppColors.primary,
                label: 'Duration',
                value: _fmtDuration(elapsed.inMinutes),
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
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => controller.dismissCompleted(),
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
    final toll = trip.tollsEstimate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (trip.etaMinutes != null)
            StatCard(
              icon: Icons.schedule_outlined,
              iconColor: AppColors.primary,
              label: 'ETA',
              value: _fmtDuration(trip.etaMinutes!),
            ),
          if (trip.etaMinutes != null) const SizedBox(width: 10),
          if (toll != null)
            StatCard(
              icon: Icons.toll_outlined,
              iconColor: AppColors.warning,
              label: 'Tolls',
              value: '₹${toll.round()}',
            ),
          if (toll != null) const SizedBox(width: 10),
          if (cost != null)
            StatCard(
              icon: trip.isCostCharging
                  ? Icons.electric_bolt_outlined
                  : Icons.local_gas_station_outlined,
              iconColor:
                  trip.isCostCharging ? AppColors.success : AppColors.primary,
              label: trip.isCostCharging ? 'Charging' : 'Fuel',
              value: '₹${cost.round()}',
            ),
        ],
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
