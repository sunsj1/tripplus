import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

/// 2x2 grid of vehicle-type tiles. Picks a [VehicleType] and emits the
/// resulting [Vehicle] (other fields default; EV-specific fields stay null
/// here — they're filled later in profile edit when relevant).
class VehiclePicker extends StatelessWidget {
  const VehiclePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Vehicle? selected;
  final ValueChanged<Vehicle> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What do you drive?',
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: VehicleType.values.map((t) {
            final isSelected = selected?.type == t;
            return _VehicleTile(
              type: t,
              selected: isSelected,
              onTap: () => onChanged(
                selected?.copyWith(type: t) ?? Vehicle(type: t),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _VehicleTile extends StatelessWidget {
  const _VehicleTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final VehicleType type;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (type) {
      case VehicleType.petrol:
        return Icons.local_gas_station;
      case VehicleType.diesel:
        return Icons.local_shipping;
      case VehicleType.ev:
        return Icons.electric_car;
      case VehicleType.bike:
        return Icons.two_wheeler;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.primarySurface : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _icon,
              size: 24,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                type.label,
                style: AppTextStyles.titleSmall.copyWith(
                  color:
                      selected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
