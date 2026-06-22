import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:journeyplus/features/auth/domain/user_profile.dart';

String? _pickPhoto(String? fromProfile, String? fromAuth) {
  if (fromProfile != null && fromProfile.isNotEmpty) return fromProfile;
  return fromAuth;
}

/// Canonical user snapshot for Riverpod: use [userAppStateProvider] anywhere you
/// need id, name, phone, or email after sign-in.
@immutable
class UserAppState {
  const UserAppState({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.mobileNumber,
    this.email,
    this.vehicleName,
    this.photoUrl,
    this.profileComplete = false,
  });

  /// Firebase Auth uid (same as Firestore `users` document id).
  final String userId;
  final String firstName;
  final String lastName;
  /// E.164 when set (e.g. +919876543210).
  final String? mobileNumber;
  final String? email;
  final String? vehicleName;
  final String? photoUrl;
  final bool profileComplete;

  String get displayName {
    final a = firstName.trim();
    final b = lastName.trim();
    if (a.isEmpty && b.isEmpty) return 'User';
    if (a.isEmpty) return b;
    if (b.isEmpty) return a;
    return '$a $b';
  }

  /// Builds from Firebase [User] plus optional Firestore [UserProfile].
  factory UserAppState.fromAuthAndProfile({
    required User authUser,
    UserProfile? profile,
  }) {
    final p = profile;
    final storedEmail = p?.email?.trim();
    return UserAppState(
      userId: authUser.uid,
      firstName: p?.firstName ?? '',
      lastName: p?.lastName ?? '',
      mobileNumber: p?.phoneE164 ?? authUser.phoneNumber,
      email: (storedEmail != null && storedEmail.isNotEmpty)
          ? storedEmail
          : authUser.email,
      vehicleName: p?.vehicleName ?? '',
      photoUrl: _pickPhoto(p?.photoUrl, authUser.photoURL),
      profileComplete: p?.profileComplete ?? false,
    );
  }
}
