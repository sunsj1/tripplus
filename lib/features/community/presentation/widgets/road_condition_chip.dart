import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/community/domain/models/station_community_ui_state.dart';
import 'package:journeyplus/features/community/presentation/controller/community_providers.dart';
import 'package:journeyplus/features/pois/domain/community_poi_key.dart';

/// P2-043 — Road-condition badge for a POI. Renders nothing unless the
/// community's recent reports converge on a non-good condition near the
/// place (rough road / construction). Watches the same community state the
/// rating pulse and mode badges do, so no extra query is needed.
class RoadConditionChip extends ConsumerWidget {
  const RoadConditionChip({super.key, required this.poi});

  final Poi poi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = communityPoiKey(poi);
    final state = ref.watch(poiCommunityControllerProvider(key));
    final road = state.roadConditionAggregation;
    if (!road.hasAdvisory) return const SizedBox.shrink();

    final isConstruction = road.dominantCondition == 'construction';
    final color = isConstruction ? AppColors.error : AppColors.warning;
    final icon = isConstruction ? Icons.construction : Icons.warning_amber;

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
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            road.advisoryLabel,
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
