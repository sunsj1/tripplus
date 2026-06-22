import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/utils/trip_plan_copy.dart';

/// Wrap of toggleable filter chips covering every boolean field on
/// [UserPreferences]. `BudgetTier` is rendered as a separate segmented row
/// since it's tri-state.
class PreferencesChips extends StatelessWidget {
  const PreferencesChips({
    super.key,
    required this.value,
    required this.onChanged,
    this.vehicleType,
  });

  final UserPreferences value;
  final ValueChanged<UserPreferences> onChanged;
  final VehicleType? vehicleType;

  bool get _showEvPrefs => TripPlanCopy.isEv(vehicleType);

  @override
  Widget build(BuildContext context) {
    final flags = <(_FlagDef, bool)>[
      (
        const _FlagDef('Pure veg', Icons.eco),
        value.pureVeg,
      ),
      (
        const _FlagDef('Family mode', Icons.family_restroom),
        value.familyMode,
      ),
      (
        const _FlagDef('Women safe', Icons.shield_outlined),
        value.womenSafe,
      ),
      if (_showEvPrefs)
        (
          const _FlagDef('Fast chargers only', Icons.bolt),
          value.fastChargersOnly,
        ),
      (
        const _FlagDef('Pet friendly', Icons.pets),
        value.petFriendly,
      ),
      (
        const _FlagDef('Night safe', Icons.nightlight_round),
        value.nightSafe,
      ),
      (
        const _FlagDef('Scenic route', Icons.landscape),
        value.scenicRoute,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trip preferences', style: AppTextStyles.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Pick what matters — we use these to filter stops and warn you ahead.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: flags
              .map(
                (e) => _FilterChip(
                  def: e.$1,
                  selected: e.$2,
                  onTap: () => onChanged(_toggle(e.$1.label)),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Text('Budget', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<BudgetTier>(
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          segments: BudgetTier.values
              .map(
                (t) => ButtonSegment<BudgetTier>(
                  value: t,
                  label: Text(
                    t.label,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )
              .toList(),
          selected: <BudgetTier>{value.budgetTier},
          onSelectionChanged: (set) =>
              onChanged(value.copyWith(budgetTier: set.first)),
        ),
      ],
    );
  }

  UserPreferences _toggle(String label) {
    switch (label) {
      case 'Pure veg':
        return value.copyWith(pureVeg: !value.pureVeg);
      case 'Family mode':
        return value.copyWith(familyMode: !value.familyMode);
      case 'Women safe':
        return value.copyWith(womenSafe: !value.womenSafe);
      case 'Fast chargers only':
        return value.copyWith(fastChargersOnly: !value.fastChargersOnly);
      case 'Pet friendly':
        return value.copyWith(petFriendly: !value.petFriendly);
      case 'Night safe':
        return value.copyWith(nightSafe: !value.nightSafe);
      case 'Scenic route':
        return value.copyWith(scenicRoute: !value.scenicRoute);
    }
    return value;
  }
}

class _FlagDef {
  const _FlagDef(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.def,
    required this.selected,
    required this.onTap,
  });

  final _FlagDef def;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              def.icon,
              size: 16,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              def.label,
              style: AppTextStyles.bodyMedium.copyWith(
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
