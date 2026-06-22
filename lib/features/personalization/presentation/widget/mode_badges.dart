import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/community/domain/models/station_community_ui_state.dart';
import 'package:journeyplus/features/community/presentation/controller/community_providers.dart';
import 'package:journeyplus/features/personalization/domain/route_mode.dart';
import 'package:journeyplus/features/pois/domain/community_poi_key.dart';

/// P2-020 / 021 — Small mode badges that appear on POI tiles when the
/// community has consistently tagged the place for that mode.
///
/// We render whatever modes qualify, in priority order, capped at two so the
/// tile metadata row doesn't blow up. Each badge watches the community
/// provider for the POI's targetKey.
class PoiModeBadges extends ConsumerWidget {
  const PoiModeBadges({super.key, required this.poi, this.maxBadges = 2});

  final Poi poi;
  final int maxBadges;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = communityPoiKey(poi);
    final state = ref.watch(poiCommunityControllerProvider(key));
    final tags = state.tagAggregation;

    final qualified = <RouteMode>[
      if (tags.qualifiesFamily) RouteMode.family,
      if (tags.qualifiesWomenSafe) RouteMode.womenSafe,
    ].take(maxBadges).toList();

    if (qualified.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        for (final mode in qualified) _ModePill(mode: mode),
      ],
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({required this.mode});
  final RouteMode mode;

  @override
  Widget build(BuildContext context) {
    final color = mode.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(mode.icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            mode.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 9.5,
            ),
          ),
        ],
      ),
    );
  }
}
