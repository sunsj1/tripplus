import 'package:tripplus/core/constants/api_constants.dart';
import 'package:tripplus/core/domain/poi.dart';

/// Builds Google Places Photo API URLs from [photo_reference] tokens returned
/// by Nearby Search / Place Details. Requires Places API (Photos) enabled.
class GooglePlacesPhoto {
  GooglePlacesPhoto._();

  static const _baseUrl = 'https://maps.googleapis.com/maps/api/place/photo';

  static String? urlForReference(
    String reference, {
    int maxWidth = 400,
  }) {
    if (!ApiConstants.isGoogleMapsKeyConfigured || reference.isEmpty) {
      return null;
    }
    return '$_baseUrl?maxwidth=$maxWidth'
        '&photo_reference=${Uri.encodeComponent(reference)}'
        '&key=${ApiConstants.googleMapsApiKey}';
  }
}

extension PoiPhotoX on Poi {
  /// Raw Google `place_id` when this POI came from Places (id prefix `g_`).
  String? get googlePlaceId {
    if (source != PoiSource.googlePlaces) return null;
    if (id.startsWith('g_')) return id.substring(2);
    return null;
  }

  String? get primaryPhotoReference =>
      photos.isNotEmpty ? photos.first : null;

  String? thumbnailUrl({int maxWidth = 200}) {
    final ref = primaryPhotoReference;
    return ref == null ? null : GooglePlacesPhoto.urlForReference(ref, maxWidth: maxWidth);
  }

  List<String> photoUrls({int maxWidth = 600, int limit = 5}) {
    return photos
        .take(limit)
        .map((r) => GooglePlacesPhoto.urlForReference(r, maxWidth: maxWidth))
        .whereType<String>()
        .toList();
  }

  List<String> get photoAttributions {
    final raw = attributes['photo_attributions'];
    if (raw is List) {
      return raw.whereType<String>().where((s) => s.isNotEmpty).toList();
    }
    return const [];
  }
}
