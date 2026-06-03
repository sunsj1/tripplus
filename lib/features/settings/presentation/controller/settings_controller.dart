import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/features/settings/data/local_db/settings_box.dart';
import 'package:tripplus/features/settings/domain/app_settings.dart';

/// P2-053 — Holds the live [AppSettings] and persists every change to Hive
/// immediately. Reads are synchronous on construction (Hive is in-memory after
/// init), so the rest of the app can `ref.read(...)` without futures.
class SettingsController extends StateNotifier<AppSettings> {
  SettingsController() : super(SettingsBox.read());

  Future<void> setDistanceUnit(DistanceUnit unit) async {
    state = state.copyWith(distanceUnit: unit);
    await SettingsBox.save(state);
  }

  Future<void> setAlertsEnabled(bool enabled) async {
    state = state.copyWith(alertsEnabled: enabled);
    await SettingsBox.save(state);
  }

  Future<void> setSystemNotificationsEnabled(bool enabled) async {
    state = state.copyWith(systemNotificationsEnabled: enabled);
    await SettingsBox.save(state);
  }

  Future<void> toggleMute(AlertType type) async {
    state = state.toggleMute(type);
    await SettingsBox.save(state);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettings>(
  (ref) => SettingsController(),
);
