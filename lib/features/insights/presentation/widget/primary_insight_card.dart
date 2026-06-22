import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

class PrimaryInsightCard extends StatelessWidget {
  final double distanceKm;
  final int minutes;
  final bool isOptimized;
  final VoidCallback? onViewDetails;

  const PrimaryInsightCard({
    super.key,
    required this.distanceKm,
    required this.minutes,
    this.isOptimized = true,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRIMARY INSIGHT',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Next\ncharger in\n${distanceKm.round()} km',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textOnDark,
              fontSize: 34,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isOptimized
                ? 'Your current route is optimized.\nEstimated arrival at the next\nstation in $minutes minutes.'
                : 'Route has potential gaps.\nConsider planning charging stops.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onViewDetails,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'View Details',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
