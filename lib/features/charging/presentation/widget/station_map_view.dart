import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';

class StationMapView extends StatefulWidget {
  final List<ChargingStation> stations;
  final LatLng? initialPosition;

  const StationMapView({
    super.key,
    required this.stations,
    this.initialPosition,
  });

  @override
  State<StationMapView> createState() => _StationMapViewState();
}

class _StationMapViewState extends State<StationMapView> {
  final Completer<GoogleMapController> _controller = Completer();

  Set<Marker> get _markers {
    return widget.stations.map((station) {
      return Marker(
        markerId: MarkerId(station.id.toString()),
        position: LatLng(station.latitude, station.longitude),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: _buildSnippet(station),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          station.isOperational == true
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueOrange,
        ),
      );
    }).toSet();
  }

  String _buildSnippet(ChargingStation station) {
    final parts = <String>[];
    if (station.distanceKm != null) {
      parts.add('${station.distanceKm!.toStringAsFixed(1)} km');
    }
    if (station.operatorName != null) parts.add(station.operatorName!);
    if (station.statusType != null) parts.add(station.statusType!);
    return parts.join(' · ');
  }

  LatLng get _center {
    if (widget.initialPosition != null) return widget.initialPosition!;
    if (widget.stations.isNotEmpty) {
      final first = widget.stations.first;
      return LatLng(first.latitude, first.longitude);
    }
    return const LatLng(20.5937, 78.9629); // Default: India
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
    );
  }
}
