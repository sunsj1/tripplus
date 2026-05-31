import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/core/utils/trip_plan_copy.dart';
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
import 'package:tripplus/features/shell/presentation/controller/shell_providers.dart';
import 'package:tripplus/features/trip/presentation/controller/trip_providers.dart';
import 'package:tripplus/features/trip/presentation/widget/route_trip_actions.dart';

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
  final VehicleType? vehicleType;
  final UserPreferences? tripPreferences;
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

  bool get _isEv => TripPlanCopy.isEv(vehicleType);

  const PlanResultView({
    super.key,
    required this.from,
    required this.to,
    this.vehicleType,
    this.tripPreferences,
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
    final maxGap = _isEv && gaps.isNotEmpty ? gaps.first.gapKm : 0.0;
    final nearest = _isEv ? _nearestStation : null;
    final plan = _toPlanResult(this);

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
                vehicleType: vehicleType,
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

              RouteTripActions(
                from: from,
                to: to,
                onPrepareTrip: () async {
                  final profile = ref.read(profileControllerProvider).data;
                  final vehicle = profile.vehicle ??
                      const Vehicle(type: VehicleType.petrol);
                  await ref
                      .read(activeTripControllerProvider.notifier)
                      .prepareTrip(plan: plan, vehicle: vehicle);
                  navigateToShellTab(ref, 1);
                },
              ),
              const SizedBox(height: 24),

              SmartTripTimeline(
                plan: plan,
                isEv: _isEv,
                preferences: tripPreferences,
              ),
              const SizedBox(height: 20),

              if (_isEv && nearest != null) ...[
                _NearestStationCard(station: nearest),
                const SizedBox(height: 16),
              ],

              if (_isEv && gaps.isNotEmpty) ...[
                _GapWarningBanner(
                  gapKm: gaps.first.gapKm,
                  afterStation: gaps.first.afterStation,
                ),
                const SizedBox(height: 16),
              ],

              if (_isEv) ...[
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
              ],
            ],
          ),
        ),
        // EV charger list with fast-charge filter chip
        if (_isEv)
          SliverToBoxAdapter(
            child: _EvStationListSection(stations: stations),
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
  final VehicleType? vehicleType;
  final int stationCount;
  final double totalDistanceKm;
  final int durationMinutes;

  const _RouteSummaryCard({
    required this.from,
    required this.to,
    required this.vehicleType,
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
        gradient: TripPlanCopy.isEv(vehicleType)
            ? AppColors.routeHeroGradientEv
            : AppColors.routeHeroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: (TripPlanCopy.isEv(vehicleType)
                    ? AppColors.primary
                    : AppColors.accentBlue)
                .withValues(alpha: 0.22),
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
                icon: Icons.straighten,
                text: '~${totalDistanceKm.round()} km',
              ),
              if (durationMinutes > 0)
                _SummaryChip(
                  icon: Icons.access_time,
                  text: '~${(durationMinutes / 60).toStringAsFixed(1)} hrs',
                ),
              if (TripPlanCopy.isEv(vehicleType) && stationCount > 0)
                _SummaryChip(
                  icon: TripPlanCopy.summaryStopsIcon(vehicleType),
                  text: TripPlanCopy.summaryStopsLabel(vehicleType, stationCount),
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
          Row(
            children: [
              Text(
                'TRIP OVERVIEW',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '· estimates only',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary.withValues(alpha: 0.65),
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Row(
                    children: _statChildren(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _statChildren() {
    final children = <Widget>[];
    void add(Widget w) {
      if (children.isNotEmpty) children.add(const SizedBox(width: 10));
      children.add(w);
    }

    if (etaMinutes != null) {
      add(
        StatCard(
          compact: true,
          icon: Icons.schedule_outlined,
          iconColor: AppColors.accentBlue,
          label: 'ETA',
          value: '~${_fmtDuration(etaMinutes!)}',
        ),
      );
    }
    if (tollsEstimate != null) {
      add(
        StatCard(
          compact: true,
          icon: Icons.toll_outlined,
          iconColor: AppColors.accentAmber,
          label: 'Tolls',
          value: '~${_fmtRupees(tollsEstimate!)}',
        ),
      );
    }
    if (costEstimate != null) {
      add(
        StatCard(
          compact: true,
          icon: isCharging
              ? Icons.electric_bolt_outlined
              : Icons.local_gas_station_outlined,
          iconColor: isCharging ? AppColors.accentTeal : AppColors.primary,
          label: isCharging ? 'Charging' : 'Fuel',
          value: '~${_fmtRupees(costEstimate!)}',
        ),
      );
    }
    if (trafficLevel != null) {
      add(
        StatCard(
          compact: true,
          icon: Icons.traffic_outlined,
          iconColor: _trafficColor(trafficLevel),
          label: 'Traffic',
          value: trafficLevel!,
        ),
      );
    }
    return children;
  }
}

// ---------------------------------------------------------------------------
// EV charger list with fast-charge filter chip
// ---------------------------------------------------------------------------
class _EvStationListSection extends StatefulWidget {
  const _EvStationListSection({required this.stations});
  final List<ChargingStation> stations;

  @override
  State<_EvStationListSection> createState() => _EvStationListSectionState();
}

class _EvStationListSectionState extends State<_EvStationListSection> {
  bool _fastChargeOnly = false;

  bool _isFast(ChargingStation s) =>
      s.connections.any((c) => c.isFastCharge == true);

  @override
  Widget build(BuildContext context) {
    final hasFastChargers = widget.stations.any(_isFast);
    final displayed = _fastChargeOnly
        ? widget.stations.where(_isFast).toList()
        : widget.stations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Row(
            children: [
              Text(
                'Chargers on route (${displayed.length})',
                style: AppTextStyles.titleMedium,
              ),
              const Spacer(),
              if (hasFastChargers)
                FilterChip(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt,
                          size: 14,
                          color: _fastChargeOnly
                              ? AppColors.success
                              : AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        'Fast only',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _fastChargeOnly
                              ? AppColors.success
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  selected: _fastChargeOnly,
                  showCheckmark: false,
                  selectedColor: AppColors.successSurface,
                  backgroundColor: AppColors.surface,
                  side: BorderSide(
                    color: _fastChargeOnly
                        ? AppColors.success.withValues(alpha: 0.4)
                        : AppColors.borderLight,
                  ),
                  onSelected: (v) => setState(() => _fastChargeOnly = v),
                ),
            ],
          ),
        ),
        ...displayed.asMap().entries.map(
              (e) => AnimatedListItem(
                index: e.key,
                child: StationListTile(
                  station: e.value,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => StationDetailScreen(station: e.value),
                    ),
                  ),
                ),
              ),
            ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
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
