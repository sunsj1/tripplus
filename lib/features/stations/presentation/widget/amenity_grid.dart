import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

class AmenityItem {
  final IconData icon;
  final String label;

  const AmenityItem({required this.icon, required this.label});
}

const defaultAmenities = [
  AmenityItem(icon: Icons.local_cafe_outlined, label: 'Coffee'),
  AmenityItem(icon: Icons.wifi, label: 'WiFi'),
  AmenityItem(icon: Icons.wc_outlined, label: 'Restroom'),
  AmenityItem(icon: Icons.shopping_bag_outlined, label: 'Shopping'),
];

class AmenityGrid extends StatelessWidget {
  final List<AmenityItem> amenities;

  const AmenityGrid({
    super.key,
    this.amenities = defaultAmenities,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 16,
      children: amenities.map((a) => _AmenityChip(amenity: a)).toList(),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final AmenityItem amenity;

  const _AmenityChip({required this.amenity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Icon(amenity.icon, size: 22, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            amenity.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
