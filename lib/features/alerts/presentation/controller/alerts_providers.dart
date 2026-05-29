import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/services/local_notification_service.dart';
import 'package:tripplus/features/alerts/domain/alert_engine.dart';
import 'package:tripplus/features/alerts/domain/alert_notifier_state.dart';
import 'package:tripplus/features/alerts/presentation/controller/alert_notifier_controller.dart';
import 'package:tripplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:tripplus/features/trip/presentation/controller/trip_providers.dart';

final alertEngineProvider = Provider<AlertEngine>((ref) => AlertEngine());

final localNotificationServiceProvider =
    Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

/// Keeps alert polling alive for the app session (`P1-028`).
final alertNotifierProvider =
    StateNotifierProvider<AlertNotifierController, AlertNotifierState>((ref) {
  final notifier = AlertNotifierController(ref);

  ref.listen<ActiveTripState>(activeTripControllerProvider, (previous, next) {
    notifier.onTripStateChanged(next);
    final wasTracking = previous?.trip != null &&
        (previous is ActiveTripRunning);
    final isTracking = next is ActiveTripRunning;
    if (isTracking && !wasTracking) {
      notifier.startPolling();
    } else if (!isTracking && wasTracking) {
      notifier.stopPolling();
    }
  }, fireImmediately: true);

  ref.onDispose(notifier.dispose);
  return notifier;
});
