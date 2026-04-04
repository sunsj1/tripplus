import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

class JourneyTimeline extends StatelessWidget {
  final double gapKm;
  final String nextStationName;
  final double nextStationKm;

  const JourneyTimeline({
    super.key,
    required this.gapKm,
    required this.nextStationName,
    required this.nextStationKm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _TimelineItem(
            dotColor: AppColors.primary,
            lineColor: AppColors.primary,
            title: 'Current Position',
            subtitle: 'Highland Way',
            trailing: '14:20',
            trailingLabel: 'ARRIVAL',
            isFirst: true,
          ),
          _TimelineItem(
            dotColor: AppColors.success,
            lineColor: AppColors.success,
            title: 'Recommended Stop',
            subtitle: nextStationName.isNotEmpty
                ? nextStationName
                : 'Evergreen FastCharge Hub',
            trailing: '14:31',
            trailingLabel: 'EST.\nSTOP',
            badge: _TimelineBadge(
              icon: Icons.bolt,
              label: '${nextStationKm.round() > 0 ? nextStationKm.round() : 4} CHARGERS AVAILABLE',
              color: AppColors.success,
            ),
          ),
          _TimelineGapItem(gapKm: gapKm),
          _TimelineItem(
            dotColor: AppColors.textTertiary,
            lineColor: Colors.transparent,
            title: 'Final Destination',
            subtitle: 'River Valley\nEstates',
            trailing: '16:45',
            trailingLabel: 'EST.\nARRIVAL',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Color dotColor;
  final Color lineColor;
  final String title;
  final String subtitle;
  final String trailing;
  final String trailingLabel;
  final bool isFirst;
  final bool isLast;
  final _TimelineBadge? badge;

  const _TimelineItem({
    required this.dotColor,
    required this.lineColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.trailingLabel,
    this.isFirst = false,
    this.isLast = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dotColor.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: lineColor.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: AppTextStyles.bodySmall),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: AppTextStyles.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            trailing,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            trailingLabel,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 8,
                              color: AppColors.textTertiary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (badge != null) ...[
                    const SizedBox(height: 8),
                    badge!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TimelineBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineGapItem extends StatelessWidget {
  final double gapKm;

  const _TimelineGapItem({required this.gapKm});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.error.withValues(alpha: 0.3),
                          AppColors.textTertiary.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${gapKm.round()} KM GAP ZONE',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'No charging stations available between stations',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
