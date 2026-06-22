import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

class StationReportStepPulse extends StatelessWidget {
  final String condition;
  final ValueChanged<String> onCondition;
  final TextEditingController costController;
  final bool fastChargerAvailable;
  final ValueChanged<bool> onFastCharger;
  final bool? chargeSuccessful;
  final ValueChanged<bool?> onChargeSuccessful;

  const StationReportStepPulse({
    super.key,
    required this.condition,
    required this.onCondition,
    required this.costController,
    required this.fastChargerAvailable,
    required this.onFastCharger,
    required this.chargeSuccessful,
    required this.onChargeSuccessful,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Charging reality',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'What best matched what you saw?',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 20),
          _OptionTile(
            selected: condition == 'working',
            icon: Icons.ev_station,
            title: 'Smooth',
            subtitle: 'Charged / bays looked usable',
            onTap: () => onCondition('working'),
          ),
          const SizedBox(height: 10),
          _OptionTile(
            selected: condition == 'issues',
            icon: Icons.warning_amber_outlined,
            title: 'Mixed',
            subtitle: 'Some stalls odd, app issues, long wait…',
            onTap: () => onCondition('issues'),
          ),
          const SizedBox(height: 10),
          _OptionTile(
            selected: condition == 'down',
            icon: Icons.power_off_outlined,
            title: 'Offline / blocked',
            subtitle: 'Could not charge here',
            onTap: () => onCondition('down'),
          ),
          const SizedBox(height: 22),
          Text(
            'Price you paid (optional)',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'e.g. 12.5 (₹/kWh)',
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
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Fast charger available',
              style: AppTextStyles.bodyMedium,
            ),
            value: fastChargerAvailable,
            activeThumbColor: AppColors.primary,
            onChanged: onFastCharger,
          ),
          const SizedBox(height: 6),
          Text(
            'Could you complete a charge?',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ChoicePill(
                  label: 'Yes',
                  selected: chargeSuccessful == true,
                  onTap: () => onChargeSuccessful(true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ChoicePill(
                  label: 'No',
                  selected: chargeSuccessful == false,
                  onTap: () => onChargeSuccessful(false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ChoicePill(
                  label: 'Skip',
                  selected: chargeSuccessful == null,
                  onTap: () => onChargeSuccessful(null),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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

class _OptionTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primarySurface
          : AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderLight,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
