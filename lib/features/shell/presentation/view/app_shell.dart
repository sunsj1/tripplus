import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/core/widgets/app_bottom_nav.dart';
import 'package:tripplus/features/discovery/presentation/view/discovery_screen.dart';
import 'package:tripplus/features/plan/presentation/view/plan_screen.dart';
import 'package:tripplus/features/profile/presentation/view/profile_tab_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const PlanScreen(),
    _TripTabPlaceholder(onPlanTrip: () => _switchTo(0)),
    const DiscoveryScreen(),
    const ProfileTabScreen(),
  ];

  void _switchTo(int i) => setState(() => _currentIndex = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _switchTo,
      ),
    );
  }
}

/// Temporary content for the Trip tab. Replaced by the actual trip dashboard
/// in `P1-017` (session 7) once `ActiveTripController` exists (`P1-040`/`P1-041`).
class _TripTabPlaceholder extends StatelessWidget {
  const _TripTabPlaceholder({required this.onPlanTrip});
  final VoidCallback onPlanTrip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
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
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.luggage_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text('No active trip', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text(
                  'Plan a trip and your trip control center lives here — '
                  'route, fuel cost, ETA, and predictive alerts.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: onPlanTrip,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(Icons.route),
                  label: const Text('Plan a trip'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
