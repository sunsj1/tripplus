import 'package:journeyplus/core/domain/route_option.dart';
import 'package:journeyplus/core/utils/polyline_decoder.dart';

/// Pure parsers for Google route-alternative responses (unit-testable).
class DirectionsRouteParser {
  const DirectionsRouteParser._();

  /// Parses Google **Directions** API JSON (`alternatives=true`).
  static List<RouteOption> parseDirectionsAlternatives(
    Map<String, dynamic> data,
  ) {
    if (data['status'] != 'OK') return const [];

    final routes = data['routes'] as List?;
    if (routes == null || routes.isEmpty) return const [];

    final options = <RouteOption>[];
    for (var i = 0; i < routes.length; i++) {
      final route = routes[i] as Map<String, dynamic>;
      final legs = route['legs'] as List?;
      if (legs == null || legs.isEmpty) continue;

      final leg = legs.first as Map<String, dynamic>;
      final distanceMeters = (leg['distance'] as Map)['value'] as int;
      final durationSeconds = (leg['duration'] as Map)['value'] as int;
      final trafficValue =
          (leg['duration_in_traffic'] as Map<String, dynamic>?)?['value']
              as int?;
      final encoded =
          (route['overview_polyline'] as Map)['points'] as String;
      final summary = (route['summary'] as String?) ?? 'Route ${i + 1}';
      final warnings = route['warnings'] as List?;
      final hasTolls = warnings?.any(
            (w) => w.toString().toLowerCase().contains('toll'),
          ) ??
          false;

      options.add(
        RouteOption(
          id: '$i',
          summary: summary,
          distanceKm: distanceMeters / 1000.0,
          durationMinutes: (durationSeconds / 60).round(),
          durationInTrafficMinutes:
              trafficValue != null ? (trafficValue / 60).round() : null,
          encodedPolyline: encoded,
          polylinePoints: PolylineDecoder.decode(encoded),
          hasTolls: hasTolls,
        ),
      );
    }

    return markSuggested(options);
  }

  /// Parses Google **Routes API v2** `computeRoutes` JSON.
  static List<RouteOption> parseRoutesApiAlternatives(
    Map<String, dynamic> data,
  ) {
    final routes = data['routes'] as List?;
    if (routes == null || routes.isEmpty) return const [];

    final options = <RouteOption>[];
    for (var i = 0; i < routes.length; i++) {
      final route = routes[i] as Map<String, dynamic>;
      final distanceMeters =
          int.tryParse('${route['distanceMeters'] ?? 0}') ?? 0;
      final durationSeconds = _parseDurationSeconds(route['duration']);
      final staticSeconds = _parseDurationSeconds(route['staticDuration']);
      final encoded =
          (route['polyline'] as Map?)?['encodedPolyline'] as String? ?? '';
      if (encoded.isEmpty) continue;

      final summary = (route['description'] as String?) ?? 'Route ${i + 1}';
      final tollInfo = (route['travelAdvisory'] as Map?)?['tollInfo'];
      final hasTolls = tollInfo != null;

      final trafficMins = durationSeconds != null
          ? (durationSeconds / 60).round()
          : null;
      final freeFlowMins = staticSeconds != null
          ? (staticSeconds / 60).round()
          : (durationSeconds != null ? (durationSeconds / 60).round() : 0);

      options.add(
        RouteOption(
          id: '$i',
          summary: summary,
          distanceKm: distanceMeters / 1000.0,
          durationMinutes: freeFlowMins,
          durationInTrafficMinutes: trafficMins,
          encodedPolyline: encoded,
          polylinePoints: PolylineDecoder.decode(encoded),
          hasTolls: hasTolls,
        ),
      );
    }

    return markSuggested(options);
  }

  /// Marks the fastest traffic-aware alternative as [RouteOption.isSuggested].
  static List<RouteOption> markSuggested(List<RouteOption> routes) {
    if (routes.length <= 1) {
      return routes.isEmpty
          ? routes
          : [routes.first.copyWith(isSuggested: true)];
    }

    var bestIdx = 0;
    var bestMins = routes.first.effectiveDurationMinutes;
    for (var i = 1; i < routes.length; i++) {
      final mins = routes[i].effectiveDurationMinutes;
      if (mins < bestMins) {
        bestMins = mins;
        bestIdx = i;
      }
    }

    return [
      for (var i = 0; i < routes.length; i++)
        routes[i].copyWith(isSuggested: i == bestIdx),
    ];
  }

  static int? _parseDurationSeconds(Object? raw) {
    if (raw == null) return null;
    final text = raw.toString();
    if (text.endsWith('s')) {
      return int.tryParse(text.substring(0, text.length - 1));
    }
    return int.tryParse(text);
  }
}
