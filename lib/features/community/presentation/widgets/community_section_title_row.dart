import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

class CommunitySectionTitleRow extends StatelessWidget {
  final int reportCount;

  const CommunitySectionTitleRow({super.key, required this.reportCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.groups_outlined, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          'COMMUNITY',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        if (reportCount > 0)
          Text(
            '$reportCount update${reportCount == 1 ? '' : 's'}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
      ],
    );
  }
}
