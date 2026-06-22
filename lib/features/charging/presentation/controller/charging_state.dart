import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';

part 'charging_state.freezed.dart';

@freezed
sealed class ChargingState with _$ChargingState {
  const factory ChargingState.initial() = ChargingInitial;
  const factory ChargingState.loading() = ChargingLoading;
  const factory ChargingState.loaded(List<ChargingStation> stations) =
      ChargingLoaded;
  const factory ChargingState.error(String message) = ChargingError;
}
