import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/personalization/domain/ranking_explanation.dart';
import 'package:tripplus/features/personalization/presentation/controller/personalization_providers.dart';

/// P2-033 — "Why we recommend this" surface.
///
/// Rendered as a small card on the POI detail sheet. Lists the top 3 reasons
/// the ranker scored this POI highly so users understand the personalization
/// rather than seeing an opaque sort.
///
/// Returns `SizedBox.shrink()` when there's nothing meaningful to say (e.g.
/// "Standard match" with no contributing signals) — silence beats noise.
class RankingWhyPanel extends ConsumerWidget {
  const RankingWhyPanel({
    super.key,
    required this.poi,
    this.currentPositionKm,
  });

  final Poi poi;
  final double? currentPositionKm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ranker = ref.watch(poiRankerProvider);
    final vector = ref.watch(userPreferenceVectorProvider);
    final explanation = ranker.explain(
      poi,
      vector,
      currentPositionKm: currentPositionKm,
    );

    final top = explanation.topReasons.take(3).toList();
    if (top.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Why we recommend this',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < top.length; i++) ...[
            _ReasonRow(reason: top[i]),
            if (i < top.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow({required this.reason});
  final RankingReason reason;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(reason.icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            reason.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
