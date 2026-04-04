import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

class ContextStatsRow extends StatelessWidget {
  final double estimatedRangeKm;
  final double efficiencyKwh;

  const ContextStatsRow({
    super.key,
    required this.estimatedRangeKm,
    required this.efficiencyKwh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT CONTEXT',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          _StatLine(
            label: 'Est. Range Remaining',
            value: '${estimatedRangeKm.round()}',
            unit: ' km',
            valueColor: AppColors.success,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _StatLine(
            label: 'Efficiency',
            value: efficiencyKwh.toStringAsFixed(1),
            unit: ' kWH',
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color valueColor;

  const _StatLine({
    required this.label,
    required this.value,
    required this.unit,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        RichText(
          text: TextSpan(
            text: value,
            style: AppTextStyles.h4.copyWith(color: valueColor),
            children: [
              TextSpan(
                text: unit,
                style: AppTextStyles.bodySmall.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
