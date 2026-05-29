import 'package:flutter/material.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/utils/google_places_photo.dart';

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _IconTile(
            size: size,
            borderRadius: borderRadius,
            icon: icon,
          ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _IconTile(
              size: size,
              borderRadius: borderRadius,
              icon: icon,
              loading: true,
            );
          },
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

  @override
  Widget build(BuildContext context) {
    final urls = poi.photoUrls(limit: maxPhotos);
    if (urls.isEmpty) return const SizedBox.shrink();

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
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 200,
                  child: Image.network(
                    urls[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primarySurface,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.textTertiary,
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
          poi.photoAttributions.isNotEmpty
              ? poi.photoAttributions.join(' · ')
              : 'Photos via Google',
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
