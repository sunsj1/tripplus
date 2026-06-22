import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

class CommunityEmptyState extends StatelessWidget {
  const CommunityEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Icon(Icons.travel_explore_outlined,
              size: 36, color: AppColors.textHint),
          const SizedBox(height: 8),
          Text(
            'Quiet here — for now',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Drop a 30-second pulse after your stop.\nThe next driver will thank you.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textHint,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
