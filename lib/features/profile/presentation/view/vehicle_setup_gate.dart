import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/features/profile/presentation/controller/profile_providers.dart';
import 'package:journeyplus/features/profile/presentation/view/profile_setup_screen.dart';
import 'package:journeyplus/features/shell/presentation/view/app_shell.dart';

/// Sits between [AuthReady] and [AppShell]. If the user has no vehicle on
/// file we route them to [ProfileSetupScreen] first; otherwise the shell
/// renders immediately.
class VehicleSetupGate extends ConsumerWidget {
  const VehicleSetupGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(profileSessionUidProvider);
    if (uid == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    final state = ref.watch(profileControllerProvider);
    if (state.data.isVehicleSetupComplete) {
      return const AppShell();
    }
    return const ProfileSetupScreen();
  }
}
