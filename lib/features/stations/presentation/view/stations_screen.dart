import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/widgets/animated_list_item.dart';
import 'package:journeyplus/core/widgets/app_top_bar.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';
import 'package:journeyplus/features/charging/presentation/controller/charging_providers.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/stations/presentation/view/station_detail_screen.dart';
import 'package:journeyplus/features/stations/presentation/view/station_map_screen.dart';
import 'package:journeyplus/features/stations/presentation/widget/station_list_tile.dart';

// TODO(phase2-cleanup): StationsScreen is orphan code — not mounted in AppShell nav
// since Session 6 (P1-016). The Stations tab was replaced by Discovery + Trip.
// Safe to delete once Phase 2 confirms no deep-link or test reference exists.
class StationsScreen extends ConsumerStatefulWidget {
  const StationsScreen({super.key});

  @override
  ConsumerState<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends ConsumerState<StationsScreen> {
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // If no route data, load nearby stations
      final planState = ref.read(planControllerProvider);
      if (planState is! PlanResult) {
        ref.read(chargingControllerProvider.notifier).loadStations();
      }
    });
  }

  /// Prefer route stations if a route has been analyzed; otherwise
  /// fall back to nearby (current-location) stations.
  List<ChargingStation>? _resolveStations() {
    final planState = ref.watch(planControllerProvider);
    if (planState is PlanResult) {
      return planState.stations;
    }

    final chargingState = ref.watch(chargingControllerProvider);
    return chargingState.whenOrNull(loaded: (s) => s);
  }

  bool get _isLoading {
    final planState = ref.watch(planControllerProvider);
    if (planState is PlanResult) return false;

    final chargingState = ref.watch(chargingControllerProvider);
    return chargingState.maybeWhen(loading: () => true, orElse: () => false);
  }

  String? get _error {
    final planState = ref.watch(planControllerProvider);
    if (planState is PlanResult) return null;

    final chargingState = ref.watch(chargingControllerProvider);
    return chargingState.maybeWhen(error: (m) => m, orElse: () => null);
  }

  String get _headerSubtitle {
    final planState = ref.watch(planControllerProvider);
    if (planState is PlanResult) {
      return '${planState.from} → ${planState.to}';
    }
    return 'Near your location';
  }

  @override
  Widget build(BuildContext context) {
    final stations = _resolveStations();
    final loading = _isLoading;
    final error = _error;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const AppTopBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _headerSubtitle,
                      style: AppTextStyles.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (stations != null)
                    Text(
                      '${stations.length} stations',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            _TabBar(
              showMap: _showMap,
              onToggle: (v) => setState(() => _showMap = v),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildBody(stations, loading, error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
      List<ChargingStation>? stations, bool loading, String? error) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(error,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () =>
                    ref.read(chargingControllerProvider.notifier).loadStations(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (stations == null || stations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.ev_station_outlined,
                    size: 36, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text('No Stations', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              Text(
                'Analyze a route in the Plan tab\nor load nearby stations.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () =>
                    ref.read(chargingControllerProvider.notifier).loadStations(),
                child: const Text('Load Nearby'),
              ),
            ],
          ),
        ),
      );
    }

    if (_showMap) {
      return StationMapScreen(stations: stations);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () =>
          ref.read(chargingControllerProvider.notifier).loadStations(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: stations.length,
        itemBuilder: (_, i) => AnimatedListItem(
          index: i,
          child: StationListTile(
            station: stations[i],
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StationDetailScreen(station: stations[i]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final bool showMap;
  final ValueChanged<bool> onToggle;

  const _TabBar({required this.showMap, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          _Tab(
            label: 'List',
            icon: Icons.list_alt,
            isActive: !showMap,
            onTap: () => onToggle(false),
          ),
          _Tab(
            label: 'Map',
            icon: Icons.map_outlined,
            isActive: showMap,
            onTap: () => onToggle(true),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
