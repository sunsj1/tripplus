import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

/// Shown while a trip is running but GPS is missing or stale.
///
/// Mirrors [OfflineBanner] so degraded location never looks “fine but quiet”.
class GpsStaleBanner extends ConsumerStatefulWidget {
  const GpsStaleBanner({super.key});

  static const Duration staleAfter = Duration(seconds: 60);

  @override
  ConsumerState<GpsStaleBanner> createState() => _GpsStaleBannerState();
}

class _GpsStaleBannerState extends ConsumerState<GpsStaleBanner> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(activeTripControllerProvider);
    final position = ref.watch(tripPositionProvider);

    final show = tripState is ActiveTripRunning &&
        (position == null || position.isStale(maxAge: GpsStaleBanner.staleAfter));

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: show
          ? Container(
              width: double.infinity,
              color: AppColors.warning,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.gps_off_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Location paused — alerts & ahead lists may be outdated',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
