import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/shell/presentation/controller/shell_providers.dart';
import 'package:journeyplus/features/trip/domain/models/trip.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_replan_provider.dart';
import 'package:journeyplus/features/trip/presentation/utils/share_trip.dart';
import 'package:journeyplus/features/trip/presentation/utils/trip_formatters.dart';

/// On-device trip archive — route labels and estimates only, no GPS trails.
///
/// P2-050 — Cards are now tappable: opens a per-trip detail screen with the
/// full stat breakdown and a `Plan again` CTA (P2-051).
class TripHistoryScreen extends ConsumerStatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  ConsumerState<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

enum _SortMode { newest, longest, farthest }

class _TripHistoryScreenState extends ConsumerState<TripHistoryScreen> {
  _SortMode _sort = _SortMode.newest;

  List<Trip> _applySort(List<Trip> trips) {
    final list = [...trips];
    switch (_sort) {
      case _SortMode.newest:
        list.sort((a, b) {
          final ax = a.completedAt ?? a.createdAt;
          final bx = b.completedAt ?? b.createdAt;
          return bx.compareTo(ax);
        });
      case _SortMode.longest:
        list.sort((a, b) => b.elapsed.compareTo(a.elapsed));
      case _SortMode.farthest:
        list.sort(
            (a, b) => b.totalDistanceKm.compareTo(a.totalDistanceKm));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final trips = _applySort(ref.watch(tripHistoryProvider));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text('Trip history', style: AppTextStyles.titleMedium),
      ),
      body: SafeArea(
        child: trips.isEmpty
            ? _EmptyState()
            : Column(
                children: [
                  _SortBar(
                    active: _sort,
                    onChange: (m) => setState(() => _sort = m),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      itemCount: trips.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          _HistoryCard(trip: trips[index]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('No trips yet', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              'Completed trips are saved here on your device only — '
              'not uploaded as location history.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  const _SortBar({required this.active, required this.onChange});

  final _SortMode active;
  final ValueChanged<_SortMode> onChange;

  String _labelFor(_SortMode m) {
    switch (m) {
      case _SortMode.newest:
        return 'Newest';
      case _SortMode.longest:
        return 'Longest';
      case _SortMode.farthest:
        return 'Farthest';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          for (final m in _SortMode.values) ...[
            ChoiceChip(
              label: Text(_labelFor(m)),
              selected: active == m,
              onSelected: (_) => onChange(m),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.trip});

  final Trip trip;

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} · $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final ended = trip.completedAt ?? trip.createdAt;
    final duration = formatElapsedMinutesOnly(trip.elapsed);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => _TripDetailScreen(trip: trip),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${trip.from} → ${trip.to}',
                style: AppTextStyles.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                _formatDate(ended),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _Chip(text: duration, icon: Icons.timer_outlined),
                  _Chip(
                    text: '${trip.totalDistanceKm.round()} km',
                    icon: Icons.straighten,
                  ),
                  _Chip(
                    text: trip.vehicle.type.label,
                    icon: Icons.directions_car_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// P2-050 — Per-trip detail with P2-051 "Plan again" CTA.
// ---------------------------------------------------------------------------
class _TripDetailScreen extends ConsumerWidget {
  const _TripDetailScreen({required this.trip});

  final Trip trip;

  String _formatStartEnd(DateTime? at) {
    if (at == null) return '—';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = at.hour % 12 == 0 ? 12 : at.hour % 12;
    final m = at.minute.toString().padLeft(2, '0');
    return '${at.day} ${months[at.month - 1]} · $h:$m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text('Trip', style: AppTextStyles.titleMedium),
        actions: [
          // P2-052 — Drop the trip into the OS share sheet.
          IconButton(
            tooltip: 'Share',
            onPressed: () => shareTrip(context, trip),
            icon: const Icon(Icons.ios_share_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${trip.from} → ${trip.to}',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 4),
              Text(
                'Completed · ${_formatStartEnd(trip.completedAt ?? trip.createdAt)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 20),
              _DetailGrid(trip: trip),
              const SizedBox(height: 24),

              // P2-051 — One-tap re-plan: stash labels then jump to Plan tab.
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () {
                    ref.read(tripReplanRequestProvider.notifier).state =
                        TripReplanRequest(from: trip.from, to: trip.to);
                    navigateToShellTab(ref, 0); // Plan tab
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Plan this trip again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailGrid extends StatelessWidget {
  const _DetailGrid({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final cells = <_Cell>[
      _Cell(
        icon: Icons.timer_outlined,
        label: 'Duration',
        value: formatElapsedMinutesOnly(trip.elapsed),
      ),
      _Cell(
        icon: Icons.straighten,
        label: 'Distance',
        value: '${trip.totalDistanceKm.round()} km',
      ),
      _Cell(
        icon: trip.vehicle.type == VehicleType.ev
            ? Icons.electric_car
            : Icons.directions_car_outlined,
        label: 'Vehicle',
        value: trip.vehicle.type.label,
      ),
      if (trip.etaMinutes != null)
        _Cell(
          icon: Icons.schedule,
          label: 'Planned ETA',
          value: _fmtMinutes(trip.etaMinutes!),
        ),
      if (trip.displayHasTolls != null)
        _Cell(
          icon: Icons.toll_outlined,
          label: 'Tolls',
          value: trip.displayHasTolls! ? 'Yes' : 'No',
        ),
      if (trip.tripCostEstimate != null)
        _Cell(
          icon: trip.isCostCharging
              ? Icons.bolt_outlined
              : Icons.local_gas_station_outlined,
          label: trip.isCostCharging ? 'Charging~' : 'Fuel~',
          value: '₹${trip.tripCostEstimate!.round()}',
        ),
      if (trip.firedAlerts.isNotEmpty)
        _Cell(
          icon: Icons.notifications_active_outlined,
          label: 'Alerts fired',
          value: '${trip.firedAlerts.length}',
        ),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final c in cells)
          SizedBox(
            width: (MediaQuery.of(context).size.width - 50) / 2,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(c.icon, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        c.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(c.value, style: AppTextStyles.titleSmall),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _fmtMinutes(int m) {
    if (m < 60) return '${m}m';
    final h = m ~/ 60;
    final mm = m % 60;
    return mm == 0 ? '${h}h' : '${h}h ${mm}m';
  }
}

class _Cell {
  const _Cell({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
}
