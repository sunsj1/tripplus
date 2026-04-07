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
