import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/alerts/presentation/controller/alerts_providers.dart';

/// In-app banner for the latest predictive alert (`P1-028`).
class TripAlertBanner extends ConsumerWidget {
  const TripAlertBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifierState = ref.watch(alertNotifierProvider);
    final alert = notifierState.activeBanner;
    final visible = alert != null && !notifierState.bannerDismissed;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: visible
          ? _Banner(
              alert: alert,
              onDismiss: () =>
                  ref.read(alertNotifierProvider.notifier).dismissBanner(),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.alert, required this.onDismiss});

  final Alert alert;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, IconData icon) = switch (alert.severity) {
      AlertSeverity.critical => (
          AppColors.error,
          Colors.white,
          Icons.warning_amber_rounded,
        ),
      AlertSeverity.warning => (
          AppColors.warning,
          Colors.white,
          Icons.info_outline_rounded,
        ),
      AlertSeverity.info => (
          AppColors.primary,
          Colors.white,
          Icons.restaurant_outlined,
        ),
    };

    return Material(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: fg),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.type.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alert.message,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: fg.withValues(alpha: 0.95),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: Icon(Icons.close, size: 20, color: fg),
                tooltip: 'Dismiss',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
