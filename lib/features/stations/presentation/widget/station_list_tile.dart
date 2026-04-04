import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';

class StationListTile extends StatelessWidget {
  final ChargingStation station;
  final VoidCallback? onTap;

  const StationListTile({
    super.key,
    required this.station,
    this.onTap,
  });

  String _formatCost() {
    final cost = station.usageCost;
    if (cost == null || cost.isEmpty) return '';
    if (cost.contains('₹') || cost.contains('INR')) return cost;
    final numMatch = RegExp(r'[\d.]+').firstMatch(cost);
    if (numMatch != null) {
      final val = double.tryParse(numMatch.group(0) ?? '');
      if (val != null) return '₹${val.toStringAsFixed(1)}/kWh';
    }
    return cost;
  }

  @override
  Widget build(BuildContext context) {
    final dist = station.distanceKm ?? 0;
    final isOperational = station.isOperational == true;
    final cost = _formatCost();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isOperational
                    ? AppColors.successSurface
                    : AppColors.warningSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.ev_station,
                size: 24,
                color: isOperational ? AppColors.success : AppColors.warning,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    (station.address != null && station.address!.isNotEmpty)
                        ? station.address!
                        : 'Address: NA',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _Badge(
                        label: isOperational ? 'Operational' : 'Unknown',
                        color:
                            isOperational ? AppColors.success : AppColors.warning,
                      ),
                      if (station.connections.isNotEmpty)
                        _Badge(
                          label:
                              '${station.connections.length} Connector${station.connections.length > 1 ? 's' : ''}',
                          color: AppColors.primary,
                        ),
                      _Badge(
                        label: cost.isNotEmpty ? cost : 'Price: NA',
                        color: cost.isNotEmpty ? AppColors.teal : AppColors.textTertiary,
                      ),
                      _Badge(
                        label: station.dataSource == 'google' ? 'Google' : 'OCM',
                        color: station.dataSource == 'google'
                            ? const Color(0xFF4285F4)
                            : AppColors.primaryLight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dist.toStringAsFixed(1),
                  style: AppTextStyles.h4.copyWith(fontSize: 20),
                ),
                Text(
                  'km',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.3,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
