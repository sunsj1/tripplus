import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? unit;
  final String? subtitle;
  final bool compact;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.unit,
    this.subtitle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
        padding: EdgeInsets.all(compact ? 14 : 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: compact ? 22 : 28, color: iconColor),
            SizedBox(height: compact ? 10 : 14),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: value,
                  style: AppTextStyles.stat.copyWith(fontSize: 22),
                  children: [
                    if (unit != null)
                      TextSpan(
                        text: unit,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 9,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
    );
    if (compact) {
      return SizedBox(width: 104, child: card);
    }
    return Expanded(child: card);
  }
}
