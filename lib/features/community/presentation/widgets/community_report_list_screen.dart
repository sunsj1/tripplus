import 'package:flutter/material.dart';
import 'package:tripplus/core/widgets/app_top_bar.dart';
import 'package:tripplus/features/community/domain/models/station_community_report.dart';
import 'package:tripplus/features/community/presentation/widgets/community_report_snippet_card.dart';
import 'package:tripplus/features/community/presentation/widgets/community_time_ago.dart';

class CommunityReportListScreen extends StatelessWidget {
  final String stationName;
  final List<StationCommunityReport> reports;

  const CommunityReportListScreen({
    super.key,
    required this.stationName,
    required this.reports,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  stationName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
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
