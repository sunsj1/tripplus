import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/features/pois/data/repository/poi_repository.dart';

/// Public seam for the POI feature.
///
/// Concrete [PoiRepository] is bound in `P1-008` when [GooglePlacesPoiSource]
/// lands. Until then any read here throws — that's intentional, so the scaffold
/// stays uncoupled from a half-built implementation.
final poiRepositoryProvider = Provider<PoiRepository>((ref) {
  throw UnimplementedError(
    'PoiRepository has no concrete binding yet. '
    'Wired in P1-008 (GooglePlacesPoiSource).',
  );
});
