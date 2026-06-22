import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/utils/failure.dart';
import 'package:journeyplus/core/utils/phone_launcher.dart';
import 'package:journeyplus/core/widgets/horizontal_scroll_row.dart';
import 'package:journeyplus/core/widgets/poi_list_skeleton.dart';
import 'package:journeyplus/features/discovery/domain/emergency_hotline.dart';
import 'package:journeyplus/features/discovery/domain/emergency_service_type.dart';
import 'package:journeyplus/features/discovery/presentation/controller/emergency_providers.dart';
import 'package:journeyplus/features/discovery/presentation/controller/emergency_ui_state.dart';
import 'package:journeyplus/features/pois/presentation/controller/poi_category_ui_state.dart';
import 'package:journeyplus/features/pois/presentation/widget/poi_detail_sheet.dart';
import 'package:journeyplus/features/pois/presentation/widget/poi_list_tile.dart';

/// Highway emergency hub: hotlines + RSA / ambulance / crane / police / hospitals.
class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  static const _disclaimer =
      'In a life-threatening emergency, call 112 or 108 first. '
      'Place listings are suggestions from Google — verify before you go. '
      'JourneyPlus does not dispatch services.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(emergencyControllerProvider);
    final controller = ref.read(emergencyControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        title: Text('Emergency help', style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textOnDark,
        )),
      ),
      body: switch (state) {
        EmergencyLoading() => const PoiListSkeleton(),
        EmergencyErrored(:final failure) => _ErrorView(
            failure: failure,
            onRetry: controller.refresh,
          ),
        EmergencyData(
          :final contextLabel,
          :final source,
          :final hotlines,
          :final sections,
        ) =>
          _EmergencyBody(
            contextLabel: contextLabel,
            source: source,
            hotlines: hotlines,
            sections: sections,
          ),
      },
    );
  }
}

class _EmergencyBody extends StatelessWidget {
  const _EmergencyBody({
    required this.contextLabel,
    required this.source,
    required this.hotlines,
    required this.sections,
  });

  final String contextLabel;
  final PoiQuerySource source;
  final List<EmergencyHotline> hotlines;
  final List<EmergencySectionData> sections;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: const BoxDecoration(
              gradient: AppColors.alertGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        source.label,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  contextLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnDark.withValues(alpha: 0.95),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  EmergencyScreen._disclaimer,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textOnDark.withValues(alpha: 0.88),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'CALL FIRST',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: HorizontalScrollRow(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: hotlines.length,
            separator: 10,
            itemBuilder: (context, index) {
              return _HotlineCard(hotline: hotlines[index]);
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text(
              'HELP NEARBY',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        for (final section in sections) ...[
          SliverToBoxAdapter(
            child: _SectionHeader(section: section),
          ),
          if (section.hasError)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  section.failure!.message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            )
          else if (section.pois.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Text(
                  'No ${section.type.title.toLowerCase()} found in this area. Use the hotlines above.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final poi = section.pois[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: PoiListTile(
                      poi: poi,
                      onTap: () => showPoiDetailSheet(context, poi),
                    ),
                  );
                },
                childCount: section.pois.length.clamp(0, 8),
              ),
            ),
          if (section.pois.length > 8)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  '+ ${section.pois.length - 8} more — refine your route or search again',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
      ],
    );
  }
}

class _HotlineCard extends StatelessWidget {
  const _HotlineCard({required this.hotline});

  final EmergencyHotline hotline;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () async {
          final ok = await dialPhoneNumber(hotline.number);
          if (!ok && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not dial ${hotline.number}')),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 132,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(hotline.icon, color: AppColors.error, size: 22),
              const SizedBox(height: 10),
              Text(
                hotline.label,
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                hotline.subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.section});

  final EmergencySectionData section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.errorSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(section.type.icon, color: AppColors.error, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        section.type.title,
                        style: AppTextStyles.titleSmall,
                      ),
                    ),
                    if (!section.hasError)
                      Text(
                        '${section.pois.length}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  section.type.subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              failure.message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
