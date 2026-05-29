import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/plan/domain/timeline_stop.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/plan/presentation/controller/trip_timeline_controller.dart';

/// P1-020 / P1-021 — Smart Trip Timeline
///
/// Vertical timeline: Origin → Charging/Fuel stops → Destination.
/// Each non-endpoint stop has a pin toggle (P1-021).
class SmartTripTimeline extends ConsumerWidget {
  const SmartTripTimeline({super.key, required this.plan});

  final PlanResult plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stops = ref.watch(tripTimelineControllerProvider(plan));
    final controller =
        ref.read(tripTimelineControllerProvider(plan).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'TRIP TIMELINE',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stops.length,
          itemBuilder: (context, index) {
            final stop = stops[index];
            final isLast = index == stops.length - 1;
            return _TimelineRow(
              stop: stop,
              isLast: isLast,
              onTogglePin: stop.isEndpoint
                  ? null
                  : () => controller.togglePin(index),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Single timeline row
// ---------------------------------------------------------------------------
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.stop,
    required this.isLast,
    this.onTogglePin,
  });

  final TimelineStop stop;
  final bool isLast;
  final VoidCallback? onTogglePin;

  @override
  Widget build(BuildContext context) {
    final iconColor = stop.iconColor(
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
    );
    final isPinned = stop.pinned;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left rail: icon + vertical connector line
          SizedBox(
            width: 52,
            child: Column(
              children: [
                const SizedBox(height: 2),
                // Icon bubble
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(stop.icon, size: 18, color: iconColor),
                ),
                // Connector line (not for last item)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.3),
                            AppColors.primary.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Right content
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 20, bottom: 20, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Name + distance-from-start chip
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stop.label,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: stop.isEndpoint
                                    ? AppColors.textPrimary
                                    : isPinned
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                fontWeight: stop.isEndpoint
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (stop.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                stop.subtitle!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                            const SizedBox(height: 6),
                            // Distance chips row
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                if (stop.distanceFromStartKm > 0)
                                  _Chip(
                                    icon: Icons.near_me_outlined,
                                    text:
                                        '${stop.distanceFromStartKm.round()} km from start',
                                    color: AppColors.primary,
                                  ),
                                if (stop.distanceToNextKm != null)
                                  _Chip(
                                    icon: Icons.arrow_forward,
                                    text:
                                        '${stop.distanceToNextKm!.round()} km to next',
                                    color: stop.distanceToNextKm! > 80
                                        ? AppColors.error
                                        : AppColors.textTertiary,
                                  ),
                                if (stop.hasFastCharge == true)
                                  _Chip(
                                    icon: Icons.bolt,
                                    text: 'Fast charge',
                                    color: AppColors.success,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Pin toggle (P1-021)
                      if (!stop.isEndpoint && onTogglePin != null)
                        _PinToggle(
                          pinned: isPinned,
                          onToggle: onTogglePin!,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pin toggle button (P1-021)
// ---------------------------------------------------------------------------
class _PinToggle extends StatelessWidget {
  const _PinToggle({required this.pinned, required this.onToggle});

  final bool pinned;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: pinned
              ? AppColors.primarySurface
              : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: pinned
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              pinned ? Icons.push_pin : Icons.push_pin_outlined,
              size: 12,
              color: pinned
                  ? AppColors.primary
                  : AppColors.textTertiary,
            ),
            const SizedBox(width: 4),
            Text(
              pinned ? 'Pinned' : 'Optional',
              style: AppTextStyles.caption.copyWith(
                color: pinned
                    ? AppColors.primary
                    : AppColors.textTertiary,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tiny info chip
// ---------------------------------------------------------------------------
class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
