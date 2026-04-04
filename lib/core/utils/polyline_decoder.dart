class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}

/// Decodes a Google-encoded polyline string into a list of [LatLng] points.
/// Reference: https://developers.google.com/maps/documentation/utilities/polylinealgorithm
class PolylineDecoder {
  PolylineDecoder._();

  static List<LatLng> decode(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      lat += _decodeNext(encoded, index, (newIndex) => index = newIndex);
      lng += _decodeNext(encoded, index, (newIndex) => index = newIndex);
      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  static int _decodeNext(
      String encoded, int index, void Function(int) updateIndex) {
    int result = 0;
    int shift = 0;
    int byte;
    int currentIndex = index;

    do {
      byte = encoded.codeUnitAt(currentIndex++) - 63;
      result |= (byte & 0x1F) << shift;
      shift += 5;
    } while (byte >= 0x20);

    updateIndex(currentIndex);
    return (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
  }

  /// Samples [count] evenly-spaced points from the polyline,
  /// always including the first and last point.
  static List<LatLng> samplePoints(List<LatLng> polyline, int count) {
    if (polyline.length <= count) return polyline;
    if (count <= 2) return [polyline.first, polyline.last];

    final result = <LatLng>[polyline.first];
    final step = (polyline.length - 1) / (count - 1);

    for (int i = 1; i < count - 1; i++) {
      result.add(polyline[(step * i).round()]);
    }

    result.add(polyline.last);
    return result;
  }

  /// Generates a straight-line interpolation between [start] and [end]
  /// with [count] evenly-spaced points.
  static List<LatLng> interpolate(LatLng start, LatLng end, int count) {
    if (count <= 2) return [start, end];

    final points = <LatLng>[];
    for (int i = 0; i < count; i++) {
      final t = i / (count - 1);
      points.add(LatLng(
        start.latitude + (end.latitude - start.latitude) * t,
        start.longitude + (end.longitude - start.longitude) * t,
      ));
    }
    return points;
  }
}
