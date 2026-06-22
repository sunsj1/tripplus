import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/services/observability_service.dart';
import 'package:journeyplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:journeyplus/features/personalization/presentation/controller/route_mode_provider.dart';
import 'package:journeyplus/features/profile/presentation/controller/profile_providers.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

/// P2-071 — Single shared [ObservabilityService] instance.
final observabilityServiceProvider = Provider<ObservabilityService>(
  (ref) => ObservabilityService(),
);

/// P2-071 — Listens to the inputs that should influence Crashlytics context
/// and pipes them in. Read this provider once from the widget tree to wire
/// up the listeners; the provider itself returns void.
final observabilityWiringProvider = Provider<void>((ref) {
  final svc = ref.watch(observabilityServiceProvider);

  // User identifier — set whenever the signed-in user changes.
  ref.listen(userAppStateProvider, (_, next) {
    svc.bindUser(next?.userId);
  }, fireImmediately: true);

  // Vehicle type — from the saved profile.
  ref.listen(profileControllerProvider, (_, next) {
    svc.setVehicleType(next.data.vehicle?.type.name);
  }, fireImmediately: true);

  // Route mode — useful when reproducing a mode-specific filter bug.
  ref.listen(routeModeProvider, (_, next) {
    svc.setRouteMode(next.name);
  }, fireImmediately: true);

  // Active-trip presence — quick filter in Crashlytics dashboards.
  ref.listen(activeTripControllerProvider, (_, next) {
    svc.setActiveTrip(next is ActiveTripRunning || next is ActiveTripPaused);
  }, fireImmediately: true);
});
