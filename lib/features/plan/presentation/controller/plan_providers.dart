import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/services/directions_service.dart';
import 'package:tripplus/core/services/geocoding_service.dart';
import 'package:tripplus/core/services/google_ev_station_service.dart';
import 'package:tripplus/core/services/places_autocomplete_service.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/features/charging/presentation/controller/charging_providers.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_controller.dart';
import 'package:tripplus/features/plan/presentation/controller/plan_state.dart';

/// Separate Dio instance for Google APIs (no baseUrl, longer timeout for
/// Directions API on long routes).
final googleDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'TripPlus/1.0 (Flutter; EV charging app)',
      },
    ),
  );
});

final geocodingServiceProvider = Provider<GeocodingService>((ref) {
  return GeocodingService(ref.watch(googleDioProvider));
});

final directionsServiceProvider = Provider<DirectionsService>((ref) {
  return DirectionsService(ref.watch(googleDioProvider));
});

final googleEvStationProvider = Provider<GoogleEvStationService>((ref) {
  return GoogleEvStationService(ref.watch(googleDioProvider));
});

final routeStationServiceProvider = Provider<RouteStationService>((ref) {
  return RouteStationService(
    geocoding: ref.watch(geocodingServiceProvider),
    directions: ref.watch(directionsServiceProvider),
    repository: ref.watch(chargingRepositoryProvider),
    googleEvService: ref.watch(googleEvStationProvider),
  );
});

final placesAutocompleteProvider = Provider<PlacesAutocompleteService>((ref) {
  return PlacesAutocompleteService(ref.watch(googleDioProvider));
});

final planControllerProvider =
    StateNotifierProvider<PlanController, PlanState>((ref) {
  return PlanController(
    routeService: ref.watch(routeStationServiceProvider),
  );
});
