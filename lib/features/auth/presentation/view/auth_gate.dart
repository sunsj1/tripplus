import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/auth/presentation/auth_ui_state.dart';
import 'package:tripplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:tripplus/features/auth/presentation/view/profile_form_screen.dart';
import 'package:tripplus/features/onboarding/presentation/view/onboarding_screen.dart';
import 'package:tripplus/features/profile/presentation/view/vehicle_setup_gate.dart';

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
        AuthReady() => const VehicleSetupGate(),
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => _SessionErrorScreen(error: e),
    );
  }
}

class _SessionErrorScreen extends ConsumerWidget {
  const _SessionErrorScreen({required this.error});

  final Object error;

  bool get _isFirestorePermissionDenied {
    final msg = error.toString();
    return msg.contains('permission-denied');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Could not load session',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _isFirestorePermissionDenied
                    ? 'Firestore rejected this request. If you are the project owner, deploy security rules from the repo root:\n\nfirebase deploy --only firestore:rules\n\nOtherwise try signing out and back in.'
                    : error.toString(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => ref.invalidate(authUiProvider),
                child: const Text('Retry'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  ref.invalidate(authUiProvider);
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
