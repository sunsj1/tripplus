import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripplus/features/community/data/community_submit_queue.dart';
import 'package:tripplus/features/community/data/repository/community_report_repository.dart';
import 'package:tripplus/features/community/domain/models/station_community_ui_state.dart';
import 'package:tripplus/features/community/presentation/controller/station_community_controller.dart';

final communityReportRepositoryProvider =
    Provider<CommunityReportRepository>((ref) {
  return CommunityReportRepository();
});

final communitySubmitQueueProvider = Provider<CommunitySubmitQueue>((ref) {
  final box = Hive.box<dynamic>(CommunitySubmitQueue.boxName);
  return CommunitySubmitQueue(box);
});

/// Community feed + actions for one [stationKey] (see [communityStationKey]).
final stationCommunityControllerProvider = StateNotifierProvider.autoDispose
    .family<StationCommunityController, StationCommunityUiState, String>(
  (ref, stationKey) {
    final repo = ref.watch(communityReportRepositoryProvider);
    final queue = ref.watch(communitySubmitQueueProvider);
    return StationCommunityController(repo, queue, stationKey);
  },
);

/// Community feed + actions for any POI keyed by its `targetKey` (see
/// `communityPoiKey()` in `lib/features/pois/domain/community_poi_key.dart`).
/// New in `P1-052` — the POI-side counterpart to
/// [stationCommunityControllerProvider]. Reads via `watchByTargetKey` so old
/// station-only reports (written before `P1-010`) are correctly excluded; new
/// station writes (with mirrored `targetKey`) appear in both providers.
final poiCommunityControllerProvider = StateNotifierProvider.autoDispose
    .family<StationCommunityController, StationCommunityUiState, String>(
  (ref, targetKey) {
    final repo = ref.watch(communityReportRepositoryProvider);
    final queue = ref.watch(communitySubmitQueueProvider);
    return StationCommunityController(
      repo,
      queue,
      targetKey,
      queryByTargetKey: true,
    );
  },
);
