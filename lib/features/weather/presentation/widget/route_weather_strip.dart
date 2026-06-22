import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/widgets/horizontal_scroll_row.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/weather/domain/route_weather_segment.dart';
import 'package:tripplus/features/weather/presentation/controller/weather_providers.dart';

/// P2-040 — Horizontal weather card row showing conditions at each sample
/// point along the trip. Renders nothing until the future resolves to a
/// non-empty list, so a failed Open-Meteo call leaves the timeline untouched.
class RouteWeatherStrip extends ConsumerWidget {
  const RouteWeatherStrip({super.key, required this.plan});

  final PlanResult plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(routeWeatherProvider(plan));

    return async.when(
      data: (segments) {
        if (segments.isEmpty) return const SizedBox.shrink();
        return _Strip(segments: segments);
      },
      loading: () => const _LoadingStrip(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// ---------------------------------------------------------------------------
class _Strip extends StatelessWidget {
  const _Strip({required this.segments});
  final List<RouteWeatherSegment> segments;

  @override
  Widget build(BuildContext context) {
    final hazardCount = segments.where((s) => s.isDrivingHazard).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'WEATHER ON ROUTE',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
              if (hazardCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$hazardCount caution',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          HorizontalScrollRow(
            itemCount: segments.length,
            separator: 10,
            itemBuilder: (_, i) => _SegmentCard(segment: segments[i]),
          ),
        ],
      ),
    );
  }
}

class _SegmentCard extends StatelessWidget {
  const _SegmentCard({required this.segment});
  final RouteWeatherSegment segment;

  @override
  Widget build(BuildContext context) {
    final hazard = segment.isDrivingHazard;
    final color = hazard ? AppColors.warning : AppColors.primary;

    return Container(
      width: 122,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hazard
              ? AppColors.warning.withValues(alpha: 0.35)
              : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(_iconFor(segment.weatherCode), size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  segment.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${segment.temperatureC.round()}°',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 12.5),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  segment.conditionLabel,
                  style: AppTextStyles.titleSmall.copyWith(fontSize: 12.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            segment.precipitationMm > 0
                ? '${segment.precipitationMm.toStringAsFixed(1)}mm · '
                    '${segment.windKph.round()} kmh'
                : '${segment.windKph.round()} kmh wind',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              color: AppColors.textTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _iconFor(int code) {
    if (code == 0) return Icons.wb_sunny_outlined;
    if (code <= 3) return Icons.cloud_outlined;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.water_drop_outlined;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 80 && code <= 82) return Icons.umbrella_outlined;
    if (code >= 95) return Icons.thunderstorm_outlined;
    return Icons.cloud_outlined;
  }
}

class _LoadingStrip extends StatelessWidget {
  const _LoadingStrip();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Text(
            'Fetching weather along your route…',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
