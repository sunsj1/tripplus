import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journeyplus/features/community/data/community_photo_compress.dart';
import 'package:journeyplus/features/community/data/dto/station_community_report_dto.dart';
import 'package:journeyplus/features/community/domain/models/station_community_report.dart';
import 'package:journeyplus/features/community/domain/models/station_community_submit_input.dart';

class CommunityReportRepository {
  CommunityReportRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const _collection = 'stationCommunityReports';

  /// Live list for a station (newest first).
  ///
  /// P2-072 — Uses the deployed `stationKey + createdAt desc` composite index
  /// for server-side ordering + `limit(50)`. Eliminates client-side sort and
  /// caps read cost: a station with 1k reports now costs 50 reads, not 1000.
  Stream<Either<String, List<StationCommunityReport>>> watchStationReports(
    String stationKey,
  ) {
    return _db
        .collection(_collection)
        .where('stationKey', isEqualTo: stationKey)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      try {
        final list = snapshot.docs
            .map(StationCommunityReportDto.fromDocument)
            .toList();
        return right<String, List<StationCommunityReport>>(list);
      } catch (e) {
        return left<String, List<StationCommunityReport>>('$e');
      }
    });
  }

  /// Live list for ANY target (`P1-051`). Works for both station and POI
  /// pulses because `targetKey` is mirrored from `stationKey` on station
  /// writes (see [StationCommunityReportDto.toCreateMap]).
  ///
  /// Old reports created before `P1-010` only have `stationKey`. For those,
  /// callers should keep using [watchStationReports] — this query won't see
  /// them. New writes (post-`P1-010`) appear here.
  ///
  /// P2-072 — Uses the `targetKey + createdAt desc` composite index for
  /// server-side ordering + limit; same payoff as [watchStationReports].
  Stream<Either<String, List<StationCommunityReport>>> watchByTargetKey(
    String targetKey,
  ) {
    return _db
        .collection(_collection)
        .where('targetKey', isEqualTo: targetKey)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      try {
        final list = snapshot.docs
            .map(StationCommunityReportDto.fromDocument)
            .toList();
        return right<String, List<StationCommunityReport>>(list);
      } catch (e) {
        return left<String, List<StationCommunityReport>>('$e');
      }
    });
  }

  Future<Either<String, Unit>> submitReport(
    StationCommunitySubmitInput input,
  ) async {
    try {
      if (input.rating < 1 || input.rating > 5) {
        return left('Rating must be between 1 and 5.');
      }
      if (input.photoBase64 != null) {
        final approx = (input.photoBase64!.length * 3) ~/ 4;
        if (approx > maxStoredJpegBytes) {
          return left(
            'Photo is still too large after compression. Try another image.',
          );
        }
      }
      await _db.collection(_collection).add(
            StationCommunityReportDto.toCreateMap(input),
          );
      return right(unit);
    } catch (e) {
      if (e is FirebaseException) {
        final msg = e.message ?? e.code;
        if (e.code == 'unavailable' ||
            e.code == 'network-request-failed' ||
            e.code == 'deadline-exceeded') {
          return left('network:$msg');
        }
        if (e.code == 'permission-denied') {
          return left('permission:$msg');
        }
        if (e.code == 'failed-precondition') {
          return left('index:$msg');
        }
        return left('firestore:$msg');
      }
      if (e is PlatformException) {
        return left('platform:${e.message ?? e.code}');
      }
      return left('unknown:$e');
    }
  }
}
