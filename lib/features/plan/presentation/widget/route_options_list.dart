import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/route_option.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

/// Google Maps–style list of driving route alternatives.
class RouteOptionsList extends StatelessWidget {
  const RouteOptionsList({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.isBike = false,
    this.routeMatchedToGps = false,
    this.onOpenMap,
  });

  final List<RouteOption> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool isBike;
  final bool routeMatchedToGps;
  final VoidCallback? onOpenMap;

  @override
  Widget build(BuildContext context) {
    if (options.length <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ROUTE OPTIONS',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (onOpenMap != null)
                TextButton.icon(
                  onPressed: onOpenMap,
                  icon: const Icon(Icons.map_outlined, size: 16),
                  label: const Text('Map'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(options.length, (i) {
            final option = options[i];
            final isSelected = i == selectedIndex;
            return Padding(
              padding: EdgeInsets.only(bottom: i < options.length - 1 ? 8 : 0),
              child: _RouteOptionCard(
                option: option,
                isSelected: isSelected,
                showTolls: !isBike,
                showGpsMatch: routeMatchedToGps && isSelected,
                onTap: () => onSelected(i),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RouteOptionCard extends StatelessWidget {
  const _RouteOptionCard({
    required this.option,
    required this.isSelected,
    required this.showTolls,
    required this.showGpsMatch,
    required this.onTap,
  });

  final RouteOption option;
  final bool isSelected;
  final bool showTolls;
  final bool showGpsMatch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeColor =
        option.isSuggested ? AppColors.success : AppColors.textPrimary;
    final mins = option.effectiveDurationMinutes;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySurface : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.directions_car_outlined,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatSummary(option.summary),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _fmtDuration(mins),
                          style: AppTextStyles.titleSmall.copyWith(
                            color: timeColor,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${option.distanceKm.round()} km',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (showTolls) ...[
                          const SizedBox(width: 8),
                          Text(
                            '· Tolls ${option.hasTolls ? 'Yes' : 'No'}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (showGpsMatch) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.my_location,
                            size: 12,
                            color: AppColors.primary.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Matched to your current road',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ] else if (option.isSuggested) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Suggested · fastest now',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSummary(String summary) {
    final s = summary.trim();
    if (s.toLowerCase().startsWith('via ')) return s;
    return 'via $s';
  }

  String _fmtDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h hr' : '$h hr $m min';
  }
}
