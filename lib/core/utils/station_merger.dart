import 'dart:math';

import 'package:journeyplus/features/charging/domain/models/charging_station.dart';

class StationMerger {
  StationMerger._();

  static const _duplicateThresholdKm = 0.15;

  static List<ChargingStation> mergeAndDeduplicate({
    required List<ChargingStation> ocmStations,
    required List<ChargingStation> googleStations,
  }) {
    final merged = <ChargingStation>[...ocmStations];
    final usedIndices = <int>{};

    for (final google in googleStations) {
      final dupIndex = _findDuplicate(google, merged);
      if (dupIndex != null && !usedIndices.contains(dupIndex)) {
        usedIndices.add(dupIndex);
        merged[dupIndex] = _enrichStation(merged[dupIndex], google);
      } else if (dupIndex == null) {
        merged.add(google);
      }
    }

    return merged;
  }

  static int? _findDuplicate(
      ChargingStation candidate, List<ChargingStation> existing) {
    for (int i = 0; i < existing.length; i++) {
      final dist = _haversine(
        candidate.latitude,
        candidate.longitude,
        existing[i].latitude,
        existing[i].longitude,
      );
      if (dist < _duplicateThresholdKm) return i;

      final nameSimilar = _nameSimilarity(candidate.name, existing[i].name);
      if (nameSimilar && dist < 1.0) return i;
    }
    return null;
  }

  static ChargingStation _enrichStation(
      ChargingStation primary, ChargingStation secondary) {
    return primary.copyWith(
      address: _pick(primary.address, secondary.address),
      operatorName: _pick(primary.operatorName, secondary.operatorName),
      isOperational: primary.isOperational ?? secondary.isOperational,
      generalComments: _mergeComments(
        primary.generalComments,
        secondary.generalComments,
      ),
    );
  }

  static String? _pick(String? a, String? b) =>
      (a != null && a.isNotEmpty) ? a : b;

  static String? _mergeComments(String? a, String? b) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return '$a | $b';
  }

  static bool _nameSimilarity(String a, String b) {
    final la = a.toLowerCase().trim();
    final lb = b.toLowerCase().trim();
    if (la == lb) return true;
    if (la.contains(lb) || lb.contains(la)) return true;

    final wordsA = la.split(RegExp(r'\s+')).toSet();
    final wordsB = lb.split(RegExp(r'\s+')).toSet();
    final intersection = wordsA.intersection(wordsB);
    final union = wordsA.union(wordsB);
    return union.isNotEmpty && intersection.length / union.length > 0.5;
  }

  static double _haversine(
      double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return 2 * r * asin(sqrt(a));
  }

  static double _rad(double deg) => deg * pi / 180;
}
