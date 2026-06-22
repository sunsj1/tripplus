import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/services/observability_providers.dart';
import 'package:journeyplus/core/widgets/app_bottom_nav.dart';
import 'package:journeyplus/core/widgets/offline_banner.dart';
import 'package:journeyplus/features/alerts/presentation/controller/alerts_providers.dart';
import 'package:journeyplus/features/alerts/presentation/widget/trip_alert_banner.dart';
import 'package:journeyplus/features/discovery/presentation/view/discovery_screen.dart';
import 'package:journeyplus/features/plan/presentation/view/plan_screen.dart';
import 'package:journeyplus/features/profile/presentation/view/profile_tab_screen.dart';
import 'package:journeyplus/features/shell/presentation/controller/shell_providers.dart';
import 'package:journeyplus/features/trip/presentation/view/trip_tab_screen.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(shellTabIndexProvider);

    final screens = [
      const PlanScreen(),
      TripTabScreen(
        onPlanTrip: () => navigateToShellTab(ref, 0),
      ),
      const DiscoveryScreen(),
      const ProfileTabScreen(),
    ];

    // P1-028 — keep alert notifier subscribed for the shell lifetime.
    ref.watch(alertNotifierProvider);
    // P2-071 — attach Crashlytics context listeners for the shell lifetime.
    ref.watch(observabilityWiringProvider);

    return Scaffold(
      // P1-044 — offline degraded-mode banner sits above the tab content.
      body: Column(
        children: [
          const OfflineBanner(),
          const TripAlertBanner(),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
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

// _TripTabPlaceholder removed — replaced by TripTabScreen (P1-017).
