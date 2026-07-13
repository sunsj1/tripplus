import 'package:flutter_test/flutter_test.dart';
import 'package:journeyplus/core/domain/route_option.dart';
import 'package:journeyplus/core/services/directions_route_parser.dart';

void main() {
  group('DirectionsRouteParser', () {
    test('parseDirectionsAlternatives returns 2 routes with suggested flag', () {
      final data = {
        'status': 'OK',
        'routes': [
          {
            'summary': 'Mumbai - Pune Expy',
            'warnings': ['This route has tolls.'],
            'overview_polyline': {'points': '_p~iF~ps|U_ulLnnqC_mqNvxq`@'},
            'legs': [
              {
                'distance': {'value': 149000},
                'duration': {'value': 9600},
                'duration_in_traffic': {'value': 9480},
              },
            ],
          },
          {
            'summary': 'NH 48',
            'overview_polyline': {'points': '_p~iF~ps|U_ulLnnqC_mqNvxq`@'},
            'legs': [
              {
                'distance': {'value': 155000},
                'duration': {'value': 10200},
                'duration_in_traffic': {'value': 9900},
              },
            ],
          },
        ],
      };

      final options = DirectionsRouteParser.parseDirectionsAlternatives(data);

      expect(options.length, 2);
      expect(options.first.summary, 'Mumbai - Pune Expy');
      expect(options.first.hasTolls, isTrue);
      expect(options[1].hasTolls, isFalse);
      expect(options.where((r) => r.isSuggested).length, 1);
      expect(options.first.isSuggested, isTrue);
      expect(options.first.effectiveDurationMinutes, 158);
    });

    test('parseRoutesApiAlternatives parses toll flag and marks suggested', () {
      final data = {
        'routes': [
          {
            'description': 'via Mumbai - Pune Expy',
            'distanceMeters': '149000',
            'duration': '9480s',
            'staticDuration': '9000s',
            'polyline': {
              'encodedPolyline': '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
            },
            'travelAdvisory': {
              'tollInfo': {},
            },
          },
          {
            'description': 'via NH 65',
            'distanceMeters': '152000',
            'duration': '9900s',
            'staticDuration': '9600s',
            'polyline': {
              'encodedPolyline': '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
            },
          },
        ],
      };

      final options = DirectionsRouteParser.parseRoutesApiAlternatives(data);

      expect(options.length, 2);
      expect(options.first.hasTolls, isTrue);
      expect(options[1].hasTolls, isFalse);
      expect(options.first.isSuggested, isTrue);
      expect(options.first.distanceKm, closeTo(149, 0.1));
    });

    test('markSuggested picks lowest traffic-aware duration', () {
      final marked = DirectionsRouteParser.markSuggested([
        const RouteOption(
          id: '0',
          summary: 'Slow',
          distanceKm: 100,
          durationMinutes: 120,
          durationInTrafficMinutes: 150,
          encodedPolyline: 'abc',
        ),
        const RouteOption(
          id: '1',
          summary: 'Fast',
          distanceKm: 110,
          durationMinutes: 100,
          durationInTrafficMinutes: 130,
          encodedPolyline: 'def',
        ),
      ]);

      expect(marked[1].isSuggested, isTrue);
      expect(marked[0].isSuggested, isFalse);
    });
  });
}
