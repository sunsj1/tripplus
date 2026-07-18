import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/features/settings/domain/app_settings.dart';
import 'package:journeyplus/features/settings/presentation/controller/settings_controller.dart';

/// P2-053 — Per-device settings: distance units + notification preferences.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text('Settings', style: AppTextStyles.titleMedium),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            // ── Display section ──────────────────────────────────────────
            _SectionLabel('DISPLAY'),
            _Card(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.straighten_outlined,
                      color: AppColors.primary),
                  title: const Text('Distance units'),
                  subtitle: Text(settings.distanceUnit.label),
                  trailing: SegmentedButton<DistanceUnit>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: DistanceUnit.km, label: Text('km')),
                      ButtonSegment(value: DistanceUnit.miles, label: Text('mi')),
                    ],
                    selected: {settings.distanceUnit},
                    onSelectionChanged: (s) =>
                        controller.setDistanceUnit(s.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Notifications section ────────────────────────────────────
            _SectionLabel('ALERTS & NOTIFICATIONS'),
            _Card(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Predictive alerts'),
                  subtitle: const Text(
                      'Master switch — turn off to silence everything'),
                  secondary: const Icon(Icons.notifications_active_outlined,
                      color: AppColors.primary),
                  value: settings.alertsEnabled,
                  onChanged: controller.setAlertsEnabled,
                ),
                const Divider(height: 4),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('System notifications'),
                  subtitle: const Text(
                      'Show alerts even when JourneyPlus is in the background'),
                  secondary: const Icon(Icons.system_security_update_good_outlined,
                      color: AppColors.primary),
                  value: settings.systemNotificationsEnabled &&
                      settings.alertsEnabled,
                  onChanged: settings.alertsEnabled
                      ? controller.setSystemNotificationsEnabled
                      : null,
                ),
                const Divider(height: 4),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.trip_origin_outlined,
                      color: AppColors.primary),
                  title: Text('Trip tracking notification'),
                  subtitle: Text(
                    'While a trip is running, Android shows “JourneyPlus trip '
                    'tracking” so corridor alerts can continue in the '
                    'background. Keep that notification enabled for '
                    'locked-screen and Maps-background alerts.',
                  ),
                  isThreeLine: true,
                ),
              ],
            ),
            if (defaultTargetPlatform == TargetPlatform.android) ...[
              const SizedBox(height: 12),
              _SectionLabel('BACKGROUND RELIABILITY'),
              _Card(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.battery_saver_outlined,
                        color: AppColors.primary),
                    title: const Text('Some phones pause tracking'),
                    subtitle: const Text(
                      'Xiaomi, Oppo, Vivo and similar OEMs may stop '
                      'background location unless battery is unrestricted '
                      'or autostart is allowed. Open app settings to check.',
                    ),
                    isThreeLine: true,
                    trailing: TextButton(
                      onPressed: Geolocator.openAppSettings,
                      child: const Text('Open'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            _SectionLabel('PER-ALERT MUTE'),
            _Card(
              children: [
                for (final type in AlertType.values)
                  _AlertMuteTile(
                    type: type,
                    muted: settings.mutedAlertTypes
                        .contains(_wire(type)),
                    parentEnabled: settings.alertsEnabled,
                    onToggle: () => controller.toggleMute(type),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Settings are stored on this device only.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internals
// ---------------------------------------------------------------------------
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(children: children),
    );
  }
}

class _AlertMuteTile extends StatelessWidget {
  const _AlertMuteTile({
    required this.type,
    required this.muted,
    required this.parentEnabled,
    required this.onToggle,
  });

  final AlertType type;
  final bool muted;
  final bool parentEnabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final effectivelyMuted = muted || !parentEnabled;
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(
        type.icon,
        color: effectivelyMuted
            ? AppColors.textTertiary
            : AppColors.primary,
      ),
      title: Text(type.label),
      subtitle: effectivelyMuted
          ? const Text('Muted')
          : const Text('Will fire'),
      value: !muted,
      onChanged: parentEnabled ? (_) => onToggle() : null,
    );
  }
}

String _wire(AlertType t) {
  switch (t) {
    case AlertType.fuelLow:
      return 'fuel_low';
    case AlertType.evGap:
      return 'ev_gap';
    case AlertType.foodWindow:
      return 'food_window';
    case AlertType.ghat:
      return 'ghat';
    case AlertType.night:
      return 'night';
    case AlertType.fatigue:
      return 'fatigue';
    case AlertType.weather:
      return 'weather';
  }
}
