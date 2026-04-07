import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripplus/core/constants/cache_constants.dart';
import 'package:tripplus/core/theme/app_theme.dart';
import 'package:tripplus/features/auth/presentation/view/auth_gate.dart';
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

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  await Hive.openBox(CacheConstants.chargingBoxName);

  runApp(const ProviderScope(child: TripPlusApp()));
}

class TripPlusApp extends StatelessWidget {
  const TripPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripPlus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}
