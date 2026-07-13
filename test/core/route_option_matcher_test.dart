import 'package:flutter_test/flutter_test.dart';
import 'package:journeyplus/core/domain/route_option.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';
import 'package:journeyplus/core/utils/route_option_matcher.dart';

void main() {
  group('RouteOptionMatcher', () {
    test('picks route whose polyline is closest to GPS', () {
      const nearExpressway = LatLng(18.75, 73.45);
      const nearHighway = LatLng(18.55, 73.85);

      final expressway = RouteOption(
        id: '0',
        summary: 'Expressway',
        distanceKm: 149,
        durationMinutes: 158,
        encodedPolyline: '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
        polylinePoints: [
          const LatLng(19.0, 72.8),
          nearExpressway,
          const LatLng(18.5, 73.9),
        ],
      );
      final highway = RouteOption(
        id: '1',
        summary: 'NH 65',
        distanceKm: 155,
        durationMinutes: 165,
        encodedPolyline: 'abc',
        polylinePoints: [
          const LatLng(19.0, 72.8),
          nearHighway,
          const LatLng(18.5, 73.9),
        ],
      );

      final idx = RouteOptionMatcher.nearestIndexToPosition(
        nearExpressway,
        [expressway, highway],
      );

      expect(idx, 0);
      expect(
        RouteOptionMatcher.isOnRouteCorridor(expressway, nearExpressway),
        isTrue,
      );
    });
  });
}
