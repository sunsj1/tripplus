import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

class StationReportStepWashroom extends StatelessWidget {
  final bool? washroomAvailable;
  final ValueChanged<bool?> onWashroomAvailable;
  final bool? washroomClean;
  final ValueChanged<bool?> onWashroomClean;
  final bool? womenFriendlyWashroom;
  final ValueChanged<bool?> onWomenFriendly;

  const StationReportStepWashroom({
    super.key,
    required this.washroomAvailable,
    required this.onWashroomAvailable,
    required this.washroomClean,
    required this.onWashroomClean,
    required this.womenFriendlyWashroom,
    required this.onWomenFriendly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Washroom intel',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Road-trip gold. Skip anything you did not check.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Washroom on site?',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ChoicePill(
                  label: 'Yes',
                  selected: washroomAvailable == true,
                  onTap: () => onWashroomAvailable(true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ChoicePill(
                  label: 'No',
                  selected: washroomAvailable == false,
                  onTap: () => onWashroomAvailable(false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ChoicePill(
                  label: 'Skip',
                  selected: washroomAvailable == null,
                  onTap: () => onWashroomAvailable(null),
                ),
              ),
            ],
          ),
          if (washroomAvailable == true) ...[
            const SizedBox(height: 22),
            Text(
              'Was it clean?',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ChoicePill(
                    label: 'Clean',
                    selected: washroomClean == true,
                    onTap: () => onWashroomClean(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ChoicePill(
                    label: 'Not really',
                    selected: washroomClean == false,
                    onTap: () => onWashroomClean(false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ChoicePill(
                    label: 'Skip',
                    selected: washroomClean == null,
                    onTap: () => onWashroomClean(null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Women-friendly access?',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ChoicePill(
                    label: 'Yes',
                    selected: womenFriendlyWashroom == true,
                    onTap: () => onWomenFriendly(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ChoicePill(
                    label: 'No / unsure',
                    selected: womenFriendlyWashroom == false,
                    onTap: () => onWomenFriendly(false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ChoicePill(
                    label: 'Skip',
                    selected: womenFriendlyWashroom == null,
                    onTap: () => onWomenFriendly(null),
                  ),
                ),
              ],
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderLight,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
