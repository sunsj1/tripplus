// File generated from Firebase app configs (google-services.json + GoogleService-Info.plist).
// Re-run `flutterfire configure` after installing the xcodeproj gem if you add platforms.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDG7cZmPekYfjPdbOHiV9-NVcu9DxEH9GU',
    appId: '1:840443034452:android:04abcc0ecfcdb88f1ba6c1',
    messagingSenderId: '840443034452',
    projectId: 'tripplus-8aff2',
    storageBucket: 'tripplus-8aff2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmF7OlZJtZRYzhWzA50J4vMDMhUrYXKQY',
    appId: '1:840443034452:ios:1a118242ac69da9a1ba6c1',
    messagingSenderId: '840443034452',
    projectId: 'tripplus-8aff2',
    storageBucket: 'tripplus-8aff2.firebasestorage.app',
    iosClientId:
        '840443034452-onmuspsi946895fufcf1i3velu3jj8qg.apps.googleusercontent.com',
    iosBundleId: 'com.tripplus.tripplus',
  );
}
