import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';

class UpcomingStationTile extends StatelessWidget {
  final ChargingStation station;
  final VoidCallback? onTap;

  const UpcomingStationTile({
    super.key,
    required this.station,
    this.onTap,
  });

  String get _speedLabel {
    final conns = station.connections;
    if (conns.isEmpty) return 'Standard';
    final hasFast = conns.any((c) => c.isFastCharge == true);
    final maxPower =
        conns.fold<double>(0, (m, c) => (c.powerKw ?? 0) > m ? (c.powerKw ?? 0) : m);
    if (maxPower > 100) return 'Ultra Fast';
    if (hasFast) return 'High Speed';
    return 'Standard';
  }

  IconData get _speedIcon {
    final label = _speedLabel;
    if (label == 'Ultra Fast') return Icons.bolt;
    if (label == 'High Speed') return Icons.ev_station;
    return Icons.electrical_services;
  }

  int get _availableCount {
    return station.connections.where((c) => c.isOperational == true).length;
  }

  @override
  Widget build(BuildContext context) {
    final dist = station.distanceKm ?? 0;
    final minutes = (dist / 1.3).round();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_speedIcon, size: 22, color: AppColors.primary),
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
                    '${_availableCount > 0 ? '$_availableCount/${station.connections.length} Stalls Available' : '${station.connections.length} Connectors'} · $_speedLabel',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${dist.round()}',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'km',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'IN $minutes MINS',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
