import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/animated_list_item.dart';
import 'package:tripplus/core/widgets/app_top_bar.dart';
import 'package:tripplus/features/insights/presentation/controller/insights_providers.dart';
import 'package:tripplus/features/insights/presentation/controller/insights_state.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/stations/presentation/view/station_detail_screen.dart';

// TODO(phase2-cleanup): InsightsScreen is orphan code — not mounted in AppShell
// nav since Session 6 (P1-016). The Insights tab was replaced by Discover + Profile.
// Safe to delete once Phase 2 confirms no deep-link or test reference exists.
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsState = ref.watch(insightsControllerProvider);

    // Auto-sync when plan finishes
    ref.listen<PlanState>(planControllerProvider, (prev, next) {
      if (next is PlanResult) {
        ref.read(insightsControllerProvider.notifier).loadFromRouteAnalysis(
              from: next.from,
              to: next.to,
              stations: next.stations,
              gaps: next.gaps,
              routeDistanceKm: next.totalDistanceKm,
              durationMinutes: next.durationMinutes,
            );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: insightsState.when(
          initial: () => _buildEmpty(context),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          loaded: (data) => _InsightsDashboard(data: data),
          error: (msg) => _buildError(msg),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.insights,
                  size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text('Route Insights', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              'Analyze a route in the Plan tab to see\ndetailed charging analytics,\ncost estimates, and gap analysis.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main dashboard body
// ---------------------------------------------------------------------------
class _InsightsDashboard extends StatelessWidget {
  final InsightsData data;
  const _InsightsDashboard({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        const SizedBox(height: 8),
        const AppTopBar(),
        const SizedBox(height: 4),

        // Route subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${data.from} → ${data.to}',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),

        // Health score hero
        _HealthScoreCard(
          score: data.healthScore,
          label: data.healthLabel,
          from: data.from,
          to: data.to,
          stationCount: data.totalStations,
          distanceKm: data.routeDistanceKm,
        ),
        const SizedBox(height: 20),

        // Key metrics grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'ROUTE METRICS',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _MetricsGrid(data: data),
        const SizedBox(height: 20),

        // Cost & Time estimate
        _CostTimeCard(data: data),
        const SizedBox(height: 20),

        // Gap analysis
        if (data.gaps.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Gap Analysis', style: AppTextStyles.titleMedium),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.maxGapKm > 60
                        ? AppColors.errorSurface
                        : AppColors.warningSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${data.gaps.length} gap${data.gaps.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: data.maxGapKm > 60
                          ? AppColors.error
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...data.gaps.asMap().entries.map((e) => AnimatedListItem(
                index: e.key,
                child: _GapTile(gap: e.value, index: e.key),
              )),
          const SizedBox(height: 20),
        ],

        // Station quality
        _StationQualityCard(data: data),
        const SizedBox(height: 20),

        // Top stations quick list
        if (data.topStations.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Nearest Stations', style: AppTextStyles.titleMedium),
          ),
          const SizedBox(height: 10),
          ...data.topStations.asMap().entries.map((e) => AnimatedListItem(
                index: e.key,
                child: _QuickStationTile(
                  station: e.value,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          StationDetailScreen(station: e.value),
                    ),
                  ),
                ),
              )),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Health score card
// ---------------------------------------------------------------------------
class _HealthScoreCard extends StatelessWidget {
  final int score;
  final String label;
  final String from;
  final String to;
  final int stationCount;
  final double distanceKm;

  const _HealthScoreCard({
    required this.score,
    required this.label,
    required this.from,
    required this.to,
    required this.stationCount,
    required this.distanceKm,
  });

  Color get _scoreColor {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.primary;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ROUTE HEALTH',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textOnDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$stationCount stations across\n${distanceKm.round()} km',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 7,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textOnDark,
                        height: 1,
                      ),
                    ),
                    Text(
                      '/100',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Metrics grid  (2×3)
// ---------------------------------------------------------------------------
class _MetricsGrid extends StatelessWidget {
  final InsightsData data;
  const _MetricsGrid({required this.data});

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              _MetricTile(
                icon: Icons.straighten,
                label: 'Distance',
                value: '${data.routeDistanceKm.round()} km',
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              _MetricTile(
                icon: Icons.access_time,
                label: 'Drive Time',
                value: _formatDuration(data.durationMinutes),
                color: AppColors.teal,
              ),
              const SizedBox(width: 10),
              _MetricTile(
                icon: Icons.ev_station,
                label: 'Stations',
                value: '${data.totalStations}',
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MetricTile(
                icon: Icons.swap_horiz,
                label: 'Avg Spacing',
                value: '${data.avgSpacingKm.round()} km',
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 10),
              _MetricTile(
                icon: Icons.warning_amber,
                label: 'Max Gap',
                value: '${data.maxGapKm.round()} km',
                color:
                    data.maxGapKm > 60 ? AppColors.error : AppColors.warning,
              ),
              const SizedBox(width: 10),
              _MetricTile(
                icon: Icons.bolt,
                label: 'Fast Charge',
                value: '${data.fastChargerPercent}%',
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.titleSmall.copyWith(
                color: color,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cost & time card
// ---------------------------------------------------------------------------
class _CostTimeCard extends StatelessWidget {
  final InsightsData data;
  const _CostTimeCard({required this.data});

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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRIP ESTIMATES',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          _EstimateLine(
            label: 'Charging Stops Needed',
            value: '${data.chargingStopsNeeded}',
            unit: ' stops',
            color: AppColors.primary,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _EstimateLine(
            label: 'Est. Charging Time',
            value: '~${data.estimatedChargingMinutes}',
            unit: ' min',
            color: AppColors.teal,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _EstimateLine(
            label: 'Est. Charging Cost',
            value: '₹${data.estimatedChargingCostRupees.round()}',
            unit: '',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _EstimateLine extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _EstimateLine({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
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
            style: AppTextStyles.h4.copyWith(color: color),
            children: [
              TextSpan(
                text: unit,
                style: AppTextStyles.bodySmall.copyWith(
                  color: color,
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

// ---------------------------------------------------------------------------
// Gap tile
// ---------------------------------------------------------------------------
class _GapTile extends StatelessWidget {
  final ChargingGap gap;
  final int index;

  const _GapTile({required this.gap, required this.index});

  @override
  Widget build(BuildContext context) {
    final isSevere = gap.gapKm > 60;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSevere ? AppColors.errorSurface : AppColors.warningSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (isSevere ? AppColors.error : AppColors.warning)
              .withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (isSevere ? AppColors.error : AppColors.warning)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isSevere ? Icons.warning_amber_rounded : Icons.info_outline,
              size: 18,
              color: isSevere ? AppColors.error : AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${gap.gapKm.round()} km gap',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isSevere ? AppColors.error : AppColors.warning,
                  ),
                ),
                Text(
                  'After ${gap.afterStation}',
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: (isSevere ? AppColors.error : AppColors.warning)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isSevere ? 'SEVERE' : 'MODERATE',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: isSevere ? AppColors.error : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Station quality card
// ---------------------------------------------------------------------------
class _StationQualityCard extends StatelessWidget {
  final InsightsData data;
  const _StationQualityCard({required this.data});

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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATION QUALITY',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _QualityStat(
                icon: Icons.bolt,
                label: 'Fast\nChargers',
                value: '${data.fastChargerCount}',
                color: AppColors.warning,
              ),
              const SizedBox(width: 12),
              _QualityStat(
                icon: Icons.verified,
                label: 'Verified\nStations',
                value: '${data.verifiedCount}',
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              _QualityStat(
                icon: Icons.power,
                label: 'Avg\nPower',
                value: '${data.avgPowerKw.round()} kW',
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QualityStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QualityStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick station tile
// ---------------------------------------------------------------------------
class _QuickStationTile extends StatelessWidget {
  final dynamic station;
  final VoidCallback onTap;

  const _QuickStationTile({required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dist = station.distanceKm ?? 0.0;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.ev_station,
                  size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name as String,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    station.address as String? ?? '',
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              '${(dist as double).round()} km',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
