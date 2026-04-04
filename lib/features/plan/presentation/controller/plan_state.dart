import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/core/services/route_station_service.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';

part 'plan_state.freezed.dart';

@freezed
sealed class PlanState with _$PlanState {
  const factory PlanState.idle() = PlanIdle;
  const factory PlanState.calculating({
    required String from,
    required String to,
  }) = PlanCalculating;
  const factory PlanState.result({
    required String from,
    required String to,
    required List<ChargingStation> stations,
    required double totalDistanceKm,
    required int durationMinutes,
    @Default([]) List<ChargingGap> gaps,
  }) = PlanResult;
  const factory PlanState.empty({
    required String from,
    required String to,
  }) = PlanEmpty;
  const factory PlanState.error(String message) = PlanError;
}
