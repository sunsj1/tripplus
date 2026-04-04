import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final bool showMenu;
  final bool showBack;
  final VoidCallback? onBack;

  const AppTopBar({
    super.key,
    this.title = 'TripPlus',
    this.showMenu = true,
    this.showBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: const Icon(Icons.arrow_back_ios, size: 20),
            )
          else if (showMenu)
            const Icon(Icons.menu, size: 24, color: AppColors.textPrimary),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySurface,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: const Icon(
              Icons.person,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
