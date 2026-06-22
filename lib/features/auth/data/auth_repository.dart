import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journeyplus/firebase_options.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  static bool _googleInitialized = false;

  Future<void> ensureGoogleSignInInitialized() async {
    if (_googleInitialized) return;
    final iosClientId = DefaultFirebaseOptions.ios.iosClientId;
    final needsExplicitClientId =
        defaultTargetPlatform == TargetPlatform.iOS &&
            iosClientId != null &&
            !iosClientId.startsWith('REPLACE');
    await GoogleSignIn.instance.initialize(
      clientId: needsExplicitClientId ? iosClientId : null,
    );
    _googleInitialized = true;
  }

  Future<UserCredential> signInWithGoogle() async {
    await ensureGoogleSignInInitialized();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final auth = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );
      return _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        throw AuthCanceledException();
      }
      rethrow;
    }
  }

  // --- Phone / OTP sign-in (disabled for MVP — Google only) ---
  //
  // Future<void> sendPhoneVerificationCode({
  //   required String phoneNumberE164,
  //   int? forceResendingToken,
  //   required void Function(String verificationId, int? resendToken) onCodeSent,
  //   required void Function(FirebaseAuthException e) onVerificationFailed,
  // }) {
  //   return _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumberE164,
  //     timeout: const Duration(seconds: 90),
  //     forceResendingToken: forceResendingToken,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await _auth.signInWithCredential(credential);
  //     },
  //     verificationFailed: onVerificationFailed,
  //     codeSent: onCodeSent,
  //     codeAutoRetrievalTimeout: (_) {},
  //   );
  // }
  //
  // Future<UserCredential> signInWithSmsCode({
  //   required String verificationId,
  //   required String smsCode,
  // }) {
  //   final credential = PhoneAuthProvider.credential(
  //     verificationId: verificationId,
  //     smsCode: smsCode.trim(),
  //   );
  //   return _auth.signInWithCredential(credential);
  // }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }
}

class AuthCanceledException implements Exception {}
