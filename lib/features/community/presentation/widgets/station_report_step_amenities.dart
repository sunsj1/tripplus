import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/stations/presentation/widget/amenity_grid.dart';

class StationReportStepAmenities extends StatelessWidget {
  final Set<String> selectedLabels;
  final void Function(String label, bool selected) onToggle;

  const StationReportStepAmenities({
    super.key,
    required this.selectedLabels,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What was actually there?',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap only what you could use today — keeps the map honest.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: defaultAmenities.map((a) {
              final on = selectedLabels.contains(a.label);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(a.icon, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(a.label),
                  ],
                ),
                selected: on,
                onSelected: (v) => onToggle(a.label, v),
                showCheckmark: false,
                selectedColor: AppColors.primarySurface,
                checkmarkColor: AppColors.primary,
                side: BorderSide(
                  color: on ? AppColors.primary : AppColors.borderLight,
                ),
              );
            }).toList(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
