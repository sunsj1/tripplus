import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripplus/features/auth/domain/user_profile.dart';

/// Persists user profile in Firestore only (no Firebase Storage — MVP / free tier).
class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  Future<void> saveProfile({
    required User user,
    required String firstName,
    required String lastName,
    String? phoneE164,
    required String vehicleName,
    String? photoUrl,
    required String authProvider,
  }) async {
    final email = user.email?.trim();
    final profile = UserProfile(
      uid: user.uid,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phoneE164: phoneE164?.trim().isEmpty ?? true ? null : phoneE164!.trim(),
      email: email != null && email.isNotEmpty ? email : null,
      vehicleName: vehicleName.trim(),
      photoUrl: photoUrl,
      profileComplete: true,
      authProvider: authProvider,
    );

    final docRef = _doc(user.uid);
    final existed = (await docRef.get()).exists;
    await docRef.set({
      ...profile.toFirestore(),
      if (!existed) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
