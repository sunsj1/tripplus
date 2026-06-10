import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/services/ai_service.dart';

final _aiDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 90),
      headers: {'Content-Type': 'application/json'},
    ),
  );
});

String get _proxyBaseUrl =>
    dotenv.env['AI_PROXY_BASE_URL']?.trimRight().replaceAll(RegExp(r'/$'), '') ??
    'https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net';

final aiServiceProvider = Provider<AiService>((ref) {
  return RemoteAiService(
    dio: ref.watch(_aiDioProvider),
    getIdToken: () async => await FirebaseAuth.instance.currentUser?.getIdToken(),
    proxyBaseUrl: _proxyBaseUrl,
  );
});
