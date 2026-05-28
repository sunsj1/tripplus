import 'package:flutter/material.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/pois/presentation/view/poi_category_screen.dart';

/// The iconic 3-column "Smart Intelligence Grid" from the PDF (`P1-011`).
/// Each tile pushes [PoiCategoryScreen] for the tapped category (`P1-013`).
class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: AppTextStyles.h2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find anything along your route — chosen by '
                      'category, ranked by community trust.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final category = PoiCategory.values[i];
                    return _CategoryTile(
                      category: category,
                      onTap: () => _open(context, category),
                    );
                  },
                  childCount: PoiCategory.values.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, PoiCategory category) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => PoiCategoryScreen(category: category),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});
  final PoiCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, accent) = _styleFor(category);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.07),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: accent),
            ),
            const Spacer(),
            Text(
              category.label,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _styleFor(PoiCategory c) {
    switch (c) {
      case PoiCategory.fuel:
        return (Icons.local_gas_station, AppColors.primary);
      case PoiCategory.ev:
        return (Icons.electric_car, AppColors.teal);
      case PoiCategory.restaurant:
        return (Icons.restaurant, AppColors.warning);
      case PoiCategory.pureVeg:
        return (Icons.eco, AppColors.success);
      case PoiCategory.washroom:
        return (Icons.wc, AppColors.tealDark);
      case PoiCategory.atm:
        return (Icons.local_atm, AppColors.primaryDark);
      case PoiCategory.hotel:
        return (Icons.hotel, AppColors.primary);
      case PoiCategory.medical:
        return (Icons.local_hospital, AppColors.error);
      case PoiCategory.scenic:
        return (Icons.landscape, AppColors.tealLight);
      case PoiCategory.temple:
        return (Icons.temple_hindu, AppColors.warning);
      case PoiCategory.kidsStop:
        return (Icons.child_friendly, AppColors.primaryLight);
      case PoiCategory.mechanic:
        return (Icons.build, AppColors.textSecondary);
      case PoiCategory.parking:
        return (Icons.local_parking, AppColors.primaryDark);
      case PoiCategory.cafe:
        return (Icons.local_cafe, AppColors.warning);
      case PoiCategory.tourist:
        return (Icons.attractions, AppColors.tealDark);
      case PoiCategory.police:
        return (Icons.local_police, AppColors.primary);
    }
  }
}
