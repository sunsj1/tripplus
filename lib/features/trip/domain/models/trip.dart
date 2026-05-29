import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/features/trip/domain/models/trip_status.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

/// A road trip derived from a completed plan.
///
/// Stored in the Hive `active_trip` box as JSON so it survives app restarts.
/// One document = one trip. The box holds at most one entry at a time.
@freezed
abstract class Trip with _$Trip {
  const Trip._();

  const factory Trip({
    /// Unique ID — UUID v4 generated at creation time.
    required String id,

    /// Human-readable origin label from the plan.
    required String from,

    /// Human-readable destination label from the plan.
    required String to,

    /// Vehicle used for this trip.
    required Vehicle vehicle,

    /// Lifecycle state.
    @Default(TripStatus.notStarted) TripStatus status,

    // --- Plan estimates (from P1-018) -----------------------------------------

    /// Total planned distance (km).
    required double totalDistanceKm,

    /// Driving-only duration from Google Directions (minutes).
    required int drivingMinutes,

    /// Total ETA including stop time (minutes). Null only if estimator failed.
    int? etaMinutes,

    /// Estimated toll cost (₹). Null for bikes.
    double? tollsEstimate,

    /// Estimated fuel or charging cost (₹).
    double? tripCostEstimate,

    /// Whether [tripCostEstimate] represents charging (true) or fuel (false).
    @Default(false) bool isCostCharging,

    /// Number of charging / fuel stations on the route.
    @Default(0) int stationCount,

    // --- Timeline -------------------------------------------------------------

    /// When the trip record was created.
    required DateTime createdAt,

    /// When the user tapped "Start trip".
    DateTime? startedAt,

    /// When the user last tapped "Pause".
    DateTime? pausedAt,

    /// When the user tapped "End trip".
    DateTime? completedAt,

    /// Cumulative milliseconds spent in paused state (for accurate elapsed).
    @Default(0) int elapsedPausedMs,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  // ---------------------------------------------------------------------------
  // Derived helpers
  // ---------------------------------------------------------------------------

  /// Whether the trip is currently tracking (active but not paused).
  bool get isTracking => status == TripStatus.active;

  /// Wall-clock elapsed time since start, excluding paused intervals.
  Duration get elapsed {
    if (startedAt == null) return Duration.zero;
    final now = completedAt ?? (status == TripStatus.paused ? pausedAt! : DateTime.now());
    return now.difference(startedAt!) - Duration(milliseconds: elapsedPausedMs);
  }
}
