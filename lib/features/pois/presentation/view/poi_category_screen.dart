import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/utils/failure.dart';
import 'package:tripplus/features/community/presentation/widgets/poi_community_rating_pulse.dart';
import 'package:tripplus/features/pois/presentation/controller/poi_category_ui_state.dart';
import 'package:tripplus/features/pois/presentation/controller/pois_providers.dart';
import 'package:tripplus/features/pois/presentation/widget/poi_category_map_view.dart';
import 'package:tripplus/features/pois/presentation/widget/poi_detail_sheet.dart';
import 'package:tripplus/core/telemetry/app_telemetry.dart';
import 'package:tripplus/core/widgets/poi_list_skeleton.dart';
import 'package:tripplus/features/pois/presentation/widget/poi_list_tile.dart';

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
          PoiCategoryData(:final pois, :final source) =>
            _mode == _ViewMode.list
                ? _List(pois: pois, source: source)
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

class _List extends StatelessWidget {
  const _List({required this.pois, required this.source});
  final List<Poi> pois;
  final PoiQuerySource source;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
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
                      source == PoiQuerySource.alongRoute
                          ? Icons.route
                          : Icons.location_on,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      source.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${pois.length} places',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            itemCount: pois.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => PoiListTile(
              poi: pois[i],
              pulseSlot: PoiCommunityRatingPulse(poi: pois[i]),
              onTap: () => showPoiDetailSheet(context, pois[i]),
            ),
          ),
        ),
      ],
    );
  }
}
