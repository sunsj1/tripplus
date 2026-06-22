import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/widgets/app_top_bar.dart';
import 'package:journeyplus/features/community/domain/models/station_community_report.dart';
import 'package:journeyplus/features/community/presentation/widgets/community_report_snippet_card.dart';
import 'package:journeyplus/features/community/presentation/widgets/community_time_ago.dart';

enum _PulseFilter { latest, reliable, withPhotos, withPrice }

class CommunityReportListScreen extends StatefulWidget {
  final String stationName;
  final List<StationCommunityReport> reports;

  const CommunityReportListScreen({
    super.key,
    required this.stationName,
    required this.reports,
  });

  @override
  State<CommunityReportListScreen> createState() =>
      _CommunityReportListScreenState();
}

class _CommunityReportListScreenState extends State<CommunityReportListScreen> {
  _PulseFilter _filter = _PulseFilter.latest;

  List<StationCommunityReport> _filteredReports() {
    final list = [...widget.reports];
    switch (_filter) {
      case _PulseFilter.latest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case _PulseFilter.reliable:
        list.sort((a, b) => _weight(b).compareTo(_weight(a)));
      case _PulseFilter.withPhotos:
        return list.where((r) => (r.photoBase64 ?? '').isNotEmpty).toList();
      case _PulseFilter.withPrice:
        return list.where((r) => (r.costPerKwh ?? '').trim().isNotEmpty).toList();
    }
    return list;
  }

  double _weight(StationCommunityReport r) {
    final age = DateTime.now().difference(r.createdAt).inHours;
    final recency = age <= 24
        ? 1.0
        : age <= 72
            ? 0.7
            : 0.4;
    final condition = switch (r.condition) {
      'down' => 0.2,
      'issues' => 0.55,
      _ => 0.9,
    };
    return recency * (condition + (r.rating / 5));
  }

  String _summaryText() {
    final priced = widget.reports
        .map((e) => _toPrice(e.costPerKwh))
        .whereType<double>()
        .toList()
      ..sort();
    final median = priced.isEmpty
        ? null
        : (priced.length.isOdd
            ? priced[priced.length ~/ 2]
            : (priced[(priced.length ~/ 2) - 1] + priced[priced.length ~/ 2]) / 2);
    final mid = (widget.reports.length / 2).ceil();
    final latest = widget.reports.take(mid).toList();
    final older = widget.reports.skip(mid).toList();
    final latestAvg = latest.isEmpty
        ? 0
        : latest.map((e) => e.rating).reduce((a, b) => a + b) / latest.length;
    final olderAvg = older.isEmpty
        ? latestAvg
        : older.map((e) => e.rating).reduce((a, b) => a + b) / older.length;
    final trendWord = (latestAvg - olderAvg) >= 0.15
        ? 'improving'
        : (latestAvg - olderAvg) <= -0.15
            ? 'declining'
            : 'steady';
    if (median == null) return 'Trend: $trendWord · no median price yet';
    return 'Median price: ₹${median.toStringAsFixed(1)}/kWh · Trend: $trendWord';
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filteredReports();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: 'All Pulses',
              showBack: true,
              onBack: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _summaryText(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _FilterChip(
                        text: 'Latest',
                        active: _filter == _PulseFilter.latest,
                        onTap: () => setState(() => _filter = _PulseFilter.latest),
                      ),
                      _FilterChip(
                        text: 'Reliable users',
                        active: _filter == _PulseFilter.reliable,
                        onTap: () => setState(() => _filter = _PulseFilter.reliable),
                      ),
                      _FilterChip(
                        text: 'With photos',
                        active: _filter == _PulseFilter.withPhotos,
                        onTap: () => setState(() => _filter = _PulseFilter.withPhotos),
                      ),
                      _FilterChip(
                        text: 'With price',
                        active: _filter == _PulseFilter.withPrice,
                        onTap: () => setState(() => _filter = _PulseFilter.withPrice),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? const Center(child: Text('No pulses for this filter'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final report = visible[index];
                        return CommunityReportSnippetCard(
                          report: report,
                          timeLabel: communityTimeAgo(report.createdAt),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

double? _toPrice(String? raw) {
  final v = raw?.trim();
  if (v == null || v.isEmpty) return null;
  final m = RegExp(r'[\d.]+').firstMatch(v)?.group(0);
  return m == null ? null : double.tryParse(m);
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.text,
    required this.active,
    required this.onTap,
  });

  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primarySurface : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
