import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/utils/location_helper.dart';
import 'package:tripplus/features/charging/data/repository/charging_repository.dart';
import 'package:tripplus/features/charging/presentation/controller/charging_state.dart';

class ChargingController extends StateNotifier<ChargingState> {
  final ChargingRepository _repository;
  final _logger = Logger();

  ChargingController({required ChargingRepository repository})
      : _repository = repository,
        super(const ChargingState.initial());

  Future<void> loadStations() async {
    state = const ChargingState.loading();

    try {
      final position = await LocationHelper.getCurrentLocation();
      _logger.i(
        'Location: ${position.latitude}, ${position.longitude}',
      );

      final result = await _repository.getChargingStations(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      result.when(
        success: (stations) {
          state = ChargingState.loaded(stations);
        },
        failure: (message) {
          state = ChargingState.error(message);
        },
      );
    } on LocationException catch (e) {
      _logger.w('Location error: ${e.message}');
      state = ChargingState.error(e.message);
    } catch (e) {
      _logger.e('Unexpected error: $e');
      state = const ChargingState.error('Something went wrong.');
    }
  }
}
