import 'package:flutter_test/flutter_test.dart';
import 'package:journeyplus/core/services/app_update_service.dart';
import 'package:journeyplus/core/widgets/app_update_prompt.dart';

void main() {
  AppUpdateCheck check({
    AppUpdateAvailability availability = AppUpdateAvailability.available,
    AppUpdateInstallState installState = AppUpdateInstallState.unknown,
    bool flexibleAllowed = false,
    bool immediateAllowed = false,
  }) {
    return AppUpdateCheck(
      availability: availability,
      installState: installState,
      flexibleAllowed: flexibleAllowed,
      immediateAllowed: immediateAllowed,
      availableVersionCode: 6,
    );
  }

  group('selectAppUpdatePromptMode', () {
    test('does nothing when Play reports no update', () {
      expect(
        selectAppUpdatePromptMode(const AppUpdateCheck.none()),
        AppUpdatePromptMode.none,
      );
    });

    test('prefers flexible update when both modes are allowed', () {
      expect(
        selectAppUpdatePromptMode(
          check(flexibleAllowed: true, immediateAllowed: true),
        ),
        AppUpdatePromptMode.flexible,
      );
    });

    test('falls back to immediate Play flow when flexible is unavailable', () {
      expect(
        selectAppUpdatePromptMode(check(immediateAllowed: true)),
        AppUpdatePromptMode.immediate,
      );
    });

    test('offers install when an interrupted download is complete', () {
      expect(
        selectAppUpdatePromptMode(
          check(
            availability: AppUpdateAvailability.inProgress,
            installState: AppUpdateInstallState.downloaded,
          ),
        ),
        AppUpdatePromptMode.completeDownloaded,
      );
    });

    test('does not duplicate an update already downloading', () {
      expect(
        selectAppUpdatePromptMode(
          check(
            availability: AppUpdateAvailability.inProgress,
            installState: AppUpdateInstallState.downloading,
            flexibleAllowed: true,
          ),
        ),
        AppUpdatePromptMode.none,
      );
    });

    test('does nothing when Play disallows both update modes', () {
      expect(
        selectAppUpdatePromptMode(check()),
        AppUpdatePromptMode.none,
      );
    });
  });
}
