import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/services/observability_providers.dart';
import 'package:journeyplus/core/telemetry/app_telemetry.dart';
import 'package:journeyplus/core/widgets/app_update_prompt.dart';
import 'package:journeyplus/core/widgets/app_bottom_nav.dart';
import 'package:journeyplus/core/widgets/gps_stale_banner.dart';
import 'package:journeyplus/core/widgets/offline_banner.dart';
import 'package:journeyplus/features/alerts/domain/alert_notification_payload.dart';
import 'package:journeyplus/features/alerts/presentation/controller/alerts_providers.dart';
import 'package:journeyplus/features/alerts/presentation/view/alert_history_screen.dart';
import 'package:journeyplus/features/alerts/presentation/widget/trip_alert_banner.dart';
import 'package:journeyplus/features/discovery/presentation/view/discovery_screen.dart';
import 'package:journeyplus/features/plan/presentation/view/plan_screen.dart';
import 'package:journeyplus/features/profile/presentation/view/profile_tab_screen.dart';
import 'package:journeyplus/features/shell/presentation/controller/shell_providers.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';
import 'package:journeyplus/features/trip/presentation/view/trip_tab_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  StreamSubscription<String?>? _notificationTapSub;

  @override
  void initState() {
    super.initState();
    final notifications = ref.read(localNotificationServiceProvider);
    _notificationTapSub = notifications.taps.listen(_handleRawPayload);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final launch = notifications.takeLaunchPayload();
      if (launch != null) _handleRawPayload(launch);
    });
  }

  @override
  void dispose() {
    _notificationTapSub?.cancel();
    super.dispose();
  }

  void _handleRawPayload(String? raw) {
    final payload = AlertNotificationPayload.tryParse(raw);
    if (payload == null || !mounted) return;
    ref.read(pendingAlertNotificationPayloadProvider.notifier).state = payload;
  }

  void _openAlertHistory(AlertNotificationPayload payload) {
    AppTelemetry.alertNotificationOpened(
      tripId: payload.tripId,
      type: payload.alertType,
    );
    navigateToShellTab(ref, 1);

    final trip = ref.read(activeTripControllerProvider).trip;
    if (trip == null || trip.id != payload.tripId) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => AlertHistoryScreen(trip: trip)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(shellTabIndexProvider);

    ref.listen<AlertNotificationPayload?>(
      pendingAlertNotificationPayloadProvider,
      (previous, next) {
        if (next == null) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(pendingAlertNotificationPayloadProvider.notifier).state =
              null;
          _openAlertHistory(next);
        });
      },
    );

    final screens = [
      const PlanScreen(),
      TripTabScreen(onPlanTrip: () => navigateToShellTab(ref, 0)),
      const DiscoveryScreen(),
      const ProfileTabScreen(),
    ];

    // P1-028 — keep alert notifier subscribed for the shell lifetime.
    ref.watch(alertNotifierProvider);
    // P2-071 — attach Crashlytics context listeners for the shell lifetime.
    ref.watch(observabilityWiringProvider);

    return Scaffold(
      body: Column(
        children: [
          const AppUpdatePrompt(),
          const OfflineBanner(),
          const GpsStaleBanner(),
          const TripAlertBanner(),
          Expanded(
            child: IndexedStack(index: currentIndex, children: screens),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: (i) => navigateToShellTab(ref, i),
      ),
    );
  }
}
