import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

class StationReportStepRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRating;

  const StationReportStepRating({
    super.key,
    required this.rating,
    required this.onRating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How was the stop?',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Stars = overall experience (chargers, vibe, wait).',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final n = i + 1;
              final on = n <= rating;
              return IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                onPressed: () => onRating(n),
                icon: Icon(
                  on ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 44,
                  color: on ? AppColors.warning : AppColors.textHint,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _caption(rating),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

String _caption(int r) {
  return switch (r) {
    1 => 'Rough — thanks for being honest.',
    2 => 'Could be better.',
    3 => 'Okay stop.',
    4 => 'Pretty solid!',
    5 => 'Chef’s kiss — stellar stop.',
    _ => 'Tap the stars',
  };
}
