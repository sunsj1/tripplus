import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.firstName,
    required this.lastName,
    this.phoneE164,
    this.email,
    this.vehicleName = '',
    this.photoUrl,
    this.profileComplete = false,
    this.authProvider = 'unknown',
  });

  final String uid;
  final String firstName;
  final String lastName;
  final String? phoneE164;
  final String? email;
  final String vehicleName;
  final String? photoUrl;
  final bool profileComplete;
  final String authProvider;

  String get displayName {
    final a = firstName.trim();
    final b = lastName.trim();
    if (a.isEmpty && b.isEmpty) return 'User';
    if (a.isEmpty) return b;
    if (b.isEmpty) return a;
    return '$a $b';
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneE164': phoneE164,
      'email': email,
      'vehicleName': vehicleName,
      'photoUrl': photoUrl,
      'profileComplete': profileComplete,
      'authProvider': authProvider,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data() ?? {};
    return UserProfile(
      uid: snap.id,
      firstName: d['firstName'] as String? ?? '',
      lastName: d['lastName'] as String? ?? '',
      phoneE164: d['phoneE164'] as String?,
      email: d['email'] as String?,
      vehicleName: d['vehicleName'] as String? ?? '',
      photoUrl: d['photoUrl'] as String?,
      profileComplete: d['profileComplete'] as bool? ?? false,
      authProvider: d['authProvider'] as String? ?? 'unknown',
    );
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? phoneE164,
    String? email,
    String? vehicleName,
    String? photoUrl,
    bool? profileComplete,
    String? authProvider,
  }) {
    return UserProfile(
      uid: uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneE164: phoneE164 ?? this.phoneE164,
      email: email ?? this.email,
      vehicleName: vehicleName ?? this.vehicleName,
      photoUrl: photoUrl ?? this.photoUrl,
      profileComplete: profileComplete ?? this.profileComplete,
      authProvider: authProvider ?? this.authProvider,
    );
  }
}
