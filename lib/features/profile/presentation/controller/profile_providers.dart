import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:journeyplus/features/auth/presentation/auth_ui_state.dart';
import 'package:journeyplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:journeyplus/features/profile/data/local_db/profile_box.dart';
import 'package:journeyplus/features/profile/data/repository/profile_repository.dart';
import 'package:journeyplus/features/profile/presentation/controller/profile_controller.dart';
import 'package:journeyplus/features/profile/presentation/controller/profile_ui_state.dart';

/// Wraps the already-opened Hive box (`main.dart` opens it at boot).
final profileBoxProvider = Provider<ProfileBox>((ref) {
  return ProfileBox(Hive.box<dynamic>(ProfileBox.boxName));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(box: ref.watch(profileBoxProvider));
});

/// UID for the signed-in session. Prefer [authUiProvider] so profile works as soon
/// as [AuthGate] shows [AuthReady], even when [firebaseUserProvider] is still loading.
String? profileSessionUid(Ref ref) {
  final authState = ref.watch(authUiProvider).valueOrNull;
  if (authState != null) {
    switch (authState) {
      case AuthSignedOut():
        break;
      case AuthNeedsRegistration(:final firebaseUser):
        return firebaseUser.uid;
      case AuthReady(:final profile):
        return profile.uid;
    }
  }
  return ref.watch(firebaseUserProvider).valueOrNull?.uid;
}

final profileSessionUidProvider = Provider<String?>((ref) {
  return profileSessionUid(ref);
});

/// Per-user profile controller. Kept alive while signed in so async [save]
/// does not complete after autoDispose (profile tab / setup).
final profileControllerProvider =
    StateNotifierProvider.autoDispose<ProfileController, ProfileUiState>((ref) {
  final uid = profileSessionUid(ref);
  if (uid == null) {
    throw StateError(
      'profileControllerProvider read while signed-out — guard with AuthGate.',
    );
  }

  final keepAlive = ref.keepAlive();
  ref.listen(authUiProvider, (previous, next) {
    if (next.valueOrNull is AuthSignedOut) {
      keepAlive.close();
    }
  });

  return ProfileController(
    repository: ref.watch(profileRepositoryProvider),
    uid: uid,
  );
});
