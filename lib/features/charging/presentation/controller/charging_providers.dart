import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:journeyplus/core/constants/api_constants.dart';
import 'package:journeyplus/core/constants/cache_constants.dart';
import 'package:journeyplus/features/charging/data/local_db/charging_local_db.dart';
import 'package:journeyplus/features/charging/data/repository/charging_repository.dart';
import 'package:journeyplus/features/charging/presentation/controller/charging_controller.dart';
import 'package:journeyplus/features/charging/presentation/controller/charging_state.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.openChargeMapBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        // OCM docs: set a custom User-Agent so the API can identify legitimate clients.
        'User-Agent': 'JourneyPlus/1.0 (Flutter; EV charging app)',
      },
    ),
  );
});

final chargingLocalDbProvider = Provider<ChargingLocalDb>((ref) {
  final box = Hive.box(CacheConstants.chargingBoxName);
  return ChargingLocalDb(box);
});

final chargingRepositoryProvider = Provider<ChargingRepository>((ref) {
  return ChargingRepository(
    dio: ref.watch(dioProvider),
    localDb: ref.watch(chargingLocalDbProvider),
  );
});

final chargingControllerProvider =
    StateNotifierProvider<ChargingController, ChargingState>((ref) {
  return ChargingController(
    repository: ref.watch(chargingRepositoryProvider),
  );
});
