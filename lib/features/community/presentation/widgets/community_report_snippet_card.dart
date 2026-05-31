import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/community/domain/community_target_type.dart';
import 'package:tripplus/features/community/domain/models/station_community_report.dart';
class CommunityReportSnippetCard extends StatelessWidget {
  final StationCommunityReport report;
  final String timeLabel;

  const CommunityReportSnippetCard({
    super.key,
    required this.report,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final tone = _toneForReport(report);
    Uint8List? thumb;
    final raw = report.photoBase64;
    if (raw != null && raw.isNotEmpty) {
      try {
        thumb = base64Decode(raw);
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tone.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tone.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (thumb != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                thumb,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(tone.icon, size: 16, color: tone.fg),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        tone.headline,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: tone.fg,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      timeLabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppColors.warning,
                    ),
                    Text(
                      '${report.rating}/5',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (report.reporterDisplayName != null &&
                        report.reporterDisplayName!.trim().isNotEmpty) ...[
                      Text(
                        ' · ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          report.reporterDisplayName!.trim(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                if (report.costPerKwh != null &&
                    report.costPerKwh!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Price: ${_formatPrice(report.costPerKwh)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (report.availableAmenityLabels.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    report.availableAmenityLabels.join(' · '),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (report.washroomAvailable == true) ...[
                  const SizedBox(height: 2),
                  Text(
                    _washroomLine(report),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (report.chargeSuccessful != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    report.chargeSuccessful == true
                        ? 'Charge completed successfully'
                        : 'Could not complete charge',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: report.chargeSuccessful == true
                          ? AppColors.success
                          : AppColors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (report.comment != null && report.comment!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '“${report.comment!.trim()}”',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tone {
  const _Tone({
    required this.bg,
    required this.border,
    required this.fg,
    required this.icon,
    required this.headline,
  });

  final Color bg;
  final Color border;
  final Color fg;
  final IconData icon;
  final String headline;
}

/// Returns display tone that is **context-aware**: EV station reports use
/// charging-specific language; POI reports use neutral place language.
_Tone _toneForReport(StationCommunityReport report) {
  final isPoi = report.targetType == CommunityTargetType.poi;
  final condition = report.condition;

  if (isPoi) {
    // POI-specific tones keyed on the values sent by [showPoiReportSheet]:
    // 'good' | 'fair' | 'poor', and rating for extra signal.
    switch (condition) {
      case 'poor':
      case 'down':
        return _Tone(
          bg: AppColors.errorSurface,
          border: AppColors.error.withValues(alpha: 0.12),
          fg: AppColors.error,
          icon: Icons.sentiment_dissatisfied_outlined,
          headline: 'Disappointing experience',
        );
      case 'fair':
      case 'issues':
        return _Tone(
          bg: AppColors.warningSurface,
          border: AppColors.warning.withValues(alpha: 0.15),
          fg: AppColors.warning,
          icon: Icons.sentiment_neutral_outlined,
          headline: 'Worth checking yourself',
        );
      default: // 'good', 'working', anything positive
        return _Tone(
          bg: AppColors.successSurface,
          border: AppColors.success.withValues(alpha: 0.12),
          fg: AppColors.success,
          icon: Icons.sentiment_satisfied_alt_outlined,
          headline: 'Visited — all good',
        );
    }
  }

  // EV / fuel station — original language preserved.
  switch (condition) {
    case 'down':
      return _Tone(
        bg: AppColors.errorSurface,
        border: AppColors.error.withValues(alpha: 0.12),
        fg: AppColors.error,
        icon: Icons.sentiment_dissatisfied_outlined,
        headline: 'Chargers looked offline',
      );
    case 'issues':
      return _Tone(
        bg: AppColors.warningSurface,
        border: AppColors.warning.withValues(alpha: 0.15),
        fg: AppColors.warning,
        icon: Icons.sentiment_neutral_outlined,
        headline: 'Mixed — worth a look',
      );
    default:
      return _Tone(
        bg: AppColors.successSurface,
        border: AppColors.success.withValues(alpha: 0.12),
        fg: AppColors.success,
        icon: Icons.sentiment_satisfied_alt_outlined,
        headline: 'Charging looked good',
      );
  }
}

String _washroomLine(StationCommunityReport r) {
  final clean = r.washroomClean == true
      ? 'clean'
      : r.washroomClean == false
          ? 'needs care'
          : 'cleanliness unknown';
  final women = r.womenFriendlyWashroom == true
      ? 'women-friendly'
      : r.womenFriendlyWashroom == false
          ? 'women access unclear'
          : '';
  if (women.isEmpty) return 'Washroom · $clean';
  return 'Washroom · $clean · $women';
}

String _formatPrice(String? raw) {
  final v = raw?.trim();
  if (v == null || v.isEmpty) return 'NA';
  if (v.contains('₹') || v.contains('INR')) return '$v / kWh';
  final numeric = RegExp(r'[\d.]+').firstMatch(v)?.group(0);
  if (numeric != null) return '₹$numeric / kWh';
  return '$v / kWh';
}
