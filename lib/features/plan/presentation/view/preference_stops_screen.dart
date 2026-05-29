import 'package:flutter/material.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/community/presentation/widgets/poi_community_rating_pulse.dart';
import 'package:tripplus/features/plan/domain/preference_corridor_insight.dart';
import 'package:tripplus/features/pois/presentation/widget/poi_detail_sheet.dart';
import 'package:tripplus/features/pois/presentation/widget/poi_list_tile.dart';

/// Full list of corridor POIs for one trip preference (from route details).
class PreferenceStopsScreen extends StatelessWidget {
  const PreferenceStopsScreen({
    super.key,
    required this.insight,
    required this.routeLabel,
  });

  final PreferenceCorridorInsight insight;
  final String routeLabel;

  static const _disclaimer =
      'These are suggestions only — not bookings or guarantees. '
      'Counts are places within about 5 km of your driving corridor. '
      'Always verify safety, hours, and suitability on the ground before stopping.';

  @override
  Widget build(BuildContext context) {
    final sorted = List<Poi>.from(insight.pois)
      ..sort(
        (a, b) => (a.distanceAlongRouteKm ?? 0)
            .compareTo(b.distanceAlongRouteKm ?? 0),
      );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(insight.item.label, style: AppTextStyles.titleMedium),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DisclaimerCard(text: _disclaimer),
                    const SizedBox(height: 16),
                    Text(routeLabel, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 8),
                    Text(
                      insight.item.hint,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: AppColors.accentBlue,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${insight.milestoneLabel}. '
                              'We space markers evenly for planning — tap a real place below when you are ready to stop.',
                              style: AppTextStyles.bodySmall.copyWith(
                                height: 1.4,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${sorted.length} places along corridor',
                      style: AppTextStyles.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            if (sorted.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      insight.corridorLoaded
                          ? 'No matching places found near this route. Try widening your search from Discovery, or adjust preferences.'
                          : 'Could not load places for this corridor. Check your connection and try planning the route again.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final poi = sorted[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: PoiListTile(
                        poi: poi,
                        pulseSlot: PoiCommunityRatingPulse(poi: poi),
                        onTap: () => showPoiDetailSheet(context, poi),
                      ),
                    );
                  },
                  childCount: sorted.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 20, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
