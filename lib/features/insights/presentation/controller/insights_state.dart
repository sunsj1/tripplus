import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:journeyplus/core/services/route_station_service.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';

part 'insights_state.freezed.dart';

@freezed
class InsightsData with _$InsightsData {
  const factory InsightsData({
    // Route overview
    @Default('') String from,
    @Default('') String to,
    @Default(0) double routeDistanceKm,
    @Default(0) int durationMinutes,
    @Default(0) int totalStations,

    // Route health (0-100)
    @Default(0) int healthScore,
    @Default('') String healthLabel,

    // Metrics
    @Default(0) double avgSpacingKm,
    @Default(0) int chargingStopsNeeded,
    @Default(0) double estimatedChargingCostRupees,
    @Default(0) int estimatedChargingMinutes,

    // Station quality
    @Default(0) int fastChargerCount,
    @Default(0) int verifiedCount,
    @Default(0) double avgPowerKw,
    @Default(0) int fastChargerPercent,

    // Gap analysis
    @Default(0) double maxGapKm,
    @Default([]) List<ChargingGap> gaps,

    // Top stations for quick reference
    @Default([]) List<ChargingStation> topStations,
  }) = _InsightsData;
}

@freezed
sealed class InsightsState with _$InsightsState {
  const factory InsightsState.initial() = InsightsInitial;
  const factory InsightsState.loading() = InsightsLoading;
  const factory InsightsState.loaded(InsightsData data) = InsightsLoaded;
  const factory InsightsState.error(String message) = InsightsError;
}
