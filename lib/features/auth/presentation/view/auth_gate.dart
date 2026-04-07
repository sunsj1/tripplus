import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/features/auth/presentation/auth_ui_state.dart';
import 'package:tripplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:tripplus/features/auth/presentation/view/profile_form_screen.dart';
import 'package:tripplus/features/onboarding/presentation/view/onboarding_screen.dart';
import 'package:tripplus/features/shell/presentation/view/app_shell.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authUiProvider);

    return auth.when(
      data: (state) => switch (state) {
        AuthSignedOut() => const OnboardingScreen(),
        AuthNeedsRegistration(:final firebaseUser, :final existing) =>
          ProfileFormScreen(
            user: firebaseUser,
            existingProfile: existing,
            isEditMode: false,
          ),
        AuthReady() => const AppShell(),
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Could not load session.\n$e',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
