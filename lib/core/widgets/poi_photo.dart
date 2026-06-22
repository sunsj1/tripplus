import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/utils/google_places_photo.dart';

/// Square thumbnail for POI list rows — Google photo when available, else icon.
class PoiPhotoThumbnail extends StatelessWidget {
  const PoiPhotoThumbnail({
    super.key,
    required this.poi,
    this.size = 44,
    this.borderRadius = 12,
  });

  final Poi poi;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = poi.thumbnailUrl();
    final icon = _iconFor(poi.category);

    if (url == null) {
      return _IconTile(
        size: size,
        borderRadius: borderRadius,
        icon: icon,
      );
    }

    // P2-073 — cached_network_image keeps the JPEG on disk + a decoded copy
    // in the resizable ImageCache so scrolling the same list twice doesn't
    // re-hit Google Photos. Also avoids the layout jank we used to see when
    // a fast scroll re-decoded a cleared image.
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        memCacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
        memCacheHeight: (size * MediaQuery.devicePixelRatioOf(context)).round(),
        placeholder: (context, _) => _IconTile(
          size: size,
          borderRadius: borderRadius,
          icon: icon,
          loading: true,
        ),
        errorWidget: (context, _, _) => _IconTile(
          size: size,
          borderRadius: borderRadius,
          icon: icon,
        ),
      ),
    );
  }

  IconData _iconFor(PoiCategory c) {
    switch (c) {
      case PoiCategory.fuel:
        return Icons.local_gas_station;
      case PoiCategory.ev:
        return Icons.electric_car;
      case PoiCategory.restaurant:
        return Icons.restaurant;
      case PoiCategory.pureVeg:
        return Icons.eco;
      case PoiCategory.washroom:
        return Icons.wc;
      case PoiCategory.atm:
        return Icons.local_atm;
      case PoiCategory.hotel:
        return Icons.hotel;
      case PoiCategory.medical:
        return Icons.local_hospital;
      case PoiCategory.scenic:
        return Icons.landscape;
      case PoiCategory.temple:
        return Icons.temple_hindu;
      case PoiCategory.kidsStop:
        return Icons.child_friendly;
      case PoiCategory.mechanic:
        return Icons.build;
      case PoiCategory.parking:
        return Icons.local_parking;
      case PoiCategory.cafe:
        return Icons.local_cafe;
      case PoiCategory.tourist:
        return Icons.attractions;
      case PoiCategory.police:
        return Icons.local_police;
    }
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.size,
    required this.borderRadius,
    required this.icon,
    this.loading = false,
  });

  final double size;
  final double borderRadius;
  final IconData icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: loading
          ? const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : Icon(icon, size: size * 0.5, color: AppColors.primary),
    );
  }
}

/// Horizontal strip of Google Places photos for the POI detail bottom sheet.
class PoiPhotoGallery extends StatelessWidget {
  const PoiPhotoGallery({
    super.key,
    required this.poi,
    this.maxPhotos = 5,
  });

  final Poi poi;
  final int maxPhotos;

  void _openFullscreen(BuildContext context, int index) {
    final urls = poi.fullscreenPhotoUrls(limit: maxPhotos);
    if (urls.isEmpty) return;
    showPoiPhotoViewer(
      context,
      photoUrls: urls,
      initialIndex: index.clamp(0, urls.length - 1),
      attributions: poi.plainPhotoAttributions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = poi.photoUrls(limit: maxPhotos);
    if (urls.isEmpty) return const SizedBox.shrink();

    final attributionText = poi.plainPhotoAttributions.isNotEmpty
        ? poi.plainPhotoAttributions.join(' · ')
        : 'Photos via Google';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: urls.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openFullscreen(context, index),
                  borderRadius: BorderRadius.circular(14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 200,
                      height: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // P2-073 — cached carousel thumbnails.
                          CachedNetworkImage(
                            imageUrl: urls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, _) => Container(
                              color: AppColors.primarySurface,
                            ),
                            errorWidget: (context, _, _) => Container(
                              color: AppColors.primarySurface,
                              child: const Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.fullscreen,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Text(
          attributionText,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Full-screen swipeable photo viewer opened from [PoiPhotoGallery].
Future<void> showPoiPhotoViewer(
  BuildContext context, {
  required List<String> photoUrls,
  required int initialIndex,
  List<String> attributions = const [],
}) {
  if (photoUrls.isEmpty) return Future<void>.value();

  return Navigator.of(context).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _PoiPhotoFullscreenPage(
          photoUrls: photoUrls,
          initialIndex: initialIndex,
          attributions: attributions,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

class _PoiPhotoFullscreenPage extends StatefulWidget {
  const _PoiPhotoFullscreenPage({
    required this.photoUrls,
    required this.initialIndex,
    required this.attributions,
  });

  final List<String> photoUrls;
  final int initialIndex;
  final List<String> attributions;

  @override
  State<_PoiPhotoFullscreenPage> createState() => _PoiPhotoFullscreenPageState();
}

class _PoiPhotoFullscreenPageState extends State<_PoiPhotoFullscreenPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.photoUrls.length;
    final attribution = widget.attributions.isNotEmpty
        ? widget.attributions.join(' · ')
        : 'Photos via Google';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: total,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Center(
                  // P2-073 — same cache key serves the gallery thumbnail and
                  // the fullscreen view, so opening a photo is instant after
                  // it has been seen once.
                  child: CachedNetworkImage(
                    imageUrl: widget.photoUrls[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, _) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, _, _) => const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  if (total > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / $total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: Text(
              attribution,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
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
