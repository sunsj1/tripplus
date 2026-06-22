import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journeyplus/core/constants/api_constants.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';
import 'package:journeyplus/features/stations/presentation/view/station_detail_screen.dart';

class StationMapScreen extends StatefulWidget {
  final List<ChargingStation> stations;

  const StationMapScreen({super.key, required this.stations});

  @override
  State<StationMapScreen> createState() => _StationMapScreenState();
}

class _StationMapScreenState extends State<StationMapScreen> {
  GoogleMapController? _mapController;
  ChargingStation? _selectedStation;

  Set<Marker> get _markers {
    return widget.stations.map((station) {
      return Marker(
        markerId: MarkerId(station.id.toString()),
        position: LatLng(station.latitude, station.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          station.isOperational == true
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueOrange,
        ),
        onTap: () => setState(() => _selectedStation = station),
      );
    }).toSet();
  }

  LatLng get _initialPosition {
    if (widget.stations.isNotEmpty) {
      return LatLng(
        widget.stations.first.latitude,
        widget.stations.first.longitude,
      );
    }
    return const LatLng(20.5937, 78.9629);
  }

  @override
  Widget build(BuildContext context) {
    if (!ApiConstants.isGoogleMapsKeyConfigured) {
      return _MapPlaceholder(stations: widget.stations);
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 11,
          ),
          markers: _markers,
          onMapCreated: (c) => _mapController = c,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          style: _mapStyle,
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            children: [
              _MapButton(
                icon: Icons.my_location,
                onTap: () {
                  if (widget.stations.isNotEmpty) {
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(_initialPosition),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.add,
                onTap: () => _mapController?.animateCamera(
                  CameraUpdate.zoomIn(),
                ),
              ),
              const SizedBox(height: 8),
              _MapButton(
                icon: Icons.remove,
                onTap: () => _mapController?.animateCamera(
                  CameraUpdate.zoomOut(),
                ),
              ),
            ],
          ),
        ),
        if (_selectedStation != null)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _StationPopup(
              station: _selectedStation!,
              onClose: () => setState(() => _selectedStation = null),
              onDetail: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        StationDetailScreen(station: _selectedStation!),
                  ),
                );
              },
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

  static const _mapStyle = '''[
    {"featureType":"poi","stylers":[{"visibility":"off"}]},
    {"featureType":"transit","stylers":[{"visibility":"simplified"}]}
  ]''';
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapButton({required this.icon, required this.onTap});

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

class _StationPopup extends StatelessWidget {
  final ChargingStation station;
  final VoidCallback onClose;
  final VoidCallback onDetail;

  const _StationPopup({
    required this.station,
    required this.onClose,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetail,
      child: Container(
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: station.isOperational == true
                    ? AppColors.successSurface
                    : AppColors.warningSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.ev_station,
                color: station.isOperational == true
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    station.name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${station.distanceKm?.toStringAsFixed(1) ?? '?'} km away',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onClose,
              child: const Icon(Icons.close, size: 18, color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final List<ChargingStation> stations;

  const _MapPlaceholder({required this.stations});

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
            Text(
              'Map View',
              style: AppTextStyles.h4,
            ),
            const SizedBox(height: 8),
            Text(
              'Configure your Google Maps API key\nto enable map view.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${stations.length} stations available in list view',
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
