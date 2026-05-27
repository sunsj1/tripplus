import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';
import 'package:tripplus/features/community/domain/community_station_key.dart';
import 'package:tripplus/features/community/domain/models/station_community_ui_state.dart';
import 'package:tripplus/features/community/presentation/controller/community_providers.dart';

/// Compact community rating for list tiles (same [communityStationKey] as detail).
class CommunityRatingPulse extends ConsumerWidget {
  final ChargingStation station;

  const CommunityRatingPulse({super.key, required this.station});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = communityStationKey(station);
    final state = ref.watch(stationCommunityControllerProvider(key));
    if (state.reports.isEmpty) return const SizedBox.shrink();
    final avg = state.averageRating;
    if (avg == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(
                avg.toStringAsFixed(1),
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              Text(
                ' · ${state.reports.length} pulse${state.reports.length == 1 ? '' : 's'}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          _TinyTag(
            text: 'Reliability ${state.reliabilityScore}',
            icon: Icons.verified_outlined,
            color: state.reliabilityScore >= 75
                ? AppColors.success
                : state.reliabilityScore >= 45
                    ? AppColors.warning
                    : AppColors.error,
          ),
          if (state.lowConfidence)
            _TinyTag(
              text: 'Low confidence',
              icon: Icons.hourglass_bottom_outlined,
              color: AppColors.warning,
            ),
        ],
      ),
    );
  }
}

class _TinyTag extends StatelessWidget {
  const _TinyTag({required this.text, required this.color, this.icon});

  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
