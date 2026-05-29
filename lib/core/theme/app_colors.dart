import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary greens (from design buttons, nav, accents)
  static const primary = Color(0xFF1B5E20);
  static const primaryLight = Color(0xFF2E7D32);
  static const primaryDark = Color(0xFF0D3B10);
  static const primarySurface = Color(0xFFE8F5E9);
  static const primarySurfaceLight = Color(0xFFF1F8F2);

  // Teal (onboarding background)
  static const teal = Color(0xFF00897B);
  static const tealDark = Color(0xFF00695C);
  static const tealLight = Color(0xFF4DB6AC);

  // Surfaces
  static const background = Color(0xFFF5F7F5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFFAFAFA);
  static const cardGreenGradientStart = Color(0xFF1B5E20);
  static const cardGreenGradientEnd = Color(0xFF2E7D32);

  // Alerts
  static const error = Color(0xFFC62828);
  static const errorSurface = Color(0xFFFFEBEE);
  static const errorDark = Color(0xFFB71C1C);
  static const warning = Color(0xFFF57F17);
  static const warningSurface = Color(0xFFFFF8E1);
  static const success = Color(0xFF2E7D32);
  static const successSurface = Color(0xFFE8F5E9);

  // Text
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF616161);
  static const textTertiary = Color(0xFF9E9E9E);
  static const textHint = Color(0xFFBDBDBD);
  static const textOnDark = Color(0xFFFFFFFF);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textGreen = Color(0xFF2E7D32);

  // Borders
  static const border = Color(0xFFE0E0E0);
  static const borderLight = Color(0xFFF0F0F0);
  static const divider = Color(0xFFEEEEEE);

  // Bottom nav
  static const navActive = Color(0xFF1B5E20);
  static const navInactive = Color(0xFF9E9E9E);
  static const navBackground = Color(0xFFFFFFFF);

  // Misc
  static const shimmer = Color(0xFFE0E0E0);
  static const overlay = Color(0x80000000);

  // Gradients
  static const greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
  );

  static const tealGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF00897B), Color(0xFF00695C)],
  );

  static const alertGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC62828), Color(0xFFB71C1C)],
  );

  static const surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8F5E9), Color(0xFFF5F7F5)],
  );

  // Route details — multi-accent palette (beyond primary green)
  static const accentBlue = Color(0xFF1565C0);
  static const accentIndigo = Color(0xFF283593);
  static const accentAmber = Color(0xFFF57F17);
  static const accentTeal = Color(0xFF00695C);
  static const accentPurple = Color(0xFF6A1B9A);
  static const accentBrown = Color(0xFF5D4037);

  static const routeHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
  );

  static const routeHeroGradientEv = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B5E20), Color(0xFF00897B)],
  );
}
