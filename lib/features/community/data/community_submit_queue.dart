import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripplus/features/community/domain/models/station_community_submit_input.dart';

class CommunitySubmitQueue {
  CommunitySubmitQueue(this._box);

  static const boxName = 'community_submit_queue';
  static const _key = 'pending_reports';

  final Box<dynamic> _box;

  Future<void> enqueue(StationCommunitySubmitInput input) async {
    final current = await loadAll();
    current.add(input);
    await _saveAll(current);
  }

  Future<List<StationCommunitySubmitInput>> loadAll() async {
    final raw = _box.get(_key);
    if (raw is! List) return <StationCommunitySubmitInput>[];
    final out = <StationCommunitySubmitInput>[];
    for (final item in raw) {
      if (item is String) {
        try {
          final map = jsonDecode(item);
          if (map is Map<String, dynamic>) {
            out.add(_fromMap(map));
          }
        } catch (_) {}
      }
    }
    return out;
  }

  Future<void> replaceAll(List<StationCommunitySubmitInput> entries) async {
    await _saveAll(entries);
  }

  Future<void> _saveAll(List<StationCommunitySubmitInput> entries) async {
    final raw = entries.map((e) => jsonEncode(_toMap(e))).toList();
    await _box.put(_key, raw);
  }

  static Map<String, dynamic> _toMap(StationCommunitySubmitInput i) {
    return {
      'stationKey': i.stationKey,
      'stationNameSnapshot': i.stationNameSnapshot,
      'reporterUserId': i.reporterUserId,
      'reporterDisplayName': i.reporterDisplayName,
      'rating': i.rating,
      'condition': i.condition,
      'availableAmenityLabels': i.availableAmenityLabels,
      'washroomAvailable': i.washroomAvailable,
      'washroomClean': i.washroomClean,
      'womenFriendlyWashroom': i.womenFriendlyWashroom,
      'photoBase64': i.photoBase64,
      'comment': i.comment,
      'costPerKwh': i.costPerKwh,
      'fastChargerAvailable': i.fastChargerAvailable,
      'chargeSuccessful': i.chargeSuccessful,
    };
  }

  static StationCommunitySubmitInput _fromMap(Map<String, dynamic> m) {
    final amenities = (m['availableAmenityLabels'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    return StationCommunitySubmitInput(
      stationKey: m['stationKey']?.toString() ?? '',
      stationNameSnapshot: m['stationNameSnapshot']?.toString() ?? '',
      reporterUserId: m['reporterUserId']?.toString() ?? '',
      reporterDisplayName: m['reporterDisplayName']?.toString(),
      rating: (m['rating'] as num?)?.toInt() ?? 3,
      condition: m['condition']?.toString() ?? 'working',
      availableAmenityLabels: amenities,
      washroomAvailable: m['washroomAvailable'] as bool?,
      washroomClean: m['washroomClean'] as bool?,
      womenFriendlyWashroom: m['womenFriendlyWashroom'] as bool?,
      photoBase64: m['photoBase64']?.toString(),
      comment: m['comment']?.toString(),
      costPerKwh: m['costPerKwh']?.toString(),
      fastChargerAvailable: m['fastChargerAvailable'] as bool? ?? false,
      chargeSuccessful: m['chargeSuccessful'] as bool?,
    );
  }
}

