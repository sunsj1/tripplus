import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';

/// Bottom nav for the [AppShell]. Four tabs as of `P1-016`:
/// Plan · Trip · Discover · Profile.
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
      activeIcon: Icons.route,
      label: 'PLAN',
    ),
    _NavSpec(
      icon: Icons.luggage_outlined,
      activeIcon: Icons.luggage,
      label: 'TRIP',
    ),
    _NavSpec(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'DISCOVER',
    ),
    _NavSpec(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'PROFILE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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

class _NavItem extends StatelessWidget {
  final _NavSpec spec;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.spec,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? spec.activeIcon : spec.icon,
              size: 20,
              color: isActive ? AppColors.textOnDark : AppColors.navInactive,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                spec.label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                  color: AppColors.textOnDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
