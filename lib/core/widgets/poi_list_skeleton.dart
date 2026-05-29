import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';

/// Shimmer-style placeholder list for POI category loading (`P1-062`).
class PoiListSkeleton extends StatelessWidget {
  const PoiListSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const PoiListSkeletonTile(),
    );
  }
}

class PoiListSkeletonTile extends StatelessWidget {
  const PoiListSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.shimmer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.shimmer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.shimmer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
