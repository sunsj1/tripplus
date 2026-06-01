import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';
import 'package:tripplus/features/community/domain/community_station_key.dart';
import 'package:tripplus/features/community/domain/models/station_community_report.dart';
import 'package:tripplus/features/community/domain/models/station_community_ui_state.dart';
import 'package:tripplus/features/community/presentation/controller/community_providers.dart';
import 'package:tripplus/features/community/presentation/widgets/community_average_rating_row.dart';
import 'package:tripplus/features/community/presentation/widgets/community_empty_state.dart';
import 'package:tripplus/features/community/presentation/widgets/community_conflict_timeline.dart';
import 'package:tripplus/features/community/presentation/widgets/community_recent_reports_carousel.dart';
import 'package:tripplus/features/community/presentation/widgets/community_report_cta_button.dart';
import 'package:tripplus/features/community/presentation/widgets/community_report_list_screen.dart';
import 'package:tripplus/features/community/presentation/widgets/community_section_shell.dart';
import 'package:tripplus/features/community/presentation/widgets/community_section_title_row.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_sheet.dart';

class CommunityReportsSection extends ConsumerWidget {
  final ChargingStation station;

  const CommunityReportsSection({super.key, required this.station});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = communityStationKey(station);
    final state = ref.watch(stationCommunityControllerProvider(key));
    final user = ref.watch(userAppStateProvider);
    final ctrl = ref.read(stationCommunityControllerProvider(key).notifier);

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
              child: _ReliabilityHeader(state: state),
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
          else ...[
            _CommunityAmenitiesSummary(reports: state.reports),
            const SizedBox(height: 12),
            // P2-031 — conflict timeline when recent reports disagree.
            if (state.hasConflictInRecent) ...[
              CommunityConflictTimeline(reports: state.reports),
              const SizedBox(height: 12),
            ],
            CommunityRecentReportsCarousel(reports: state.reports),
          ],
          if (state.reports.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CommunityReportListScreen(
                        stationName: station.name,
                        reports: state.reports,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.list_alt_outlined, size: 18),
                label: const Text('View all pulses'),
              ),
            ),
          const SizedBox(height: 14),
          CommunityReportCtaButton(
            busy: state.submitting,
            onPressed: () async {
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sign in to share a station pulse.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              final ok = await showStationReportSheet(
                context: context,
                station: station,
                stationKey: key,
                userId: user.userId,
                displayName: user.displayName,
                onSubmit: ctrl.submit,
              );
              if (ok == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thanks — your pulse helps the next driver.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (context.mounted && state.errorMessage != null) {
                final retryable = state.errorMessage!
                        .toLowerCase()
                        .contains('retry') ||
                    state.errorMessage!.toLowerCase().contains('offline');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    behavior: SnackBarBehavior.floating,
                    action: retryable
                        ? SnackBarAction(
                            label: 'Retry queued',
                            onPressed: () {
                              ref
                                  .read(
                                    stationCommunityControllerProvider(
                                      key,
                                    ).notifier,
                                  )
                                  .retryPendingNow();
                            },
                          )
                        : null,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CommunityAmenitiesSummary extends StatelessWidget {
  final List<StationCommunityReport> reports;

  const _CommunityAmenitiesSummary({required this.reports});

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final r in reports) {
      for (final label in r.availableAmenityLabels) {
        counts.update(label, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    if (counts.isEmpty) return const SizedBox.shrink();

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community verified amenities',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: top
              .map(
                (e) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    '${e.key} · ${e.value}',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ReliabilityHeader extends StatelessWidget {
  const _ReliabilityHeader({required this.state});

  final StationCommunityUiState state;

  @override
  Widget build(BuildContext context) {
    final successAt = state.latestSuccessfulChargeAt;
    String? successText;
    if (successAt != null) {
      final diff = DateTime.now().difference(successAt);
      successText = diff.inHours < 1
          ? 'Last successful charge: just now'
          : diff.inHours < 24
              ? 'Last successful charge: ${diff.inHours}h ago'
              : 'Last successful charge: ${diff.inDays}d ago';
    }
    DateTime? downAt;
    DateTime? workingAt;
    for (final r in state.reports.take(8)) {
      if (downAt == null && r.condition == 'down') downAt = r.createdAt;
      if (workingAt == null &&
          (r.condition == 'working' || r.chargeSuccessful == true)) {
        workingAt = r.createdAt;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _MiniTag(
              text: 'Reliability ${state.reliabilityScore}/100',
              icon: Icons.verified_outlined,
              color: state.reliabilityScore >= 75
                  ? AppColors.success
                  : state.reliabilityScore >= 45
                      ? AppColors.warning
                      : AppColors.error,
            ),
            if (state.hasConflictInRecent)
              _MiniTag(
                text: 'Mixed status in recent pulses',
                icon: Icons.sync_problem_outlined,
                color: AppColors.warning,
              ),
          ],
        ),
        if (state.hasConflictInRecent &&
            (downAt != null || workingAt != null)) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (downAt != null)
                _MiniTag(
                  text: 'Down ${_agoShort(downAt)}',
                  icon: Icons.power_off_outlined,
                  color: AppColors.error,
                ),
              if (workingAt != null)
                _MiniTag(
                  text: 'Working ${_agoShort(workingAt)}',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
            ],
          ),
        ],
        if (successText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              successText,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}

String _agoShort(DateTime at) {
  final d = DateTime.now().difference(at);
  if (d.inMinutes < 1) return 'just now';
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  return '${d.inDays}d ago';
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
