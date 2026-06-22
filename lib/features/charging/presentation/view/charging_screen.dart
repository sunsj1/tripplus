import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journeyplus/core/constants/api_constants.dart';
import 'package:journeyplus/features/charging/presentation/controller/charging_providers.dart';
import 'package:journeyplus/features/charging/presentation/controller/charging_state.dart';
import 'package:journeyplus/features/charging/presentation/widget/error_view.dart';
import 'package:journeyplus/features/charging/presentation/widget/loading_view.dart';
import 'package:journeyplus/features/charging/presentation/widget/station_card.dart';
import 'package:journeyplus/features/charging/presentation/widget/station_map_view.dart';

class ChargingScreen extends ConsumerStatefulWidget {
  const ChargingScreen({super.key});

  @override
  ConsumerState<ChargingScreen> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends ConsumerState<ChargingScreen> {
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chargingControllerProvider.notifier).loadStations();
    });
  }

  void _reload() {
    ref.read(chargingControllerProvider.notifier).loadStations();
  }

  void _toggleMapView() {
    if (!_showMap && !ApiConstants.isGoogleMapsKeyConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add a valid GOOGLE_MAPS_API_KEY to .env, then run '
            'flutter pub get and rebuild (pod install syncs the key for iOS).',
          ),
        ),
      );
      return;
    }
    setState(() => _showMap = !_showMap);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chargingControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('JourneyPlus'),
        actions: [
          if (state is ChargingLoaded)
            IconButton(
              icon: Icon(_showMap ? Icons.list : Icons.map_outlined),
              tooltip: _showMap ? 'List view' : 'Map view',
              onPressed: _toggleMapView,
            ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: switch (state) {
        ChargingInitial() => const LoadingView(),
        ChargingLoading() => const LoadingView(),
        ChargingLoaded(:final stations) =>
          stations.isEmpty
              ? const Center(child: Text('No stations found.'))
              : _showMap
              ? StationMapView(
                  stations: stations,
                  initialPosition: stations.isNotEmpty
                      ? LatLng(
                          stations.first.latitude,
                          stations.first.longitude,
                        )
                      : null,
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return ref
                        .read(chargingControllerProvider.notifier)
                        .loadStations();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: stations.length,
                    itemBuilder: (_, index) =>
                        StationCard(station: stations[index]),
                  ),
                ),
        ChargingError(:final message) => ErrorView(
          message: message,
          onRetry: _reload,
        ),
      },
    );
  }
}
