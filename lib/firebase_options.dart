// Generated from google-services.json + GoogleService-Info.plist (JourneyPlus apps).
// flutterfire configure failed on xcodeproj gem — IDs synced manually from Firebase.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('JourneyPlus: configure Firebase for web if needed.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not set for $defaultTargetPlatform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDG7cZmPekYfjPdbOHiV9-NVcu9DxEH9GU',
    appId: '1:840443034452:android:cf427643582e84231ba6c1',
    messagingSenderId: '840443034452',
    projectId: 'tripplus-8aff2',
    storageBucket: 'tripplus-8aff2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmF7OlZJtZRYzhWzA50J4vMDMhUrYXKQY',
    appId: '1:840443034452:ios:486b214c49cf96aa1ba6c1',
    messagingSenderId: '840443034452',
    projectId: 'tripplus-8aff2',
    storageBucket: 'tripplus-8aff2.firebasestorage.app',
    iosClientId:
        '840443034452-4nujp8e8hrlae9pu9r4218b713vdbtb2.apps.googleusercontent.com',
    iosBundleId: 'com.journeyplus.journeyplus',
  );
}
