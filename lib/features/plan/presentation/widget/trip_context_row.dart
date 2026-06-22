import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/utils/trip_plan_copy.dart';
import 'package:journeyplus/core/widgets/fuel_brand_picker.dart';

/// Vehicle row, optional fuel-brand grid (petrol/diesel), and preference chips.
/// Changes sync to the saved profile + Firestore via [PlanScreen].
class TripContextRow extends StatelessWidget {
  const TripContextRow({
    super.key,
    required this.vehicle,
    required this.preferences,
    required this.onVehicleChanged,
    required this.onPreferencesChanged,
  });

  final Vehicle? vehicle;
  final UserPreferences preferences;
  final ValueChanged<Vehicle> onVehicleChanged;
  final ValueChanged<UserPreferences> onPreferencesChanged;

  bool get _isEv => TripPlanCopy.isEv(vehicle?.type);

  bool get _showsFuelBrands {
    final t = vehicle?.type;
    return t == VehicleType.petrol || t == VehicleType.diesel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('VEHICLE'),
        const SizedBox(height: 8),
        _VehicleRow(
          selected: vehicle?.type,
          onTap: (t) => onVehicleChanged(
            vehicle?.copyWith(type: t) ?? Vehicle(type: t),
          ),
        ),
        if (_showsFuelBrands) ...[
          const SizedBox(height: 16),
          FuelBrandPicker(
            preferences: preferences,
            onChanged: onPreferencesChanged,
            compact: true,
          ),
        ],
        const SizedBox(height: 16),
        _Label('PREFERENCES FOR THIS TRIP'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _PrefChip(
              icon: Icons.eco,
              label: 'Pure veg',
              selected: preferences.pureVeg,
              onTap: () => onPreferencesChanged(
                preferences.copyWith(pureVeg: !preferences.pureVeg),
              ),
            ),
            _PrefChip(
              icon: Icons.family_restroom,
              label: 'Family',
              selected: preferences.familyMode,
              onTap: () => onPreferencesChanged(
                preferences.copyWith(familyMode: !preferences.familyMode),
              ),
            ),
            _PrefChip(
              icon: Icons.shield_outlined,
              label: 'Women safe',
              selected: preferences.womenSafe,
              onTap: () => onPreferencesChanged(
                preferences.copyWith(womenSafe: !preferences.womenSafe),
              ),
            ),
            if (_isEv)
              _PrefChip(
                icon: Icons.bolt,
                label: 'Fast chargers',
                selected: preferences.fastChargersOnly,
                onTap: () => onPreferencesChanged(
                  preferences.copyWith(
                    fastChargersOnly: !preferences.fastChargersOnly,
                  ),
                ),
              ),
            _PrefChip(
              icon: Icons.nightlight_round,
              label: 'Night safe',
              selected: preferences.nightSafe,
              onTap: () => onPreferencesChanged(
                preferences.copyWith(nightSafe: !preferences.nightSafe),
              ),
            ),
            _PrefChip(
              icon: Icons.landscape,
              label: 'Scenic',
              selected: preferences.scenicRoute,
              onTap: () => onPreferencesChanged(
                preferences.copyWith(scenicRoute: !preferences.scenicRoute),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textTertiary,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _VehicleRow extends StatelessWidget {
  const _VehicleRow({required this.selected, required this.onTap});
  final VehicleType? selected;
  final ValueChanged<VehicleType> onTap;

  IconData _iconFor(VehicleType t) {
    switch (t) {
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
    return Row(
      children: VehicleType.values.map((t) {
        final isSelected = selected == t;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              onTap: () => onTap(t),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primarySurface
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _iconFor(t),
                      size: 20,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PrefChip extends StatelessWidget {
  const _PrefChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
