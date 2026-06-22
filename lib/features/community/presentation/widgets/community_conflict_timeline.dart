import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/community/domain/community_condition.dart';
import 'package:journeyplus/features/community/domain/models/station_community_report.dart';
import 'package:journeyplus/features/community/presentation/widgets/community_time_ago.dart';

/// P2-031 — Conflict-aware vertical timeline.
///
/// Surfaced only when recent reports disagree (`hasConflictInRecent`). Renders
/// the most recent reports chronologically with colour-coded condition dots so
/// the driver can judge whether the place is currently good despite mixed
/// history (e.g. "down 3h ago, but working 20m ago").
class CommunityConflictTimeline extends StatelessWidget {
  const CommunityConflictTimeline({
    super.key,
    required this.reports,
    this.maxItems = 5,
  });

  final List<StationCommunityReport> reports;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    // reports arrive newest-first; show newest at the top.
    final items = reports.take(maxItems).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline_outlined,
                  size: 16, color: AppColors.warning),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Reports disagree — recent history',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontSize: 13,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Newest first. Check the latest pulse before deciding.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < items.length; i++)
            _TimelineRow(
              report: items[i],
              isLast: i == items.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.report, required this.isLast});

  final StationCommunityReport report;
  final bool isLast;

  Color get _dotColor {
    if (isNegativeCondition(report.condition)) return AppColors.error;
    if (isPositiveCondition(report.condition)) return AppColors.success;
    return AppColors.warning;
  }

  String get _conditionLabel {
    if (isNegativeCondition(report.condition)) return 'Poor / down';
    if (isPositiveCondition(report.condition)) return 'Good / working';
    return 'Mixed';
  }

  @override
  Widget build(BuildContext context) {
    final color = _dotColor;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rail: dot + connector
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.borderLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          // Content
          Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _conditionLabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.star_rounded,
                        size: 12, color: AppColors.warning),
                    Text(
                      '${report.rating}',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    ),
                    const Spacer(),
                    Text(
                      communityTimeAgo(report.createdAt),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (report.comment != null &&
                    report.comment!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '“${report.comment!.trim()}”',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
