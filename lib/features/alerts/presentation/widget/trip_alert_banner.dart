import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/alerts/presentation/controller/alerts_providers.dart';

/// In-app banner for the latest predictive alert.
///
/// P2-007 — Three severity tiers with different dismissal behaviours:
///
/// | Severity | Style          | Dismiss |
/// |----------|----------------|---------|
/// | critical | Full-width red | Manual × only |
/// | warning  | Full-width amber | Auto-dismiss 8 s OR manual × |
/// | info     | Slim green pill | Auto-dismiss 5 s, no × |
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
          ? _SeverityBanner(
              key: ValueKey(alert.id), // re-creates timer when alert changes
              alert: alert,
              onDismiss: () =>
                  ref.read(alertNotifierProvider.notifier).dismissBanner(),
            )
          : const SizedBox.shrink(),
    );
  }
}

// ---------------------------------------------------------------------------
// Stateful banner — owns the auto-dismiss timer
// ---------------------------------------------------------------------------
class _SeverityBanner extends StatefulWidget {
  const _SeverityBanner({super.key, required this.alert, required this.onDismiss});

  final Alert alert;
  final VoidCallback onDismiss;

  @override
  State<_SeverityBanner> createState() => _SeverityBannerState();
}

class _SeverityBannerState extends State<_SeverityBanner> {
  Timer? _timer;

  /// P2-007 — seconds until auto-dismiss; null = must tap ×.
  int? get _autoDismissSeconds => switch (widget.alert.severity) {
        AlertSeverity.critical => null,
        AlertSeverity.warning => 8,
        AlertSeverity.info => 5,
      };

  @override
  void initState() {
    super.initState();
    final secs = _autoDismissSeconds;
    if (secs != null) {
      _timer = Timer(Duration(seconds: secs), widget.onDismiss);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.alert.severity) {
      AlertSeverity.info => _InfoPill(
          alert: widget.alert,
        ),
      _ => _FullBanner(
          alert: widget.alert,
          onDismiss: widget.onDismiss,
          autoDismissSeconds: _autoDismissSeconds,
        ),
    };
  }
}

// ---------------------------------------------------------------------------
// Full-width banner (critical + warning)
// ---------------------------------------------------------------------------
class _FullBanner extends StatelessWidget {
  const _FullBanner({
    required this.alert,
    required this.onDismiss,
    this.autoDismissSeconds,
  });

  final Alert alert;
  final VoidCallback onDismiss;
  final int? autoDismissSeconds;

  @override
  Widget build(BuildContext context) {
    // Colour from severity; glyph from alert type (P2-007).
    final (Color bg, Color fg) = switch (alert.severity) {
      AlertSeverity.critical => (AppColors.error, Colors.white),
      AlertSeverity.warning => (AppColors.warning, Colors.white),
      AlertSeverity.info => (AppColors.primary, Colors.white),
    };
    final icon = alert.type.icon;

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
                    if (autoDismissSeconds != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          'Dismisses in ${autoDismissSeconds}s',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: fg.withValues(alpha: 0.65),
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // critical = always show ×; warning = show ×; info never reaches here
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

// ---------------------------------------------------------------------------
// Slim info pill (info severity only)
// ---------------------------------------------------------------------------
class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        color: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(
          children: [
            Icon(alert.type.icon, size: 15, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${alert.type.label} · ${alert.message}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'Auto',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
