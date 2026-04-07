import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/features/auth/data/auth_repository.dart';
import 'package:tripplus/features/auth/data/user_profile_repository.dart';
import 'package:tripplus/features/auth/domain/user_app_state.dart';
import 'package:tripplus/features/auth/domain/user_profile.dart';
import 'package:tripplus/features/auth/presentation/auth_ui_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

/// Current Firebase user (null when signed out).
final firebaseUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

AuthUiState _mapUserDoc(
  User user,
  DocumentSnapshot<Map<String, dynamic>> snap,
) {
  if (!snap.exists || snap.data() == null) {
    return AuthNeedsRegistration(user, null);
  }
  final p = UserProfile.fromFirestore(snap);
  if (p.profileComplete) {
    return AuthReady(p);
  }
  return AuthNeedsRegistration(user, p);
}

/// Merges [authStateChanges] with the signed-in user's Firestore profile doc.
final authUiProvider = StreamProvider<AuthUiState>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncExpand((user) {
    if (user == null) {
      return Stream.value(AuthSignedOut());
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snap) => _mapUserDoc(user, snap));
  });
});

/// Non-null while the user finished registration (for shell / top bar).
final currentProfileProvider = Provider<UserProfile?>((ref) {
  final async = ref.watch(authUiProvider);
  if (!async.hasValue) return null;
  final state = async.requireValue;
  return switch (state) {
    AuthReady(:final profile) => profile,
    _ => null,
  };
});

/// App-wide user snapshot: **userId**, names, **mobileNumber** (E.164), **email**.
/// `null` when signed out. While Firestore is still loading, values may come only
/// from [User] (e.g. email from Google) with empty names until the profile loads.
final userAppStateProvider = Provider<UserAppState?>((ref) {
  final user = ref.watch(firebaseUserProvider).valueOrNull;
  if (user == null) return null;

  final uiAsync = ref.watch(authUiProvider);
  if (uiAsync.isLoading || uiAsync.hasError) {
    return UserAppState.fromAuthAndProfile(authUser: user, profile: null);
  }
  if (!uiAsync.hasValue) {
    return UserAppState.fromAuthAndProfile(authUser: user, profile: null);
  }

  return switch (uiAsync.requireValue) {
    AuthSignedOut() => null,
    AuthNeedsRegistration(:final existing) => UserAppState.fromAuthAndProfile(
        authUser: user,
        profile: existing,
      ),
    AuthReady(:final profile) => UserAppState.fromAuthAndProfile(
        authUser: user,
        profile: profile,
      ),
  };
});
