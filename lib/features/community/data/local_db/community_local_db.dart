import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tripplus/features/community/domain/models/community_report.dart';

class CommunityLocalDb {
  final Box _box;

  static const boxName = 'community_reports';

  CommunityLocalDb(this._box);

  Future<void> saveReport(CommunityReport report) async {
    final key = report.stationId;
    final existing = getReports(key);
    existing.add(report);
    if (existing.length > 20) {
      existing.removeRange(0, existing.length - 20);
    }
    final jsonList = existing.map((r) => jsonEncode(r.toJson())).toList();
    await _box.put(key, jsonList);
  }

  List<CommunityReport> getReports(String stationId) {
    final raw = _box.get(stationId) as List?;
    if (raw == null) return [];
    return raw
        .cast<String>()
        .map((s) => CommunityReport.fromJson(jsonDecode(s)))
        .toList();
  }

  CommunityReport? getLatestReport(String stationId) {
    final reports = getReports(stationId);
    if (reports.isEmpty) return null;
    reports.sort((a, b) => b.reportedAtMs.compareTo(a.reportedAtMs));
    return reports.first;
  }
}
