import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';

/// Rounded surface card used by the community block on station detail.
class CommunitySectionShell extends StatelessWidget {
  final Widget child;

  const CommunitySectionShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }
}
