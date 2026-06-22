import 'package:flutter/material.dart';
import 'package:journeyplus/features/community/domain/models/station_community_report.dart';
import 'package:journeyplus/features/community/presentation/widgets/community_report_snippet_card.dart';
import 'package:journeyplus/features/community/presentation/widgets/community_time_ago.dart';

/// Vertical auto-advancing peek at the latest community voices.
class CommunityRecentReportsCarousel extends StatefulWidget {
  final List<StationCommunityReport> reports;
  final int maxVisible;

  const CommunityRecentReportsCarousel({
    super.key,
    required this.reports,
    this.maxVisible = 5,
  });

  @override
  State<CommunityRecentReportsCarousel> createState() =>
      _CommunityRecentReportsCarouselState();
}

class _CommunityRecentReportsCarouselState
    extends State<CommunityRecentReportsCarousel> {
  late final PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slice = widget.reports.take(widget.maxVisible).toList();
    if (slice.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 184,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemCount: slice.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final r = slice[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: CommunityReportSnippetCard(
                    report: r,
                    timeLabel: communityTimeAgo(r.createdAt),
                  ),
                );
              },
            ),
          ),
          if (slice.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slice.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _page ? 14 : 6,
                  height: 4,
                  decoration: BoxDecoration(
                    color: i == _page
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
