import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static const String openChargeMapBaseUrl =
      'https://api.openchargemap.io/v3';

  static String get openChargeMapApiKey =>
      dotenv.env['OPEN_CHARGE_MAP_API_KEY'] ?? '';

  static String get googleMapsApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  /// True when `.env` has a real Maps key (iOS native also needs it via `EnvKeys.xcconfig`).
  static bool get isGoogleMapsKeyConfigured {
    final k = googleMapsApiKey.trim();
    return k.isNotEmpty && k != 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
  }

  static const int defaultMaxResults = 50;

  static const double defaultRadiusKm = 100;
}
