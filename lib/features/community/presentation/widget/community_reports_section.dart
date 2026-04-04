import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/community/domain/models/community_report.dart';
import 'package:tripplus/features/community/presentation/controller/community_providers.dart';
import 'package:tripplus/features/community/presentation/widget/report_station_sheet.dart';

class CommunityReportsSection extends ConsumerStatefulWidget {
  final String stationId;
  final String stationName;

  const CommunityReportsSection({
    super.key,
    required this.stationId,
    required this.stationName,
  });

  @override
  ConsumerState<CommunityReportsSection> createState() =>
      _CommunityReportsSectionState();
}

class _CommunityReportsSectionState
    extends ConsumerState<CommunityReportsSection> {
  List<CommunityReport> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    final db = ref.read(communityLocalDbProvider);
    setState(() {
      _reports = db.getReports(widget.stationId);
      _reports.sort((a, b) => b.reportedAtMs.compareTo(a.reportedAtMs));
    });
  }

  Future<void> _openReportSheet() async {
    final report = await showModalBottomSheet<CommunityReport>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReportStationSheet(
        stationId: widget.stationId,
        stationName: widget.stationName,
      ),
    );

    if (report != null) {
      final db = ref.read(communityLocalDbProvider);
      await db.saveReport(report);
      _loadReports();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted. Thank you!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _timeAgo(int ms) {
    final diff = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(ms));
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.groups_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'COMMUNITY REPORTS',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              if (_reports.isNotEmpty)
                Text(
                  '${_reports.length} report${_reports.length > 1 ? 's' : ''}',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textTertiary),
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (_reports.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.forum_outlined,
                      size: 32, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  Text(
                    'No reports yet',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textTertiary),
                  ),
                  Text(
                    'Be the first to share station info!',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),

          ..._reports.take(3).map((r) => _ReportTile(
                report: r,
                timeAgo: _timeAgo(r.reportedAtMs),
              )),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _openReportSheet,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.edit_note, size: 20),
              label: const Text(
                'Report Station Status',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final CommunityReport report;
  final String timeAgo;

  const _ReportTile({required this.report, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    final isWorking = report.condition == 'working';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isWorking
              ? AppColors.successSurface
              : AppColors.errorSurface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isWorking
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 16,
                  color: isWorking ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 6),
                Text(
                  'User reported station is ${isWorking ? "working" : "not working"}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isWorking ? AppColors.success : AppColors.error,
                  ),
                ),
                const Spacer(),
                Text(
                  timeAgo,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textTertiary, fontSize: 11),
                ),
              ],
            ),
            if (report.costPerKwh != null) ...[
              const SizedBox(height: 6),
              Text(
                'Reported price: ₹${report.costPerKwh} / kWh',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
            if (report.fastChargerAvailable) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.bolt, size: 13, color: AppColors.teal),
                  const SizedBox(width: 4),
                  Text(
                    'Fast charger available',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.teal),
                  ),
                ],
              ),
            ],
            if (report.comments != null && report.comments!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '"${report.comments}"',
                style: AppTextStyles.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
