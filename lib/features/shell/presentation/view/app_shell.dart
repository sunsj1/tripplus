import 'package:flutter/material.dart';
import 'package:tripplus/core/widgets/app_bottom_nav.dart';
import 'package:tripplus/features/insights/presentation/view/insights_screen.dart';
import 'package:tripplus/features/plan/presentation/view/plan_screen.dart';
import 'package:tripplus/features/stations/presentation/view/stations_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    PlanScreen(),
    InsightsScreen(),
    StationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
