import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/widgets/app_bottom_nav.dart';
import 'package:tripplus/core/widgets/offline_banner.dart';
import 'package:tripplus/features/alerts/presentation/controller/alerts_providers.dart';
import 'package:tripplus/features/alerts/presentation/widget/trip_alert_banner.dart';
import 'package:tripplus/features/discovery/presentation/view/discovery_screen.dart';
import 'package:tripplus/features/plan/presentation/view/plan_screen.dart';
import 'package:tripplus/features/profile/presentation/view/profile_tab_screen.dart';
import 'package:tripplus/features/trip/presentation/view/trip_tab_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const PlanScreen(),
    TripTabScreen(onPlanTrip: () => _switchTo(0)),   // P1-017
    const DiscoveryScreen(),
    const ProfileTabScreen(),
  ];

  void _switchTo(int i) => setState(() => _currentIndex = i);

  @override
  Widget build(BuildContext context) {
    // P1-028 — keep alert notifier subscribed for the shell lifetime.
    ref.watch(alertNotifierProvider);

    return Scaffold(
      // P1-044 — offline degraded-mode banner sits above the tab content.
      body: Column(
        children: [
          const OfflineBanner(),
          const TripAlertBanner(),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _switchTo,
      ),
    );
  }
}

// _TripTabPlaceholder removed — replaced by TripTabScreen (P1-017).
