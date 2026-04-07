// Replace this file by running:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
// Or paste values from Firebase Console → Project settings → Your apps.
//
// Values below are placeholders so the project compiles; auth will not work
// until you use real keys from your Firebase project.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('TripPlus: configure Firebase for web if needed.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not set for $defaultTargetPlatform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_ANDROID_API_KEY_FROM_CONSOLE',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'YOUR_FIREBASE_PROJECT_ID',
    storageBucket: 'YOUR_FIREBASE_PROJECT_ID.appspot.com',
  );

  /// [iosClientId] is the "iOS client" OAuth ID from GoogleService-Info.plist (CLIENT_ID).
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_IOS_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'YOUR_FIREBASE_PROJECT_ID',
    storageBucket: 'YOUR_FIREBASE_PROJECT_ID.appspot.com',
    iosClientId: 'REPLACE_IOS_CLIENT_ID.apps.googleusercontent.com',
    iosBundleId: 'com.tripplus.tripplus',
  );
}
