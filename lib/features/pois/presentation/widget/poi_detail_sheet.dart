import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/utils/google_places_photo.dart';
import 'package:tripplus/core/widgets/poi_photo.dart';
import 'package:tripplus/core/widgets/source_badge.dart';
import 'package:tripplus/features/community/presentation/widgets/poi_community_reports_section.dart';
import 'package:tripplus/features/personalization/presentation/controller/brand_affinity_controller.dart';
import 'package:tripplus/features/pois/presentation/controller/pois_providers.dart';
import 'package:url_launcher/url_launcher.dart';

/// Modal bottom sheet shown when the user taps a POI tile. Wraps the POI
/// summary + Google photos (when available) + community reports section.
Future<void> showPoiDetailSheet(BuildContext context, Poi poi) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _PoiDetailSheet(poi: poi),
  );
}

class _PoiDetailSheet extends ConsumerStatefulWidget {
  const _PoiDetailSheet({required this.poi});
  final Poi poi;

  @override
  ConsumerState<_PoiDetailSheet> createState() => _PoiDetailSheetState();
}

class _PoiDetailSheetState extends ConsumerState<_PoiDetailSheet> {
  late Poi _poi;
  var _loadingPhotos = false;

  @override
  void initState() {
    super.initState();
    _poi = widget.poi;
    _enrichFromPlaceDetails();
    // P2-013 — opening a fuel POI is a soft signal towards its brand.
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(brandAffinityControllerProvider.notifier)
          .registerInteraction(poi: widget.poi, signal: 'view');
    });
  }

  /// Place Details returns more photos than Nearby Search — fetch on open.
  Future<void> _enrichFromPlaceDetails() async {
    final placeId = widget.poi.googlePlaceId;
    if (placeId == null) return;

    setState(() => _loadingPhotos = true);
    final result = await ref.read(poiRepositoryProvider).getById(placeId);
    if (!mounted) return;

    result.match(
      (_) => setState(() => _loadingPhotos = false),
      (enriched) {
        setState(() {
          _loadingPhotos = false;
          _poi = enriched.copyWith(
            category: widget.poi.category,
            distanceAlongRouteKm: widget.poi.distanceAlongRouteKm,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dist = _poi.distanceAlongRouteKm;
    final hasPhotos = _poi.photos.isNotEmpty;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  if (hasPhotos) ...[
                    PoiPhotoGallery(poi: _poi),
                    const SizedBox(height: 16),
                  ] else if (_loadingPhotos) ...[
                    Container(
                      height: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PoiPhotoThumbnail(poi: _poi, size: 48, borderRadius: 14),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_poi.name, style: AppTextStyles.h4),
                            const SizedBox(height: 2),
                            Text(
                              _poi.category.label,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SourceBadge(source: _poi.source),
                    ],
                  ),
                  if (_poi.address != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _poi.address!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (dist != null)
                        _FactPill(
                          icon: Icons.route,
                          label: '${dist.toStringAsFixed(1)} km on route',
                        ),
                      if (_poi.rating > 0)
                        _FactPill(
                          icon: Icons.star,
                          iconColor: AppColors.warning,
                          label: _poi.reviewCount > 0
                              ? '${_poi.rating.toStringAsFixed(1)} (${_poi.reviewCount})'
                              : _poi.rating.toStringAsFixed(1),
                        ),
                      if (_poi.openNow == true)
                        const _FactPill(
                          icon: Icons.check_circle_outline,
                          iconColor: AppColors.success,
                          label: 'Open now',
                        )
                      else if (_poi.openNow == false)
                        const _FactPill(
                          icon: Icons.do_not_disturb_on_outlined,
                          iconColor: AppColors.error,
                          label: 'Closed',
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _OpenInMapsButton(poi: _poi),
                  const SizedBox(height: 20),
                  PoiCommunityReportsSection(poi: _poi),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// "Open in Maps" button
// ---------------------------------------------------------------------------
class _OpenInMapsButton extends StatelessWidget {
  const _OpenInMapsButton({required this.poi});
  final Poi poi;

  Future<void> _launch() async {
    final query = poi.googlePlaceId != null
        ? 'https://www.google.com/maps/search/?api=1'
            '&query=${poi.latitude},${poi.longitude}'
            '&query_place_id=${poi.googlePlaceId}'
        : 'https://www.google.com/maps/search/?api=1'
            '&query=${poi.latitude},${poi.longitude}';
    final uri = Uri.parse(query);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: _launch,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.map_outlined, size: 18),
        label: const Text(
          'Open in Maps',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
class _FactPill extends StatelessWidget {
  const _FactPill({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor ?? AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
