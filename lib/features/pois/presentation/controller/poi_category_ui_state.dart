import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/utils/failure.dart';

part 'poi_category_ui_state.freezed.dart';

/// How the POIs were fetched, surfaced to the UI as a small badge so the
/// user understands the context of what they're seeing.
enum PoiQuerySource {
  /// Filtered to the active trip's corridor (the route-aware path).
  alongRoute,

  /// Radial search from the user's current location (no active trip).
  nearby,

  /// Active trip running; list filtered to POIs ahead of live GPS.
  aheadOnRoute,

  /// Active trip running but GPS/progress unavailable — full corridor shown
  /// with an explicit degraded badge (never silent “ahead”).
  waitingForGps,
}

extension PoiQuerySourceX on PoiQuerySource {
  String get label {
    switch (this) {
      case PoiQuerySource.alongRoute:
        return 'Along your route';
      case PoiQuerySource.nearby:
        return 'Near you';
      case PoiQuerySource.aheadOnRoute:
        return 'Ahead on your route';
      case PoiQuerySource.waitingForGps:
        return 'Waiting for GPS to filter ahead stops';
    }
  }

  IconData get icon {
    switch (this) {
      case PoiQuerySource.alongRoute:
        return Icons.route;
      case PoiQuerySource.nearby:
        return Icons.location_on;
      case PoiQuerySource.aheadOnRoute:
        return Icons.navigation_outlined;
      case PoiQuerySource.waitingForGps:
        return Icons.gps_not_fixed;
    }
  }
}

@freezed
sealed class PoiCategoryUiState with _$PoiCategoryUiState {
  const factory PoiCategoryUiState.loading() = PoiCategoryLoading;

  const factory PoiCategoryUiState.data({
    required List<Poi> pois,
    required PoiQuerySource source,
    /// P2-012 — driver's distance along the route when an active trip is
    /// running; null otherwise. Passed to [PoiRanker] for proximity scoring.
    double? currentPositionKm,
  }) = PoiCategoryData;

  /// Empty result. `reason` carries copy that's specific enough to be useful
  /// (e.g. "No fuel stations on this corridor — try a wider search" vs
  /// "Plan a trip to see chargers along it").
  const factory PoiCategoryUiState.empty({required String reason}) =
      PoiCategoryEmpty;

  const factory PoiCategoryUiState.errored(Failure failure) =
      PoiCategoryErrored;
}
