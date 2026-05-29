import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/animated_list_item.dart';
import 'package:tripplus/core/widgets/app_top_bar.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';
import 'package:tripplus/features/plan/presentation/widget/smart_trip_timeline.dart';
import 'package:tripplus/features/plan/presentation/widget/stat_card.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_providers.dart';
import 'package:tripplus/features/stations/presentation/view/station_detail_screen.dart';
import 'package:tripplus/features/stations/presentation/widget/station_list_tile.dart';
import 'package:tripplus/features/trip/presentation/controller/trip_providers.dart';

/// Converts the current widget's fields into a [PlanResult] for the trip
/// controller. Helper kept outside the class to keep build() clean.
PlanResult _toPlanResult(PlanResultView v) => PlanResult(
      from: v.from,
      to: v.to,
      stations: v.stations,
      totalDistanceKm: v.totalDistanceKm,
      durationMinutes: v.durationMinutes,
      gaps: v.gaps,
      etaMinutes: v.etaMinutes,
      tollsEstimate: v.tollsEstimate,
      fuelEstimateCost: v.fuelEstimateCost,
      chargingEstimate: v.chargingEstimate,
      weatherTag: v.weatherTag,
      trafficLevel: v.trafficLevel,
      encodedRoutePolyline: v.encodedRoutePolyline,
    );

class PlanResultView extends ConsumerWidget {
  final String from;
  final String to;
  final List<ChargingStation> stations;
  final double totalDistanceKm;
  final int durationMinutes;
  final List<ChargingGap> gaps;
  final VoidCallback onBack;

  // P1-018 / P1-019 — cost/time estimates
  final int? etaMinutes;
  final double? tollsEstimate;
  final double? fuelEstimateCost;
  final double? chargingEstimate;
  final String? weatherTag;
  final String? trafficLevel;
  final String? encodedRoutePolyline;

  const PlanResultView({
    super.key,
    required this.from,
    required this.to,
    required this.stations,
    required this.totalDistanceKm,
    this.durationMinutes = 0,
    this.gaps = const [],
    required this.onBack,
    this.etaMinutes,
    this.tollsEstimate,
    this.fuelEstimateCost,
    this.chargingEstimate,
    this.weatherTag,
    this.trafficLevel,
    this.encodedRoutePolyline,
  });

  ChargingStation? get _nearestStation {
    if (stations.isEmpty) return null;
    return stations.reduce((a, b) =>
        (a.distanceKm ?? double.infinity) < (b.distanceKm ?? double.infinity)
            ? a
            : b);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxGap = gaps.isNotEmpty ? gaps.first.gapKm : 0.0;
    final nearest = _nearestStation;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              AppTopBar(title: 'Route Details', showBack: true, onBack: onBack),
              const SizedBox(height: 12),

              _RouteSummaryCard(
                from: from,
                to: to,
                stationCount: stations.length,
                totalDistanceKm: totalDistanceKm,
                durationMinutes: durationMinutes,
              ),
              const SizedBox(height: 16),

              // P1-019 — Trip Dashboard stat-card row
              _TripDashboardStatRow(
                etaMinutes: etaMinutes,
                tollsEstimate: tollsEstimate,
                costEstimate: fuelEstimateCost ?? chargingEstimate,
                isCharging: chargingEstimate != null,
                trafficLevel: trafficLevel,
              ),
              const SizedBox(height: 16),

              // P1-017 — "Start trip" action
              _StartTripButton(
                onStartTrip: () {
                  final profile = ref.read(profileControllerProvider).data;
                  final vehicle = profile.vehicle ??
                      const Vehicle(type: VehicleType.petrol);
                  ref
                      .read(activeTripControllerProvider.notifier)
                      .prepareTrip(plan: _toPlanResult(this), vehicle: vehicle);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Trip ready — go to the Trip tab to start!',
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // P1-020 / P1-021 — Smart Trip Timeline
              SmartTripTimeline(plan: _toPlanResult(this)),
              const SizedBox(height: 24),

              if (nearest != null) _NearestStationCard(station: nearest),
              if (nearest != null) const SizedBox(height: 16),

              if (gaps.isNotEmpty)
                _GapWarningBanner(
                  gapKm: gaps.first.gapKm,
                  afterStation: gaps.first.afterStation,
                ),
              if (gaps.isNotEmpty) const SizedBox(height: 16),

              _RouteStatsRow(
                stationCount: stations.length,
                maxGapKm: maxGap,
                coveragePercent: _coveragePercent(),
              ),
              const SizedBox(height: 12),
              _RouteRiskPanel(
                maxGapKm: maxGap,
                stationCount: stations.length,
                totalDistanceKm: totalDistanceKm,
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Stations on Route (${stations.length})',
                  style: AppTextStyles.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => AnimatedListItem(
              index: index,
              child: StationListTile(
                station: stations[index],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        StationDetailScreen(station: stations[index]),
                  ),
                ),
              ),
            ),
            childCount: stations.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  double _coveragePercent() {
    if (totalDistanceKm <= 0) return 100;
    final covered = stations.length * 30.0;
    return (covered / totalDistanceKm * 100).clamp(0, 100);
  }
}

// ---------------------------------------------------------------------------
// Nearest station suggestion
// ---------------------------------------------------------------------------
class _NearestStationCard extends StatelessWidget {
  final ChargingStation station;

  const _NearestStationCard({required this.station});

  @override
  Widget build(BuildContext context) {
    final dist = station.distanceKm ?? 0;
    final mins = (dist / 1.3).round();
    final hasFast = station.connections.any((c) => c.isFastCharge == true);
    final sourceTag = station.dataSource == 'google'
        ? 'Official'
        : 'Community-verified';

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StationDetailScreen(station: station),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.successSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.ev_station,
                size: 24,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEAREST STATION',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station.name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${hasFast ? "Fast charge" : "${station.connections.length} connectors"} · ~$mins min',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      sourceTag,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${dist.round()}',
                  style: AppTextStyles.h4.copyWith(color: AppColors.success),
                ),
                Text(
                  'km',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Route summary card  (Wrap for no overflow)
// ---------------------------------------------------------------------------
class _RouteSummaryCard extends StatelessWidget {
  final String from;
  final String to;
  final int stationCount;
  final double totalDistanceKm;
  final int durationMinutes;

  const _RouteSummaryCard({
    required this.from,
    required this.to,
    required this.stationCount,
    required this.totalDistanceKm,
    this.durationMinutes = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ROUTE ANALYSIS',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  from,
                  style: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.textOnDark),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.arrow_forward,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.7)),
              ),
              Expanded(
                child: Text(
                  to,
                  style: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.textOnDark),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryChip(
                icon: Icons.ev_station,
                text: '$stationCount stations',
              ),
              _SummaryChip(
                icon: Icons.straighten,
                text: '~${totalDistanceKm.round()} km',
              ),
              if (durationMinutes > 0)
                _SummaryChip(
                  icon: Icons.access_time,
                  text: '~${(durationMinutes / 60).toStringAsFixed(1)} hrs',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SummaryChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textOnDark),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _GapWarningBanner extends StatelessWidget {
  final double gapKm;
  final String afterStation;

  const _GapWarningBanner({
    required this.gapKm,
    required this.afterStation,
  });

  @override
  Widget build(BuildContext context) {
    final minCharge = gapKm > 120
        ? 90
        : gapKm > 80
            ? 80
            : gapKm > 60
                ? 70
                : 60;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 20,
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${gapKm.round()} km charging gap detected',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'After $afterStation — add a fallback charging stop.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _ActionChip(
                      icon: Icons.add_road_outlined,
                      text: 'Add backup stop now',
                    ),
                    _ActionChip(
                      icon: Icons.battery_6_bar,
                      text: 'Charge to at least $minCharge%',
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

class _RouteStatsRow extends StatelessWidget {
  final int stationCount;
  final double maxGapKm;
  final double coveragePercent;

  const _RouteStatsRow({
    required this.stationCount,
    required this.maxGapKm,
    required this.coveragePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _MiniStat(
            label: 'Stations',
            value: '$stationCount',
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          _MiniStat(
            label: 'Max Gap',
            value: '${maxGapKm.round()} km',
            color: maxGapKm > 40 ? AppColors.error : AppColors.success,
          ),
          const SizedBox(width: 10),
          _MiniStat(
            label: 'Coverage',
            value: '${coveragePercent.round()}%',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.h4.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteRiskPanel extends StatelessWidget {
  const _RouteRiskPanel({
    required this.maxGapKm,
    required this.stationCount,
    required this.totalDistanceKm,
  });

  final double maxGapKm;
  final int stationCount;
  final double totalDistanceKm;

  @override
  Widget build(BuildContext context) {
    final riskLevel = maxGapKm > 90
        ? 'High'
        : maxGapKm > 50
            ? 'Medium'
            : 'Low';
    final riskColor = maxGapKm > 90
        ? AppColors.error
        : maxGapKm > 50
            ? AppColors.warning
            : AppColors.success;

    final backupHint = stationCount <= 2 || maxGapKm > 60
        ? 'Strongly recommended'
        : 'Good to have';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: riskColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Reliability risk: $riskLevel',
              style: AppTextStyles.bodySmall.copyWith(
                color: riskColor,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Backup plan: $backupHint · ${totalDistanceKm.round()} km trip',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// P1-017 — Start trip button
// ---------------------------------------------------------------------------

class _StartTripButton extends StatelessWidget {
  const _StartTripButton({required this.onStartTrip});
  final VoidCallback onStartTrip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: onStartTrip,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          icon: const Icon(Icons.luggage_outlined),
          label: const Text('Start this trip'),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// P1-019 — Trip Dashboard stat-card row
// ---------------------------------------------------------------------------

/// Formats minutes as e.g. "2h 35m".
String _fmtDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

/// Formats a rupee amount as e.g. "₹1,240".
String _fmtRupees(double amount) {
  final rounded = amount.round();
  if (rounded >= 1000) {
    final formatted = (rounded / 1000).toStringAsFixed(1);
    return '₹${formatted}k';
  }
  return '₹$rounded';
}

class _TripDashboardStatRow extends StatelessWidget {
  final int? etaMinutes;
  final double? tollsEstimate;
  final double? costEstimate;
  final bool isCharging;
  final String? trafficLevel;

  const _TripDashboardStatRow({
    this.etaMinutes,
    this.tollsEstimate,
    this.costEstimate,
    required this.isCharging,
    this.trafficLevel,
  });

  Color _trafficColor(String? level) => switch (level) {
        'High' => AppColors.error,
        'Moderate' => AppColors.warning,
        _ => AppColors.success,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRIP OVERVIEW',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (etaMinutes != null)
                StatCard(
                  icon: Icons.schedule_outlined,
                  iconColor: AppColors.primary,
                  label: 'ETA',
                  value: _fmtDuration(etaMinutes!),
                ),
              if (etaMinutes != null) const SizedBox(width: 10),
              if (tollsEstimate != null)
                StatCard(
                  icon: Icons.toll_outlined,
                  iconColor: AppColors.warning,
                  label: 'Tolls',
                  value: _fmtRupees(tollsEstimate!),
                ),
              if (tollsEstimate != null) const SizedBox(width: 10),
              if (costEstimate != null)
                StatCard(
                  icon: isCharging
                      ? Icons.electric_bolt_outlined
                      : Icons.local_gas_station_outlined,
                  iconColor: isCharging ? AppColors.success : AppColors.primary,
                  label: isCharging ? 'Charging' : 'Fuel',
                  value: _fmtRupees(costEstimate!),
                ),
              if (costEstimate != null) const SizedBox(width: 10),
              if (trafficLevel != null)
                StatCard(
                  icon: Icons.traffic_outlined,
                  iconColor: _trafficColor(trafficLevel),
                  label: 'Traffic',
                  value: trafficLevel!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
