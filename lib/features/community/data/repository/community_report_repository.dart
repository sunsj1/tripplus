import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tripplus/features/community/data/community_photo_compress.dart';
import 'package:tripplus/features/community/data/dto/station_community_report_dto.dart';
import 'package:tripplus/features/community/domain/models/station_community_report.dart';
import 'package:tripplus/features/community/domain/models/station_community_submit_input.dart';

class CommunityReportRepository {
  CommunityReportRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const _collection = 'stationCommunityReports';

  /// Live list for a station (newest first).
  ///
  /// Uses only `where('stationKey')` so **no composite index** is required.
  /// We sort by [StationCommunityReport.createdAt] in memory and keep the latest 50.
  /// (If a station ever has huge report volume, add a Firestore composite index
  /// and switch to server-side `orderBy` + `limit` to reduce reads — see
  /// [firebase/firestore.indexes.json].)
  Stream<Either<String, List<StationCommunityReport>>> watchStationReports(
    String stationKey,
  ) {
    return _db
        .collection(_collection)
        .where('stationKey', isEqualTo: stationKey)
        .snapshots()
        .map((snapshot) {
      try {
        final list = snapshot.docs
            .map(StationCommunityReportDto.fromDocument)
            .toList();
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (list.length > 50) {
          list.removeRange(50, list.length);
        }
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
