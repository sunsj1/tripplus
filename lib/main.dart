import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripplus/core/constants/cache_constants.dart';
import 'package:tripplus/core/theme/app_theme.dart';
import 'package:tripplus/features/community/data/local_db/community_local_db.dart';
import 'package:tripplus/features/onboarding/presentation/view/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  await Hive.openBox(CacheConstants.chargingBoxName);
  await Hive.openBox(CommunityLocalDb.boxName);

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
      home: const OnboardingScreen(),
    );
  }
}
