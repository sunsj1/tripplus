import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/domain/trip_position.dart';
import 'package:journeyplus/core/services/local_notification_service.dart';
import 'package:journeyplus/features/alerts/domain/alert_engine.dart';
import 'package:journeyplus/features/alerts/domain/alert_notification_payload.dart';
import 'package:journeyplus/features/alerts/domain/alert_notifier_state.dart';
import 'package:journeyplus/features/alerts/presentation/controller/alert_notifier_controller.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

final alertEngineProvider = Provider<AlertEngine>((ref) => AlertEngine());

/// Production overrides this in [main] with the single initialised instance.
/// The fallback exists only so unit/widget tests can construct a container.
final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService();
});

/// Pending deep-link from a tapped trip-alert notification.
final pendingAlertNotificationPayloadProvider =
    StateProvider<AlertNotificationPayload?>((ref) => null);

/// Keeps alert evaluation alive for the app session (`P1-028` / HA-030).
final alertNotifierProvider =
    StateNotifierProvider<AlertNotifierController, AlertNotifierState>((ref) {
      final notifier = AlertNotifierController(ref);

      ref.listen<ActiveTripState>(activeTripControllerProvider, (
        previous,
        next,
      ) {
        notifier.onTripStateChanged(next);
        final wasTracking =
            previous?.trip != null && (previous is ActiveTripRunning);
        final isTracking = next is ActiveTripRunning;
        if (isTracking && !wasTracking) {
          notifier.startPolling();
        } else if (!isTracking && wasTracking) {
          notifier.stopPolling();
        }
      }, fireImmediately: true);

      // HA-030 — evaluate on live GPS ticks; 30s timer remains the sparse fallback.
      ref.listen<TripPosition?>(tripPositionProvider, (previous, next) {
        if (next == null) return;
        if (previous != null &&
            previous.latitude == next.latitude &&
            previous.longitude == next.longitude) {
          return;
        }
        final tripState = ref.read(activeTripControllerProvider);
        if (tripState is! ActiveTripRunning) return;
        notifier.onPositionTick();
      });

      ref.onDispose(notifier.dispose);
      return notifier;
    });
