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
      child: Row(
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
    );
  }
}
