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

  /// P2 edge-case — active trip is running; list filtered to POIs strictly
  /// ahead of the driver's current GPS position. Only shows stops you can
  /// still reach, not ones you've already driven past.
  aheadOnRoute,
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
