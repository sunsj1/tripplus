import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripplus/features/auth/domain/user_profile.dart';

sealed class AuthUiState {}

final class AuthSignedOut extends AuthUiState {}

final class AuthNeedsRegistration extends AuthUiState {
  AuthNeedsRegistration(this.firebaseUser, this.existing);
  final User firebaseUser;
  final UserProfile? existing;
}

final class AuthReady extends AuthUiState {
  AuthReady(this.profile);
  final UserProfile profile;
}
