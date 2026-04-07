import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

class CommunityAverageRatingRow extends StatelessWidget {
  final double? average;
  final int reportCount;

  const CommunityAverageRatingRow({
    super.key,
    required this.average,
    required this.reportCount,
  });

  @override
  Widget build(BuildContext context) {
    if (average == null || reportCount == 0) {
      return Text(
        'No ratings yet — your visit counts.',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textHint,
          height: 1.4,
        ),
      );
    }
    return Row(
      children: [
        Text(
          average!.toStringAsFixed(1),
          style: AppTextStyles.h4.copyWith(fontSize: 28, height: 1),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (i) {
                final filled = (average! - i) >= 0.5;
                return Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 18,
                  color: filled ? AppColors.warning : AppColors.textHint,
                );
              }),
            ),
            Text(
              'from $reportCount report${reportCount == 1 ? '' : 's'}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
