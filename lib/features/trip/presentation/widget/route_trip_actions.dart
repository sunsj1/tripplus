import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/alerts/presentation/controller/alerts_providers.dart';
import 'package:journeyplus/features/shell/presentation/controller/shell_providers.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/domain/models/trip_status.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_controller.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';
import 'package:journeyplus/features/trip/presentation/utils/start_trip_with_location.dart';
import 'package:journeyplus/features/trip/presentation/utils/trip_formatters.dart';
import 'package:journeyplus/features/trip/presentation/widget/trip_elapsed_panel.dart';
import 'package:journeyplus/features/trip/presentation/widget/trip_end_dialog.dart';

/// Trip lifecycle controls on the Route Details screen — mirrors the Trip tab.
class RouteTripActions extends ConsumerWidget {
  const RouteTripActions({
    super.key,
    required this.from,
    required this.to,
    required this.onPrepareTrip,
  });

  final String from;
  final String to;
  final Future<void> Function() onPrepareTrip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(activeTripControllerProvider);
    final trip = tripState.trip;
    final controller = ref.read(activeTripControllerProvider.notifier);

    final matches =
        trip != null &&
        tripMatchesRouteLabels(
          tripFrom: trip.from,
          tripTo: trip.to,
          planFrom: from,
          planTo: to,
        );

    if (!matches) {
      return _StartTripButton(onPressed: onPrepareTrip);
    }

    return switch (trip.status) {
      TripStatus.notStarted => _ReadyActions(
        onStart: () => startTripWithLocation(
          context,
          controller,
          notifications: ref.read(localNotificationServiceProvider),
        ),
        onOpenTripTab: () => navigateToShellTab(ref, 1),
      ),
      TripStatus.active => _LiveActions(
        trip: trip,
        isRunning: true,
        onPause: () => controller.pauseTrip(),
        onEnd: () => _endTrip(context, ref, controller),
      ),
      TripStatus.paused => _LiveActions(
        trip: trip,
        isRunning: false,
        onPause: () => controller.resumeTrip(),
        onEnd: () => _endTrip(context, ref, controller),
      ),
      TripStatus.completed => _CompletedBanner(
        trip: trip,
        onDone: () {
          ref.invalidate(tripHistoryProvider);
          controller.dismissCompleted();
        },
      ),
    };
  }

  Future<void> _endTrip(
    BuildContext context,
    WidgetRef ref,
    ActiveTripController controller,
  ) {
    return showTripEndDialog(
      context,
      onConfirm: () async {
        await controller.endTrip();
        ref.invalidate(tripHistoryProvider);
      },
    );
  }
}

class _StartTripButton extends StatelessWidget {
  const _StartTripButton({required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: onPressed,
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          icon: const Icon(Icons.luggage_outlined),
          label: const Text('Start this trip'),
        ),
      ),
    );
  }
}

class _ReadyActions extends StatelessWidget {
  const _ReadyActions({required this.onStart, required this.onOpenTripTab});

  final VoidCallback onStart;
  final VoidCallback onOpenTripTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warningSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.warning, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Trip prepared — ready to start',
                    style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start trip'),
            ),
          ),
          TextButton(
            onPressed: onOpenTripTab,
            child: const Text('Open Trip tab'),
          ),
        ],
      ),
    );
  }
}

class _LiveActions extends StatelessWidget {
  const _LiveActions({
    required this.trip,
    required this.isRunning,
    required this.onPause,
    required this.onEnd,
  });

  final Trip trip;
  final bool isRunning;
  final VoidCallback onPause;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: isRunning ? AppColors.greenGradient : null,
              color: isRunning ? null : AppColors.warningSurface,
              borderRadius: BorderRadius.circular(16),
              border: isRunning
                  ? null
                  : Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
            ),
            child: TripElapsedPanel(
              isRunning: isRunning,
              etaMinutes: trip.etaMinutes,
              compact: true,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: onPause,
                    style: FilledButton.styleFrom(
                      backgroundColor: isRunning
                          ? AppColors.warning
                          : AppColors.primary,
                    ),
                    icon: Icon(
                      isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(isRunning ? 'Pause' : 'Resume'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: onEnd,
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
        ],
      ),
    );
  }
}

class _CompletedBanner extends StatelessWidget {
  const _CompletedBanner({required this.trip, required this.onDone});

  final Trip trip;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Trip complete — saved to history',
                    style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Duration ${formatElapsedMinutesOnly(trip.elapsed)} · '
              '${trip.totalDistanceKm.round()} km',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onDone, child: const Text('Done')),
          ],
        ),
      ),
    );
  }
}
