import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripplus/core/constants/cache_constants.dart';
import 'package:tripplus/core/theme/app_theme.dart';
import 'package:tripplus/features/auth/presentation/view/auth_gate.dart';
import 'package:tripplus/features/community/data/community_submit_queue.dart';
import 'package:tripplus/features/profile/data/local_db/profile_box.dart';
import 'package:tripplus/core/services/local_notification_service.dart';
import 'package:tripplus/features/trip/data/local_db/corridor_cache_box.dart';
import 'package:tripplus/features/trip/data/local_db/trip_box.dart';
import 'package:tripplus/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dart's [Firebase.apps] can lag behind native; the OS may already have registered
  // [DEFAULT] from GoogleService-Info / google-services.json. Hot restart can also
  // leave the native app alive while Dart runs main() again.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  // P1-064 — Crashlytics init only. Deeper integration (custom keys, user
  // context, breadcrumb logging) is Phase 2's P2-071. Debug builds skip
  // collection so local crashes don't pollute the dashboard. Note: Android
  // native uploads also need the Crashlytics gradle plugin — wired in P2-071.
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  await Hive.openBox(CacheConstants.chargingBoxName);
  await Hive.openBox<dynamic>(CommunitySubmitQueue.boxName);
  await Hive.openBox<dynamic>(ProfileBox.boxName);
  await Hive.openBox<dynamic>(TripBox.boxName);          // P1-040 active_trip box
  await Hive.openBox<dynamic>(CorridorCacheBox.boxName); // P1-043 corridor_cache box

  // P1-027 — local notifications for predictive alerts (delivery in P1-028).
  final notifications = LocalNotificationService();
  await notifications.initialize();

  runApp(const ProviderScope(child: TripPlusApp()));
}

class TripPlusApp extends StatelessWidget {
  const TripPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripPlus — Highway Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}
