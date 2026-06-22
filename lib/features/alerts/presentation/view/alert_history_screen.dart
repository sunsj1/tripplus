import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/widgets/app_top_bar.dart';
import 'package:journeyplus/core/telemetry/app_telemetry.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';

/// Per-trip log of fired predictive alerts (`P1-034`).
class AlertHistoryScreen extends StatelessWidget {
  const AlertHistoryScreen({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    AppTelemetry.alertHistoryOpened(tripId: trip.id);

    final alerts = [...trip.firedAlerts]
      ..sort((a, b) => b.triggeredAt.compareTo(a.triggeredAt));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar(
              title: 'Alert history',
              showBack: true,
              onBack: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text(
                '${trip.from} → ${trip.to}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: alerts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No alerts fired on this trip yet.\n'
                          'Predictive alerts appear while you drive.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: alerts.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _AlertHistoryTile(alert: alerts[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertHistoryTile extends StatelessWidget {
  const _AlertHistoryTile({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final dt = alert.triggeredAt;
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final time =
        '$hour:${dt.minute.toString().padLeft(2, '0')} $amPm';
    final severityColor = switch (alert.severity) {
      AlertSeverity.critical => AppColors.error,
      AlertSeverity.warning => AppColors.warning,
      AlertSeverity.info => AppColors.primary,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  alert.type.label.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(alert.message, style: AppTextStyles.bodyMedium),
          if (alert.distanceKm != null) ...[
            const SizedBox(height: 6),
            Text(
              '${alert.distanceKm!.round()} km ahead',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
