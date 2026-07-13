import 'package:freezed_annotation/freezed_annotation.dart';
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
    /// Estimated toll cost for the route (₹). Null for bikes.
    double? tollsEstimate,
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
    /// P2-042 — Matched toll corridor name (e.g. "Mumbai–Pune Expressway").
    /// Null when the estimate comes from Google or no tolls were found.
    String? tollCorridorName,
    /// True when no tolls were detected on the route (non-bike only).
    @Default(false) bool noTollsOnRoute,
    /// km/l used for the fuel estimate (profile override or vehicle default).
    double? fuelEfficiencyKmpl,
    // ---------------------------------------------------------------------------
  }) = PlanResult;
  const factory PlanState.empty({
    required String from,
    required String to,
    VehicleType? vehicleType,
  }) = PlanEmpty;
  const factory PlanState.error(String message) = PlanError;
}
