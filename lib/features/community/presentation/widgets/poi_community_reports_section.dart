import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/community/domain/models/station_community_ui_state.dart';
import 'package:tripplus/features/community/presentation/controller/community_providers.dart';
import 'package:tripplus/features/community/presentation/widgets/community_average_rating_row.dart';
import 'package:tripplus/features/community/presentation/widgets/community_conflict_timeline.dart';
import 'package:tripplus/features/community/presentation/widgets/community_empty_state.dart';
import 'package:tripplus/features/community/presentation/widgets/community_recent_reports_carousel.dart';
import 'package:tripplus/features/community/presentation/widgets/community_report_cta_button.dart';
import 'package:tripplus/features/community/presentation/widgets/community_section_shell.dart';
import 'package:tripplus/features/community/presentation/widgets/community_section_title_row.dart';
import 'package:tripplus/features/community/presentation/widgets/poi_report_sheet.dart';
import 'package:tripplus/features/pois/domain/community_poi_key.dart';

/// POI community pulse feed + submit CTA.
///
/// Previously read-only. Now exposes `showPoiReportSheet` so any user can
/// rate/comment on a POI directly from the detail sheet.
class PoiCommunityReportsSection extends ConsumerWidget {
  const PoiCommunityReportsSection({super.key, required this.poi});
  final Poi poi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = communityPoiKey(poi);
    final state = ref.watch(poiCommunityControllerProvider(key));

    return CommunitySectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommunitySectionTitleRow(reportCount: state.reports.length),
          const SizedBox(height: 14),
          CommunityAverageRatingRow(
            average: state.averageRating,
            reportCount: state.reports.length,
            freshnessLabel: state.freshnessLabel,
            lowConfidence: state.lowConfidence,
          ),
          if (state.reports.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _ReliabilityChips(
                score: state.reliabilityScore,
                conflict: state.hasConflictInRecent,
              ),
            ),
          const SizedBox(height: 16),
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                state.errorMessage!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
          if (state.loading && state.reports.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (state.reports.isEmpty)
            const CommunityEmptyState()
          else if (state.hasConflictInRecent) ...[
            // P2-031 — surface a conflict timeline when reports disagree.
            CommunityConflictTimeline(reports: state.reports),
            const SizedBox(height: 12),
            CommunityRecentReportsCarousel(reports: state.reports),
          ] else
            CommunityRecentReportsCarousel(reports: state.reports),
          const SizedBox(height: 14),
          CommunityReportCtaButton(
            busy: state.submitting,
            onPressed: () => showPoiReportSheet(context: context, poi: poi),
          ),
        ],
      ),
    );
  }
}

class _ReliabilityChips extends StatelessWidget {
  const _ReliabilityChips({required this.score, required this.conflict});
  final int score;
  final bool conflict;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        _MiniTag(
          text: 'Reliability $score/100',
          icon: Icons.verified_outlined,
          color: score >= 75
              ? AppColors.success
              : score >= 45
                  ? AppColors.warning
                  : AppColors.error,
        ),
        if (conflict)
          const _MiniTag(
            text: 'Mixed status in recent pulses',
            icon: Icons.sync_problem_outlined,
            color: AppColors.warning,
          ),
      ],
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.text, required this.color, this.icon});

  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
