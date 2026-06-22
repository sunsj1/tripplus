import 'package:flutter/material.dart';
import 'package:journeyplus/core/theme/app_colors.dart';

/// Bottom navigation bar for [AppShell].
///
/// Design goals: always shows icon + label for every tab so users know
/// what each item is. Active state uses a top accent line + filled icon +
/// primary-colored label. Inactive uses outlined icon + muted label.
/// All transitions are animated for a premium feel.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = <_NavSpec>[
    _NavSpec(
      icon: Icons.route_outlined,
      activeIcon: Icons.route_rounded,
      label: 'Plan',
    ),
    _NavSpec(
      icon: Icons.luggage_outlined,
      activeIcon: Icons.luggage_rounded,
      label: 'Trip',
    ),
    _NavSpec(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'Discover',
    ),
    _NavSpec(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.borderLight,
            width: 0.8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                _NavItem(
                  spec: _items[i],
                  isActive: currentIndex == i,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------
class _NavSpec {
  const _NavSpec({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

// ---------------------------------------------------------------------------
// Single tab item
// ---------------------------------------------------------------------------
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.spec,
    required this.isActive,
    required this.onTap,
  });

  final _NavSpec spec;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 220);
    final fg = isActive ? AppColors.primary : AppColors.navInactive;

    // P2-070 — A11y: each tab is a button; expose its label and selected
    // state to screen readers so VoiceOver/TalkBack can announce e.g.
    // "Trip, tab, 2 of 4, selected".
    return Expanded(
      child: Semantics(
        button: true,
        selected: isActive,
        label: '${spec.label}, tab',
        child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Top accent indicator ──────────────────────────────────────
            AnimatedContainer(
              duration: duration,
              curve: Curves.easeOut,
              height: 2.5,
              width: isActive ? 24 : 0,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(99),
              ),
            ),

            // ── Icon ─────────────────────────────────────────────────────
            AnimatedScale(
              scale: isActive ? 1.12 : 1.0,
              duration: duration,
              curve: Curves.easeOutBack,
              child: AnimatedSwitcher(
                duration: duration,
                child: Icon(
                  isActive ? spec.activeIcon : spec.icon,
                  key: ValueKey(isActive),
                  size: 22,
                  color: fg,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // ── Label — always visible ────────────────────────────────────
            AnimatedDefaultTextStyle(
              duration: duration,
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w500,
                color: fg,
                letterSpacing: isActive ? 0.2 : 0,
                height: 1,
              ),
              child: Text(spec.label),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
