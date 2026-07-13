import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journeyplus/core/constants/api_constants.dart';
import 'package:journeyplus/core/domain/route_option.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart' as pl;

/// Full-screen map showing all route alternatives; returns selected index.
class RouteMapPreviewScreen extends StatefulWidget {
  const RouteMapPreviewScreen({
    super.key,
    required this.options,
    required this.initialIndex,
  });

  final List<RouteOption> options;
  final int initialIndex;

  @override
  State<RouteMapPreviewScreen> createState() => _RouteMapPreviewScreenState();
}

class _RouteMapPreviewScreenState extends State<RouteMapPreviewScreen> {
  GoogleMapController? _mapController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  Set<Polyline> get _polylines {
    return widget.options.asMap().entries.map((entry) {
      final i = entry.key;
      final option = entry.value;
      final points = _pointsFor(option);
      final selected = i == _selectedIndex;
      return Polyline(
        polylineId: PolylineId('route_${option.id}'),
        points: points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList(),
        color: selected ? AppColors.accentBlue : AppColors.textTertiary,
        width: selected ? 6 : 4,
        zIndex: selected ? 2 : 1,
        consumeTapEvents: true,
        onTap: () => _selectAndPop(i),
      );
    }).toSet();
  }

  Set<Marker> get _timeMarkers {
    return widget.options.asMap().entries.map((entry) {
      final i = entry.key;
      final option = entry.value;
      final points = _pointsFor(option);
      if (points.isEmpty) return null;
      final mid = points[points.length ~/ 2];
      return Marker(
        markerId: MarkerId('time_${option.id}'),
        position: LatLng(mid.latitude, mid.longitude),
        onTap: () => _selectAndPop(i),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          i == _selectedIndex
              ? BitmapDescriptor.hueAzure
              : BitmapDescriptor.hueOrange,
        ),
        infoWindow: InfoWindow(
          title: _fmtDuration(option.effectiveDurationMinutes),
          snippet: '${option.distanceKm.round()} km',
        ),
      );
    }).whereType<Marker>().toSet();
  }

  LatLng get _initialTarget {
    final option = widget.options[_selectedIndex.clamp(0, widget.options.length - 1)];
    final points = _pointsFor(option);
    if (points.isNotEmpty) {
      return LatLng(points.first.latitude, points.first.longitude);
    }
    return const LatLng(20.5937, 78.9629);
  }

  @override
  Widget build(BuildContext context) {
    if (!ApiConstants.isGoogleMapsKeyConfigured) {
      return Scaffold(
        appBar: AppBar(title: const Text('Route map')),
        body: const _MapKeyPlaceholder(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route map'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_selectedIndex),
            child: const Text('Done'),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialTarget,
              zoom: 9,
            ),
            polylines: _polylines,
            markers: _timeMarkers,
            onMapCreated: (c) {
              _mapController = c;
              _fitAllRoutes();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _RouteChipBar(
              options: widget.options,
              selectedIndex: _selectedIndex,
              onSelected: (i) => setState(() => _selectedIndex = i),
              onConfirm: () => Navigator.of(context).pop(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAndPop(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).pop(index);
  }

  void _fitAllRoutes() {
    final allPoints = <LatLng>[];
    for (final option in widget.options) {
      for (final p in _pointsFor(option)) {
        allPoints.add(LatLng(p.latitude, p.longitude));
      }
    }
    if (allPoints.isEmpty || _mapController == null) return;

    var minLat = allPoints.first.latitude;
    var maxLat = allPoints.first.latitude;
    var minLng = allPoints.first.longitude;
    var maxLng = allPoints.first.longitude;
    for (final p in allPoints) {
      minLat = min(minLat, p.latitude);
      maxLat = max(maxLat, p.latitude);
      minLng = min(minLng, p.longitude);
      maxLng = max(maxLng, p.longitude);
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        56,
      ),
    );
  }

  List<pl.LatLng> _pointsFor(RouteOption option) {
    if (option.polylinePoints.isNotEmpty) return option.polylinePoints;
    if (option.encodedPolyline.isEmpty) return const [];
    return pl.PolylineDecoder.decode(option.encodedPolyline);
  }

  String _fmtDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h hr' : '$h hr $m min';
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _RouteChipBar extends StatelessWidget {
  const _RouteChipBar({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    required this.onConfirm,
  });

  final List<RouteOption> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0),
            AppColors.background.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final o = options[i];
                final selected = i == selectedIndex;
                return GestureDetector(
                  onTap: () => onSelected(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Text(
                      '${o.effectiveDurationMinutes} min · ${o.distanceKm.round()} km',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: selected
                            ? AppColors.textOnPrimary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onConfirm,
              child: const Text('Use this route'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapKeyPlaceholder extends StatelessWidget {
  const _MapKeyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('Map unavailable', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              'Add a Google Maps API key to preview routes on the map.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
