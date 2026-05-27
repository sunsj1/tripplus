import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tripplus/features/auth/presentation/providers/auth_providers.dart';
import 'package:tripplus/features/profile/data/local_db/profile_box.dart';
import 'package:tripplus/features/profile/data/repository/profile_repository.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_controller.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_ui_state.dart';

/// Wraps the already-opened Hive box (`main.dart` opens it at boot).
final profileBoxProvider = Provider<ProfileBox>((ref) {
  return ProfileBox(Hive.box<dynamic>(ProfileBox.boxName));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(box: ref.watch(profileBoxProvider));
});

/// Per-user profile controller. AutoDispose so that signing out resets it.
final profileControllerProvider =
    StateNotifierProvider.autoDispose<ProfileController, ProfileUiState>((ref) {
  final user = ref.watch(firebaseUserProvider).valueOrNull;
  if (user == null) {
    throw StateError(
      'profileControllerProvider read while signed-out — guard with AuthGate.',
    );
  }
  return ProfileController(
    repository: ref.watch(profileRepositoryProvider),
    uid: user.uid,
  );
});
