import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:journeyplus/core/domain/route_option.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/services/route_station_service.dart';
import 'package:journeyplus/features/charging/domain/models/charging_station.dart';

part 'plan_state.freezed.dart';

@freezed
sealed class PlanState with _$PlanState {
  const factory PlanState.idle() = PlanIdle;
  const factory PlanState.calculating({
    required String from,
    required String to,
    VehicleType? vehicleType,
  }) = PlanCalculating;
  const factory PlanState.result({
    required String from,
    required String to,
    required List<ChargingStation> stations,
    VehicleType? vehicleType,
    UserPreferences? tripPreferences,
    required double totalDistanceKm,
    required int durationMinutes,
    @Default([]) List<ChargingGap> gaps,
    // P1-018: cost / time picture ------------------------------------------------
    /// Total journey time including estimated charging/fuel stops (minutes).
    int? etaMinutes,
    /// Toll roads on route. Null for bikes; true/false for cars.
    bool? hasTolls,
    /// Estimated fuel cost (₹) using vehicle.fuelEfficiencyKmpl. Null for EVs.
    double? fuelEstimateCost,
    /// Estimated charging cost (₹) based on station count. Null for ICE vehicles.
    double? chargingEstimate,
    /// Brief weather descriptor e.g. "Clear", "Rainy". Null until weather API wired.
    String? weatherTag,
    /// Traffic descriptor derived from route duration: "Low" | "Moderate" | "High".
    String? trafficLevel,
    /// Google-encoded route polyline for corridor cache + alert engine (P1-028).
    String? encodedRoutePolyline,
    /// P2-042 — Matched toll corridor name when [hasTolls] is true.
    String? tollCorridorName,
    /// km/l used for the fuel estimate (profile override or vehicle default).
    double? fuelEfficiencyKmpl,
    /// Driving alternatives from Google (Batch 3).
    @Default(<RouteOption>[]) List<RouteOption> routeOptions,
    @Default(0) int selectedRouteIndex,
    @Default(false) bool isUpdatingRoute,
    /// Vehicle used for fuel estimates; preserved across route switches.
    Vehicle? vehicle,
    /// True when [selectedRouteIndex] was chosen via GPS corridor match.
    @Default(false) bool routeMatchedToGps,
    // ---------------------------------------------------------------------------
  }) = PlanResult;
  const factory PlanState.empty({
    required String from,
    required String to,
    VehicleType? vehicleType,
  }) = PlanEmpty;
  const factory PlanState.error(String message) = PlanError;
}
