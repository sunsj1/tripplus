import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/fuel_brand.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

/// Shows [FuelBrandPicker] only when the vehicle burns pump fuel (petrol/diesel).
class FuelBrandSection extends StatelessWidget {
  const FuelBrandSection({
    super.key,
    required this.vehicleType,
    required this.preferences,
    required this.onChanged,
    this.compact = false,
  });

  final VehicleType? vehicleType;
  final UserPreferences preferences;
  final ValueChanged<UserPreferences> onChanged;
  final bool compact;

  bool get _visible =>
      vehicleType == VehicleType.petrol || vehicleType == VehicleType.diesel;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Column(
      children: [
        FuelBrandPicker(
          preferences: preferences,
          onChanged: onChanged,
          compact: compact,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

/// Multi-select grid of Indian fuel retailers with brand-colored tiles.
class FuelBrandPicker extends StatelessWidget {
  const FuelBrandPicker({
    super.key,
    required this.preferences,
    required this.onChanged,
    this.compact = false,
  });

  final UserPreferences preferences;
  final ValueChanged<UserPreferences> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final selected = preferences.selectedFuelBrands;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PREFERRED FUEL STATIONS',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pick one or more — we prioritise these along your corridor. Saved to your profile.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: compact ? 0.92 : 0.88,
          children: FuelBrand.values.map((brand) {
            final isSelected = selected.contains(brand);
            return _FuelBrandTile(
              brand: brand,
              selected: isSelected,
              onTap: () => onChanged(preferences.toggleFuelBrand(brand)),
            );
          }).toList(),
        ),
        if (selected.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${selected.length} selected · ${selected.map((b) => b.label).join(', ')}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _FuelBrandTile extends StatelessWidget {
  const _FuelBrandTile({
    required this.brand,
    required this.selected,
    required this.onTap,
  });

  final FuelBrand brand;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? brand.primaryColor : AppColors.borderLight,
              width: selected ? 2.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: brand.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: brand.tileGradient,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: brand == FuelBrand.shell
                            ? Icon(
                                Icons.local_gas_station,
                                color: brand.secondaryColor,
                                size: 28,
                              )
                            : Text(
                                brand.monogram,
                                style: TextStyle(
                                  fontSize: brand == FuelBrand.jioBp ? 16 : 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: brand == FuelBrand.hpcl ? 1 : 0,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      if (selected)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              size: 16,
                              color: brand.primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: selected
                      ? brand.primaryColor.withValues(alpha: 0.08)
                      : AppColors.surface,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Text(
                  brand.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: selected ? brand.primaryColor : AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
