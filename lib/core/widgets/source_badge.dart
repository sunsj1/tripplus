import 'package:flutter/material.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

/// P2-032 — Reusable, colour-coded provenance badge.
///
/// Single source of truth for "Official · Community · Curated · Unverified"
/// styling across POI tiles, detail sheets, and station screens.
class SourceBadge extends StatelessWidget {
  const SourceBadge({super.key, required this.source, this.compact = false});

  final PoiSource source;

  /// Compact = icon + no background fill (for dense list rows).
  final bool compact;

  ({Color fg, Color bg, IconData icon}) get _style {
    switch (source) {
      case PoiSource.googlePlaces:
      case PoiSource.ocm:
        return (
          fg: AppColors.accentBlue,
          bg: AppColors.accentBlue.withValues(alpha: 0.12),
          icon: Icons.verified_outlined,
        );
      case PoiSource.community:
        return (
          fg: AppColors.accentTeal,
          bg: AppColors.accentTeal.withValues(alpha: 0.12),
          icon: Icons.groups_outlined,
        );
      case PoiSource.curated:
        return (
          fg: AppColors.warning,
          bg: AppColors.warningSurface,
          icon: Icons.auto_awesome_outlined,
        );
      case PoiSource.unknown:
        return (
          fg: AppColors.textTertiary,
          bg: AppColors.surfaceElevated,
          icon: Icons.help_outline,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 12, color: s.fg),
          const SizedBox(width: 3),
          Text(
            source.label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: s.fg,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: s.fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 12, color: s.fg),
          const SizedBox(width: 4),
          Text(
            source.label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: s.fg,
            ),
          ),
        ],
      ),
    );
  }
}
