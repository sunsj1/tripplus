import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

class StationReportStepReview extends StatelessWidget {
  final int rating;
  final String conditionLabel;
  final int amenityCount;
  final String washroomSummary;
  final bool hasPhoto;
  final TextEditingController commentController;

  const StationReportStepReview({
    super.key,
    required this.rating,
    required this.conditionLabel,
    required this.amenityCount,
    required this.washroomSummary,
    required this.hasPhoto,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ship it',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Preview what fellow drivers will see.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 18),
          _SummaryLine(icon: Icons.star_rounded, text: '$rating / 5 stars'),
          _SummaryLine(icon: Icons.ev_station, text: conditionLabel),
          _SummaryLine(
            icon: Icons.local_cafe_outlined,
            text: amenityCount == 0
                ? 'No amenities tagged'
                : '$amenityCount amenity picks',
          ),
          _SummaryLine(icon: Icons.wc_outlined, text: washroomSummary),
          _SummaryLine(
            icon: Icons.photo_outlined,
            text: hasPhoto ? 'Photo attached' : 'No photo',
          ),
          const SizedBox(height: 18),
          Text(
            'Micro note (optional)',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: commentController,
            maxLines: 3,
            maxLength: 280,
            decoration: InputDecoration(
              hintText: 'e.g. “Gate code 4521” or “Left bay fastest”',
              filled: true,
              fillColor: AppColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SummaryLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
