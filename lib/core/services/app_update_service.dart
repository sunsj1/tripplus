import 'package:in_app_update/in_app_update.dart';

/// Store-neutral update state used by presentation code and unit tests.
enum AppUpdateAvailability {
  none,
  available,
  inProgress,
}

enum AppUpdateInstallState {
  unknown,
  pending,
  downloading,
  downloaded,
  installing,
  installed,
  failed,
  canceled,
}

enum AppUpdateActionResult {
  success,
  userDenied,
  failed,
}

class AppUpdateCheck {
  const AppUpdateCheck({
    required this.availability,
    required this.installState,
    required this.flexibleAllowed,
    required this.immediateAllowed,
    this.availableVersionCode,
  });

  const AppUpdateCheck.none()
      : availability = AppUpdateAvailability.none,
        installState = AppUpdateInstallState.unknown,
        flexibleAllowed = false,
        immediateAllowed = false,
        availableVersionCode = null;

  final AppUpdateAvailability availability;
  final AppUpdateInstallState installState;
  final bool flexibleAllowed;
  final bool immediateAllowed;
  final int? availableVersionCode;
}

/// Small seam around Google Play Core so update policy remains testable.
abstract interface class AppUpdateService {
  Future<AppUpdateCheck> checkForUpdate();

  Future<AppUpdateActionResult> startFlexibleUpdate();

  Future<AppUpdateActionResult> performImmediateUpdate();

  Future<void> completeFlexibleUpdate();
}

class PlayAppUpdateService implements AppUpdateService {
  const PlayAppUpdateService();

  @override
  Future<AppUpdateCheck> checkForUpdate() async {
    final info = await InAppUpdate.checkForUpdate();
    return AppUpdateCheck(
      availability: switch (info.updateAvailability) {
        UpdateAvailability.updateAvailable => AppUpdateAvailability.available,
        UpdateAvailability.developerTriggeredUpdateInProgress =>
          AppUpdateAvailability.inProgress,
        _ => AppUpdateAvailability.none,
      },
      installState: _mapInstallState(info.installStatus),
      flexibleAllowed: info.flexibleUpdateAllowed,
      immediateAllowed: info.immediateUpdateAllowed,
      availableVersionCode: info.availableVersionCode,
    );
  }

  @override
  Future<void> completeFlexibleUpdate() =>
      InAppUpdate.completeFlexibleUpdate();

  @override
  Future<AppUpdateActionResult> performImmediateUpdate() async {
    return _mapResult(await InAppUpdate.performImmediateUpdate());
  }

  @override
  Future<AppUpdateActionResult> startFlexibleUpdate() async {
    return _mapResult(await InAppUpdate.startFlexibleUpdate());
  }

  static AppUpdateActionResult _mapResult(AppUpdateResult result) {
    return switch (result) {
      AppUpdateResult.success => AppUpdateActionResult.success,
      AppUpdateResult.userDeniedUpdate => AppUpdateActionResult.userDenied,
      AppUpdateResult.inAppUpdateFailed => AppUpdateActionResult.failed,
    };
  }

  static AppUpdateInstallState _mapInstallState(InstallStatus status) {
    return switch (status) {
      InstallStatus.pending => AppUpdateInstallState.pending,
      InstallStatus.downloading => AppUpdateInstallState.downloading,
      InstallStatus.downloaded => AppUpdateInstallState.downloaded,
      InstallStatus.installing => AppUpdateInstallState.installing,
      InstallStatus.installed => AppUpdateInstallState.installed,
      InstallStatus.failed => AppUpdateInstallState.failed,
      InstallStatus.canceled => AppUpdateInstallState.canceled,
      InstallStatus.unknown => AppUpdateInstallState.unknown,
    };
  }
}
