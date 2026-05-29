import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/trip/domain/models/trip_status.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:tripplus/features/trip/presentation/controller/trip_providers.dart';
import 'package:tripplus/features/trip/presentation/utils/trip_formatters.dart';

/// Live elapsed display — minutes only, ticks once per minute.
class TripElapsedPanel extends ConsumerStatefulWidget {
  const TripElapsedPanel({
    super.key,
    required this.isRunning,
    this.etaMinutes,
    this.compact = false,
  });

  final bool isRunning;
  final int? etaMinutes;
  final bool compact;

  @override
  ConsumerState<TripElapsedPanel> createState() => _TripElapsedPanelState();
}

class _TripElapsedPanelState extends ConsumerState<TripElapsedPanel> {
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  void didUpdateWidget(covariant TripElapsedPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRunning != widget.isRunning) _bind();
  }

  void _bind() {
    _ticker?.cancel();
    final trip = ref.read(activeTripControllerProvider).trip;
    _elapsed = trip?.elapsed ?? Duration.zero;
    if (widget.isRunning) {
      _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
        final t = ref.read(activeTripControllerProvider).trip;
        if (t != null && t.status == TripStatus.active && mounted) {
          setState(() => _elapsed = t.elapsed);
        }
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(activeTripControllerProvider);
    final trip = ref.read(activeTripControllerProvider).trip;
    if (trip != null && !widget.isRunning) {
      _elapsed = trip.elapsed;
    } else if (trip != null && widget.isRunning) {
      _elapsed = trip.elapsed;
    }

    final isRunning = widget.isRunning;

    if (widget.compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRunning ? '● LIVE ON THIS ROUTE' : '⏸ PAUSED',
            style: AppTextStyles.caption.copyWith(
              color: isRunning ? Colors.white70 : AppColors.warning,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatElapsedMinutesOnly(_elapsed),
            style: AppTextStyles.h3.copyWith(
              color: isRunning ? Colors.white : AppColors.warning,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Elapsed · updates every minute',
            style: AppTextStyles.bodySmall.copyWith(
              color: isRunning ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          if (widget.etaMinutes != null) ...[
            const SizedBox(height: 4),
            Text(
              'Planned ETA: ${formatTripDurationMinutes(widget.etaMinutes!)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: isRunning ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRunning ? 'ELAPSED TIME' : 'PAUSED',
          style: AppTextStyles.caption.copyWith(
            color: isRunning ? Colors.white70 : AppColors.warning,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          formatElapsedMinutesOnly(_elapsed),
          style: AppTextStyles.h2.copyWith(
            color: isRunning ? Colors.white : AppColors.warning,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          'Updates every minute',
          style: AppTextStyles.bodySmall.copyWith(
            color: isRunning ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
        if (widget.etaMinutes != null) ...[
          const SizedBox(height: 4),
          Text(
            'Total ETA: ${formatTripDurationMinutes(widget.etaMinutes!)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: isRunning ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
