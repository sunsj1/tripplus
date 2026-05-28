import 'package:flutter/material.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

/// One row in the POI list. Community pulse chip is added in `P1-054`; this
/// tile leaves a `pulseSlot` placeholder so the future widget can drop in
/// without reflowing the layout.
class PoiListTile extends StatelessWidget {
  const PoiListTile({
    super.key,
    required this.poi,
    required this.onTap,
    this.pulseSlot,
  });

  final Poi poi;
  final VoidCallback onTap;
  final Widget? pulseSlot;

  @override
  Widget build(BuildContext context) {
    final dist = poi.distanceAlongRouteKm;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _iconFor(poi.category),
                size: 22,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poi.name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (poi.address != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      poi.address!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (dist != null) ...[
                        const Icon(Icons.route,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          '${dist.toStringAsFixed(1)} km on route',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      if (poi.rating > 0) ...[
                        const Icon(Icons.star,
                            size: 13, color: AppColors.warning),
                        const SizedBox(width: 3),
                        Text(
                          poi.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (poi.reviewCount > 0) ...[
                          const SizedBox(width: 3),
                          Text(
                            '(${poi.reviewCount})',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                        const SizedBox(width: 10),
                      ],
                      if (poi.openNow != null)
                        _OpenBadge(open: poi.openNow!),
                    ],
                  ),
                  if (pulseSlot != null) ...[
                    const SizedBox(height: 8),
                    pulseSlot!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(PoiCategory c) {
    switch (c) {
      case PoiCategory.fuel:
        return Icons.local_gas_station;
      case PoiCategory.ev:
        return Icons.electric_car;
      case PoiCategory.restaurant:
        return Icons.restaurant;
      case PoiCategory.pureVeg:
        return Icons.eco;
      case PoiCategory.washroom:
        return Icons.wc;
      case PoiCategory.atm:
        return Icons.local_atm;
      case PoiCategory.hotel:
        return Icons.hotel;
      case PoiCategory.medical:
        return Icons.local_hospital;
      case PoiCategory.scenic:
        return Icons.landscape;
      case PoiCategory.temple:
        return Icons.temple_hindu;
      case PoiCategory.kidsStop:
        return Icons.child_friendly;
      case PoiCategory.mechanic:
        return Icons.build;
      case PoiCategory.parking:
        return Icons.local_parking;
      case PoiCategory.cafe:
        return Icons.local_cafe;
      case PoiCategory.tourist:
        return Icons.attractions;
      case PoiCategory.police:
        return Icons.local_police;
    }
  }
}

class _OpenBadge extends StatelessWidget {
  const _OpenBadge({required this.open});
  final bool open;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: open ? AppColors.successSurface : AppColors.errorSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        open ? 'Open' : 'Closed',
        style: AppTextStyles.bodySmall.copyWith(
          color: open ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
