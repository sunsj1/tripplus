import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/services/app_update_service.dart';
import 'package:journeyplus/core/telemetry/app_telemetry.dart';
import 'package:journeyplus/features/trip/presentation/controller/active_trip_state.dart';
import 'package:journeyplus/features/trip/presentation/controller/trip_providers.dart';

enum AppUpdatePromptMode {
  none,
  flexible,
  immediate,
  completeDownloaded,
}

/// Pure policy kept separate from Google Play APIs for deterministic tests.
AppUpdatePromptMode selectAppUpdatePromptMode(AppUpdateCheck check) {
  if (check.availability == AppUpdateAvailability.none) {
    return AppUpdatePromptMode.none;
  }

  if (check.installState == AppUpdateInstallState.downloaded) {
    return AppUpdatePromptMode.completeDownloaded;
  }

  // An interrupted flexible update is already owned by Play. Do not start a
  // second flow while it is downloading/installing; check again on resume.
  if (check.availability == AppUpdateAvailability.inProgress &&
      {
        AppUpdateInstallState.pending,
        AppUpdateInstallState.downloading,
        AppUpdateInstallState.installing,
      }.contains(check.installState)) {
    return AppUpdatePromptMode.none;
  }

  if (check.flexibleAllowed) return AppUpdatePromptMode.flexible;
  if (check.immediateAllowed) return AppUpdatePromptMode.immediate;
  return AppUpdatePromptMode.none;
}

/// Checks Google Play once the authenticated shell is visible.
///
/// Behavior:
/// - Android release builds only (Play Core is unavailable on iOS/web/debug).
/// - Never interrupts an actively running trip.
/// - Flexible update first; immediate Play UI only when flexible is disallowed.
/// - Sideloaded/offline/unsupported checks fail silently and retry on resume.
/// - Downloaded flexible updates offer a safe restart/install prompt.
class AppUpdatePrompt extends ConsumerStatefulWidget {
  const AppUpdatePrompt({
    super.key,
    this.service = const PlayAppUpdateService(),
    this.allowDebugChecks = false,
    this.initialDelay = const Duration(seconds: 2),
  });

  final AppUpdateService service;

  /// Test-only seam. Production should keep this false.
  final bool allowDebugChecks;

  final Duration initialDelay;

  @override
  ConsumerState<AppUpdatePrompt> createState() => _AppUpdatePromptState();
}

class _AppUpdatePromptState extends ConsumerState<AppUpdatePrompt>
    with WidgetsBindingObserver {
  Timer? _checkTimer;
  bool _checking = false;
  bool _finishedForSession = false;
  int _failedCheckAttempts = 0;

  bool get _platformSupported =>
      !kIsWeb &&
      defaultTargetPlatform == TargetPlatform.android &&
      (!kDebugMode || widget.allowDebugChecks);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _checkTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_finishedForSession) {
      _scheduleCheck(delay: const Duration(milliseconds: 700));
    }
  }

  void _scheduleCheck({Duration? delay}) {
    if (!_platformSupported || _checking || _finishedForSession) return;
    _checkTimer?.cancel();
    _checkTimer = Timer(delay ?? widget.initialDelay, _checkForUpdate);
  }

  Future<void> _checkForUpdate() async {
    if (!mounted || _checking || _finishedForSession) return;

    // Updating while driving is a distraction and may restart the app. Wait
    // until the trip stops, then the ref listener below schedules the check.
    if (ref.read(activeTripControllerProvider) is ActiveTripRunning) {
      AppTelemetry.appUpdateDeferred(reason: 'active_trip');
      return;
    }

    _checking = true;
    try {
      final check = await widget.service.checkForUpdate();
      if (!mounted) return;

      final mode = selectAppUpdatePromptMode(check);
      if (mode == AppUpdatePromptMode.none) {
        // For an in-progress download, allow a later resume to detect the
        // downloaded state. All other "none" states are done for this launch.
        _finishedForSession =
            check.availability != AppUpdateAvailability.inProgress;
        return;
      }

      AppTelemetry.appUpdateAvailable(
        versionCode: check.availableVersionCode,
        mode: mode.name,
      );
      await _showPrompt(mode);
    } catch (error) {
      _failedCheckAttempts++;
      // Typical causes are offline, sideloaded installs, or Play unavailable.
      // No alarming UI; permit two resume retries before stopping this launch.
      AppTelemetry.appUpdateFailed(stage: 'check', error: error);
      _finishedForSession = _failedCheckAttempts >= 3;
    } finally {
      _checking = false;
    }
  }

  Future<void> _showPrompt(AppUpdatePromptMode mode) async {
    if (!mounted) return;

    final restart = mode == AppUpdatePromptMode.completeDownloaded;
    final accepted = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) => AlertDialog(
            icon: Icon(
              restart ? Icons.system_update_alt : Icons.auto_awesome,
              color: Theme.of(dialogContext).colorScheme.primary,
            ),
            title: Text(restart ? 'Update ready' : 'Update JourneyPlus'),
            content: Text(
              restart
                  ? 'The latest JourneyPlus update is downloaded. Restart now '
                      'to finish installing it.'
                  : 'A new version is available with the latest reliability '
                      'improvements and fixes.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Later'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(restart ? 'Restart now' : 'Update'),
              ),
            ],
          ),
        ) ??
        false;

    if (!accepted) {
      _finishedForSession = true;
      AppTelemetry.appUpdateDeferred(reason: 'user_later');
      return;
    }

    AppTelemetry.appUpdateAccepted(mode: mode.name);
    await _runUpdate(mode);
  }

  Future<void> _runUpdate(AppUpdatePromptMode mode) async {
    try {
      switch (mode) {
        case AppUpdatePromptMode.completeDownloaded:
          await widget.service.completeFlexibleUpdate();
        case AppUpdatePromptMode.flexible:
          _showMessage('Downloading update… You can keep using JourneyPlus.');
          final result = await widget.service.startFlexibleUpdate();
          if (!mounted) return;
          if (result == AppUpdateActionResult.success) {
            _showMessage('Update downloaded. Restarting to install…');
            await widget.service.completeFlexibleUpdate();
          } else if (result == AppUpdateActionResult.failed) {
            _showMessage(
              'Couldn’t start the update. Please try again later in Google Play.',
            );
          }
        case AppUpdatePromptMode.immediate:
          final result = await widget.service.performImmediateUpdate();
          if (!mounted) return;
          if (result == AppUpdateActionResult.failed) {
            _showMessage(
              'Couldn’t start the update. Please try again later in Google Play.',
            );
          }
        case AppUpdatePromptMode.none:
          break;
      }
      _finishedForSession = true;
    } catch (error) {
      AppTelemetry.appUpdateFailed(stage: mode.name, error: error);
      if (mounted) {
        _showMessage(
          'Update unavailable right now. Please try again later in Google Play.',
        );
      }
      // Allow a retry after the app returns from background.
      _finishedForSession = false;
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ActiveTripState>(activeTripControllerProvider, (previous, next) {
      if (previous is ActiveTripRunning && next is! ActiveTripRunning) {
        _scheduleCheck(delay: const Duration(milliseconds: 700));
      }
    });
    return const SizedBox.shrink();
  }
}
