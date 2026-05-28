import 'package:flutter/material.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/community/presentation/widgets/poi_community_reports_section.dart';

/// Modal bottom sheet shown when the user taps a POI tile. Wraps the POI
/// summary + the POI-flavored community reports section (`P1-053`).
///
/// Phase 1 deliberately does not include a full POI detail screen — the
/// sheet is the discoverable surface. If a future task introduces a routed
/// detail screen, the same [PoiCommunityReportsSection] mounts there too.
Future<void> showPoiDetailSheet(BuildContext context, Poi poi) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _PoiDetailSheet(poi: poi),
  );
}

class _PoiDetailSheet extends StatelessWidget {
  const _PoiDetailSheet({required this.poi});
  final Poi poi;

  @override
  Widget build(BuildContext context) {
    final dist = poi.distanceAlongRouteKm;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.place,
                          size: 24,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(poi.name, style: AppTextStyles.h4),
                            const SizedBox(height: 2),
                            Text(
                              poi.category.label,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _SourceBadge(label: poi.source.label),
                    ],
                  ),
                  if (poi.address != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            poi.address!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (dist != null)
                        _FactPill(
                          icon: Icons.route,
                          label: '${dist.toStringAsFixed(1)} km on route',
                        ),
                      if (poi.rating > 0)
                        _FactPill(
                          icon: Icons.star,
                          iconColor: AppColors.warning,
                          label: poi.reviewCount > 0
                              ? '${poi.rating.toStringAsFixed(1)} (${poi.reviewCount})'
                              : poi.rating.toStringAsFixed(1),
                        ),
                      if (poi.openNow == true)
                        const _FactPill(
                          icon: Icons.check_circle_outline,
                          iconColor: AppColors.success,
                          label: 'Open now',
                        )
                      else if (poi.openNow == false)
                        const _FactPill(
                          icon: Icons.do_not_disturb_on_outlined,
                          iconColor: AppColors.error,
                          label: 'Closed',
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PoiCommunityReportsSection(poi: poi),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _FactPill extends StatelessWidget {
  const _FactPill({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor ?? AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
