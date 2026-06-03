import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/personalization/domain/route_mode.dart';
import 'package:tripplus/features/personalization/presentation/controller/route_mode_provider.dart';

/// P2-020 / 021 / 022 — Horizontal mode selector shown above POI lists.
///
/// Tap a mode chip to engage that overlay; tap the active chip again to clear.
/// We surface the active mode's accent colour so the rest of the screen can
/// pick it up (badges, banners) without any prop drilling.
class RouteModeBar extends ConsumerWidget {
  const RouteModeBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(routeModeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'VIEW MODE',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 6),
              if (active != RouteMode.off)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: active.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'filtered',
                    style: AppTextStyles.caption.copyWith(
                      color: active.accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: RouteMode.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final mode = RouteMode.values[i];
                final isActive = mode == active;
                return _ModeChip(
                  mode: mode,
                  isActive: isActive,
                  onTap: () {
                    // Tap active mode again → clear back to "off".
                    final next = isActive ? RouteMode.off : mode;
                    ref.read(routeModeProvider.notifier).state = next;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.mode,
    required this.isActive,
    required this.onTap,
  });

  final RouteMode mode;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = isActive ? Colors.white : mode.accent;
    final bg = isActive ? mode.accent : AppColors.surface;
    final border = isActive
        ? mode.accent
        : mode.accent.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border, width: isActive ? 0 : 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(mode.icon, size: 13, color: fg),
            const SizedBox(width: 5),
            Text(
              mode.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
