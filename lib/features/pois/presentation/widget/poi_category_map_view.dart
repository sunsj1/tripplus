import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripplus/core/constants/api_constants.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

/// Google Maps view for [PoiCategoryScreen] (`P1-015`). Mirrors the structure
/// of `station_map_screen.dart` so look-and-feel stays consistent.
class PoiCategoryMapView extends StatefulWidget {
  const PoiCategoryMapView({super.key, required this.pois});
  final List<Poi> pois;

  @override
  State<PoiCategoryMapView> createState() => _PoiCategoryMapViewState();
}

class _PoiCategoryMapViewState extends State<PoiCategoryMapView> {
  GoogleMapController? _mapController;
  Poi? _selected;

  Set<Marker> get _markers {
    return widget.pois.map((poi) {
      return Marker(
        markerId: MarkerId(poi.id),
        position: LatLng(poi.latitude, poi.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          poi.openNow == false
              ? BitmapDescriptor.hueOrange
              : BitmapDescriptor.hueGreen,
        ),
        onTap: () => setState(() => _selected = poi),
      );
    }).toSet();
  }

  LatLng get _initialPosition {
    if (widget.pois.isNotEmpty) {
      return LatLng(widget.pois.first.latitude, widget.pois.first.longitude);
    }
    return const LatLng(20.5937, 78.9629);
  }

  @override
  Widget build(BuildContext context) {
    if (!ApiConstants.isGoogleMapsKeyConfigured) {
      return _MapPlaceholder(count: widget.pois.length);
    }
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: _initialPosition, zoom: 11),
          markers: _markers,
          onMapCreated: (c) => _mapController = c,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            children: [
              _MapButton(
                icon: Icons.my_location,
                onTap: () {
                  if (widget.pois.isNotEmpty) {
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(_initialPosition),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.add,
                onTap: () =>
                    _mapController?.animateCamera(CameraUpdate.zoomIn()),
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.remove,
                onTap: () =>
                    _mapController?.animateCamera(CameraUpdate.zoomOut()),
              ),
            ],
          ),
        ),
        if (_selected != null)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _PoiPopup(
              poi: _selected!,
              onClose: () => setState(() => _selected = null),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}

class _PoiPopup extends StatelessWidget {
  const _PoiPopup({required this.poi, required this.onClose});
  final Poi poi;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final dist = poi.distanceAlongRouteKm;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  poi.name,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  dist != null
                      ? '${dist.toStringAsFixed(1)} km on route'
                      : (poi.address ?? ''),
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Icon(
              Icons.close,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.map_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text('Map View', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              'Configure your Google Maps API key\nto enable map view.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$count places available in list view',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
