import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/fuel_brand.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/utils/failure.dart';
import 'package:tripplus/features/community/presentation/widgets/poi_community_rating_pulse.dart';
import 'package:tripplus/features/personalization/domain/mode_filter.dart';
import 'package:tripplus/features/personalization/domain/route_mode.dart';
import 'package:tripplus/features/personalization/presentation/controller/personalization_providers.dart';
import 'package:tripplus/features/personalization/presentation/controller/route_mode_provider.dart';
import 'package:tripplus/features/personalization/presentation/widget/mode_badges.dart';
import 'package:tripplus/features/personalization/presentation/widget/route_mode_bar.dart';
import 'package:tripplus/features/pois/presentation/controller/poi_category_ui_state.dart';
import 'package:tripplus/features/pois/presentation/controller/pois_providers.dart';
import 'package:tripplus/features/pois/presentation/widget/poi_category_map_view.dart';
import 'package:tripplus/features/pois/presentation/widget/poi_detail_sheet.dart';
import 'package:tripplus/core/telemetry/app_telemetry.dart';
import 'package:tripplus/core/widgets/poi_list_skeleton.dart';
import 'package:tripplus/features/pois/presentation/widget/poi_list_tile.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_providers.dart';

/// Reusable category screen (`P1-012`). Decides between route-aware and nearby
/// query in the controller; this widget just renders the result with a
/// list ⇄ map toggle (`P1-015`) and the standard loading/empty/error states
/// (`P1-014`).
class PoiCategoryScreen extends ConsumerStatefulWidget {
  const PoiCategoryScreen({super.key, required this.category});
  final PoiCategory category;

  @override
  ConsumerState<PoiCategoryScreen> createState() => _PoiCategoryScreenState();
}

enum _ViewMode { list, map }

class _PoiCategoryScreenState extends ConsumerState<PoiCategoryScreen> {
  _ViewMode _mode = _ViewMode.list;

  @override
  void initState() {
    super.initState();
    AppTelemetry.poiCategoryOpened(category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(poiCategoryControllerProvider(widget.category));
    final controller =
        ref.read(poiCategoryControllerProvider(widget.category).notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(widget.category.label, style: AppTextStyles.titleMedium),
        actions: [
          if (state is PoiCategoryData)
            IconButton(
              tooltip: _mode == _ViewMode.list ? 'Show map' : 'Show list',
              icon: Icon(
                _mode == _ViewMode.list
                    ? Icons.map_outlined
                    : Icons.list_alt_rounded,
              ),
              onPressed: () => setState(() {
                _mode = _mode == _ViewMode.list ? _ViewMode.map : _ViewMode.list;
              }),
            ),
        ],
      ),
      body: SafeArea(
        child: switch (state) {
          PoiCategoryLoading() => const PoiListSkeleton(),
          PoiCategoryEmpty(:final reason) => _Empty(
              reason: reason,
              onRetry: controller.refresh,
            ),
          PoiCategoryErrored(:final failure) => _Errored(
              failure: failure,
              onRetry: controller.refresh,
            ),
          PoiCategoryData(
            :final pois,
            :final source,
            :final currentPositionKm,
          ) =>
            _mode == _ViewMode.list
                ? _List(
                    pois: pois,
                    source: source,
                    currentPositionKm: currentPositionKm,
                    // Pass preferred fuel brands so Fuel category can boost
                    // matching stations to the top of the list.
                    preferredFuelBrands: widget.category == PoiCategory.fuel
                        ? ref
                            .read(profileControllerProvider)
                            .data
                            .preferences
                            .selectedFuelBrands
                        : const [],
                  )
                : PoiCategoryMapView(pois: pois),
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

class _Empty extends StatelessWidget {
  const _Empty({required this.reason, required this.onRetry});
  final String reason;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
              child: const Icon(
                Icons.travel_explore_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text('Nothing to show', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              reason,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// P2 Session 5 — Shown when an active [RouteMode] filters every result out.
class _ModeFilteredEmpty extends ConsumerWidget {
  const _ModeFilteredEmpty({required this.mode});
  final RouteMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                color: mode.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(mode.icon, size: 32, color: mode.accent),
            ),
            const SizedBox(height: 18),
            Text(
              'Nothing matches ${mode.label} Mode here',
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Switch back to Standard to see every result.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () =>
                  ref.read(routeModeProvider.notifier).state = RouteMode.off,
              style: FilledButton.styleFrom(backgroundColor: mode.accent),
              icon: const Icon(Icons.tune_outlined, size: 16),
              label: const Text('Clear mode'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Errored extends StatelessWidget {
  const _Errored({required this.failure, required this.onRetry});
  final Failure failure;
  final VoidCallback onRetry;

  IconData get _icon {
    return switch (failure) {
      NetworkFailure() => Icons.wifi_off_rounded,
      PermissionFailure() => Icons.lock_outline_rounded,
      IndexFailure() => Icons.hourglass_top_rounded,
      QuotaFailure() => Icons.speed_rounded,
      _ => Icons.error_outline_rounded,
    };
  }

  String get _headline {
    return switch (failure) {
      NetworkFailure() => 'You\'re offline',
      PermissionFailure() => 'Permission needed',
      IndexFailure() => 'Almost ready',
      QuotaFailure() => 'Daily limit reached',
      _ => 'Something went wrong',
    };
  }

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.errorSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(_icon, size: 36, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            Text(_headline, style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              failure.message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(failure.actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sort modes for the POI list
// ---------------------------------------------------------------------------
enum _SortMode { bestMatch, nearest, topRated, openNow }

extension _SortModeX on _SortMode {
  String get label {
    switch (this) {
      case _SortMode.bestMatch:
        return 'Best match';
      case _SortMode.nearest:
        return 'Nearest';
      case _SortMode.topRated:
        return 'Top rated';
      case _SortMode.openNow:
        return 'Open now';
    }
  }

  IconData get icon {
    switch (this) {
      case _SortMode.bestMatch:
        return Icons.auto_awesome_outlined;
      case _SortMode.nearest:
        return Icons.near_me_outlined;
      case _SortMode.topRated:
        return Icons.star_outline_rounded;
      case _SortMode.openNow:
        return Icons.schedule_outlined;
    }
  }
}

class _List extends ConsumerStatefulWidget {
  const _List({
    required this.pois,
    required this.source,
    this.currentPositionKm,
    this.preferredFuelBrands = const [],
  });
  final List<Poi> pois;
  final PoiQuerySource source;

  /// Driver position along the route (active trip) for proximity scoring.
  final double? currentPositionKm;

  /// For [PoiCategory.fuel]: brands the user prefers (from profile).
  /// Matching POIs are promoted to the top of "Nearest" sort.
  final List<FuelBrand> preferredFuelBrands;

  @override
  ConsumerState<_List> createState() => _ListState();
}

class _ListState extends ConsumerState<_List> {
  // P2-012 — default to personalized "Best match" ranking.
  _SortMode _sort = _SortMode.bestMatch;

  bool _isBrandMatch(Poi poi) {
    if (widget.preferredFuelBrands.isEmpty) return false;
    final lower = poi.name.toLowerCase();
    return widget.preferredFuelBrands
        .any((b) => lower.contains(b.label.toLowerCase()));
  }

  List<Poi> get _sorted {
    final list = [...widget.pois];
    switch (_sort) {
      case _SortMode.bestMatch:
        // P2-012 — PoiRanker blends quality, proximity, openness + preferences.
        final ranker = ref.read(poiRankerProvider);
        final vector = ref.read(userPreferenceVectorProvider);
        return ranker.rank(
          list,
          vector,
          currentPositionKm: widget.currentPositionKm,
        );
      case _SortMode.nearest:
        list.sort((a, b) {
          // Preferred fuel brands bubble to the top.
          final ab = _isBrandMatch(a) ? 0 : 1;
          final bb = _isBrandMatch(b) ? 0 : 1;
          if (ab != bb) return ab.compareTo(bb);
          final da = a.distanceAlongRouteKm ?? double.infinity;
          final db = b.distanceAlongRouteKm ?? double.infinity;
          return da.compareTo(db);
        });
      case _SortMode.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case _SortMode.openNow:
        list.sort((a, b) {
          final ao = a.openNow == true ? 0 : 1;
          final bo = b.openNow == true ? 0 : 1;
          if (ao != bo) return ao.compareTo(bo);
          return b.rating.compareTo(a.rating);
        });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // P2-020/021/022 — Apply RouteMode filter on top of the sorted list.
    final mode = ref.watch(routeModeProvider);
    final sorted = applyRouteModeFilter(_sorted, mode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // P2 Session 5 — mode selector above everything else.
        const SizedBox(height: 12),
        const RouteModeBar(),
        const SizedBox(height: 4),
        // Source badge + place count
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.source.icon,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.source.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (widget.preferredFuelBrands.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.warningSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '★ Your brands first',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              Text(
                mode == RouteMode.off || sorted.length == widget.pois.length
                    ? '${sorted.length} places'
                    : '${sorted.length} of ${widget.pois.length}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        // Sort chips
        //
        // "Open now" is only meaningful when POIs have openNow populated.
        // Google Nearby Search omits it; Place Details (loaded per tap) adds it.
        // We keep the chip available but show an honest tooltip and a contextual
        // hint row when selected with no data — rather than silently doing nothing.
        Builder(builder: (context) {
          final hasOpenNowData =
              widget.pois.any((p) => p.openNow != null);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _SortMode.values.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final mode = _SortMode.values[i];
                    final active = _sort == mode;
                    final isOpenNow = mode == _SortMode.openNow;
                    // Dim "Open now" chip when no live-hours data exists yet.
                    final dataAbsent = isOpenNow && !hasOpenNowData;

                    return Tooltip(
                      message: dataAbsent
                          ? 'Tap a place to load live hours'
                          : '',
                      preferBelow: true,
                      child: GestureDetector(
                        onTap: () => setState(() => _sort = mode),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primarySurface
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: active
                                  ? AppColors.primary.withValues(alpha: 0.4)
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                mode.icon,
                                size: 13,
                                color: dataAbsent
                                    ? AppColors.textTertiary
                                        .withValues(alpha: 0.4)
                                    : active
                                        ? AppColors.primary
                                        : AppColors.textTertiary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                mode.label,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: dataAbsent
                                      ? AppColors.textTertiary
                                          .withValues(alpha: 0.4)
                                      : active
                                          ? AppColors.primary
                                          : AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Contextual hint when "Open now" is selected but no data loaded yet.
              if (_sort == _SortMode.openNow && !hasOpenNowData)
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 6, 20, 0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 12,
                          color: AppColors.textTertiary
                              .withValues(alpha: 0.7)),
                      const SizedBox(width: 5),
                      Text(
                        'Tap a place to load live hours, then re-sort.',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textTertiary
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
        const SizedBox(height: 10),
        // POI list — or a mode-specific empty state if the filter left nothing.
        if (sorted.isEmpty && mode != RouteMode.off)
          Expanded(child: _ModeFilteredEmpty(mode: mode))
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              itemCount: sorted.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final poi = sorted[i];
                // P2-020/021 — stack rating pulse over mode badges so trust
                // signals and mode signals both surface on the tile.
                return PoiListTile(
                  poi: poi,
                  pulseSlot: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PoiCommunityRatingPulse(poi: poi),
                      PoiModeBadges(poi: poi),
                    ],
                  ),
                  onTap: () => showPoiDetailSheet(context, poi),
                );
              },
            ),
          ),
      ],
    );
  }
}
