import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/discovery/presentation/view/emergency_screen.dart';
import 'package:tripplus/features/discovery/presentation/widget/emergency_pinned_tile.dart';
import 'package:tripplus/features/hidden_gems/presentation/widget/hidden_gems_carousel.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/pois/presentation/view/poi_category_screen.dart';
import 'package:tripplus/features/shell/presentation/controller/shell_providers.dart';

/// The iconic 3-column "Smart Intelligence Grid" (`P1-011`).
/// Each tile pushes [PoiCategoryScreen] for the tapped category (`P1-013`).
/// A pinned red [EmergencyPinnedTile] sits above the grid for SOS access.
/// When no route has been planned yet, a CTA banner guides users to Plan tab.
class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(planControllerProvider);
    final hasPlan = planState is PlanResult;

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
                    Text('Discover', style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Text(
                      hasPlan
                          ? 'Showing stops along your planned route.'
                          : 'Find anything along your route — chosen by '
                              'category, ranked by community trust.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // "Plan first" CTA — shown when no route has been analyzed yet.
            if (!hasPlan)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                sliver: SliverToBoxAdapter(
                  child: _NoPlanBanner(
                    onPlanTap: () => navigateToShellTab(ref, 0),
                  ),
                ),
              ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              sliver: SliverToBoxAdapter(
                child: EmergencyPinnedTile(
                  onTap: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const EmergencyScreen(),
                    ),
                  ),
                ),
              ),
            ),
            // P2-061 — Curated hidden-gem cards for the active corridor.
            const SliverToBoxAdapter(child: HiddenGemsCarousel()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
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

// ---------------------------------------------------------------------------
// "No plan" CTA banner
// ---------------------------------------------------------------------------
class _NoPlanBanner extends StatelessWidget {
  const _NoPlanBanner({required this.onPlanTap});
  final VoidCallback onPlanTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.route_outlined,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan a route to unlock corridor search',
                  style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  'Categories will filter to stops along your drive.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onPlanTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Plan',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category grid tile
// ---------------------------------------------------------------------------
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
            const SizedBox(height: 8),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  category.label,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
