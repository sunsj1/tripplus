import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/utils/trip_plan_copy.dart';

/// One preference row on the route timeline with corridor POI data.
class PreferenceCorridorInsight {
  const PreferenceCorridorInsight({
    required this.item,
    required this.suggestedKmFromStart,
    required this.pois,
    this.corridorLoaded = true,
  });

  final PreferenceTimelineItem item;

  /// Evenly spaced planning marker along route length — not a verified stop.
  final double suggestedKmFromStart;
  final List<Poi> pois;
  final bool corridorLoaded;

  int get count => pois.length;

  String get milestoneLabel =>
      'Planning marker · ~${suggestedKmFromStart.round()} km from start';

  String get countLabel => corridorLoaded
      ? '$count along corridor'
      : 'Corridor search unavailable';
}
