import 'package:fpdart/fpdart.dart';
import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/utils/failure.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart' show LatLng;

/// Source-agnostic contract for fetching POIs.
///
/// Concrete impls (Google Places, OCM, mocks for tests) live alongside this
/// file. The first concrete implementation lands in `P1-008`.
///
/// **Failure parity (P1-061).** Every method returns `Either<Failure, T>` and
/// must map underlying errors to one of the six canonical [Failure] variants:
///
/// | Cause                                         | Variant            |
/// |-----------------------------------------------|--------------------|
/// | offline / DNS / timeout / 5xx                 | `Failure.network`  |
/// | location-permission denied / API key missing  | `Failure.permission`|
/// | Firestore composite index still building      | `Failure.index`    |
/// | Firestore document / rules error              | `Failure.firestore`|
/// | native channel / platform exception           | `Failure.platform` |
/// | Places SDK billing or per-day quota exhausted | `Failure.quota`    |
///
/// Concrete implementations should NOT throw — they must translate exceptions
/// to the matching variant. Tests for `P1-008` should cover at least one
/// branch per variant.
abstract class PoiRepository {
  /// POIs along a route corridor — the core route-aware discovery surface.
  /// `corridorWidthKm` bounds the half-width of the search corridor.
  ///
  /// Expected failures: `network`, `permission`, `platform`, `quota`.
  Future<Either<Failure, List<Poi>>> searchAlongRoute({
    required List<LatLng> polyline,
    required PoiCategory category,
    double corridorWidthKm = 5,
  });

  /// Radial fallback for "what's near me" when there is no active route.
  ///
  /// Expected failures: `network`, `permission`, `platform`, `quota`.
  Future<Either<Failure, List<Poi>>> searchNearby({
    required double latitude,
    required double longitude,
    required PoiCategory category,
    double radiusKm = 5,
  });

  /// Keyword corridor search — used for emergency services (RSA, crane, etc.).
  Future<Either<Failure, List<Poi>>> searchAlongRouteKeyword({
    required List<LatLng> polyline,
    required String keyword,
    required PoiCategory displayCategory,
    double corridorWidthKm = 10,
  });

  /// Keyword radial fallback when there is no active route.
  Future<Either<Failure, List<Poi>>> searchNearbyKeyword({
    required double latitude,
    required double longitude,
    required String keyword,
    required PoiCategory displayCategory,
    double radiusKm = 15,
  });

  /// One-shot lookup by stable id (used by deep links + detail screens).
  ///
  /// Expected failures: `network`, `firestore`, `platform`.
  Future<Either<Failure, Poi>> getById(String id);
}
