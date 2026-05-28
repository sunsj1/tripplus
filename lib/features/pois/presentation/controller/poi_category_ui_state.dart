import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/core/domain/poi.dart';
import 'package:tripplus/core/utils/failure.dart';

part 'poi_category_ui_state.freezed.dart';

/// How the POIs were fetched, surfaced to the UI as a small badge so the
/// user understands the context of what they're seeing.
enum PoiQuerySource {
  /// Filtered to the active trip's corridor (the route-aware path).
  alongRoute,

  /// Radial search from the user's current location (no active trip).
  nearby,
}

extension PoiQuerySourceX on PoiQuerySource {
  String get label {
    switch (this) {
      case PoiQuerySource.alongRoute:
        return 'Along your route';
      case PoiQuerySource.nearby:
        return 'Near you';
    }
  }
}

@freezed
sealed class PoiCategoryUiState with _$PoiCategoryUiState {
  const factory PoiCategoryUiState.loading() = PoiCategoryLoading;

  const factory PoiCategoryUiState.data({
    required List<Poi> pois,
    required PoiQuerySource source,
  }) = PoiCategoryData;

  /// Empty result. `reason` carries copy that's specific enough to be useful
  /// (e.g. "No fuel stations on this corridor — try a wider search" vs
  /// "Plan a trip to see chargers along it").
  const factory PoiCategoryUiState.empty({required String reason}) =
      PoiCategoryEmpty;

  const factory PoiCategoryUiState.errored(Failure failure) =
      PoiCategoryErrored;
}
