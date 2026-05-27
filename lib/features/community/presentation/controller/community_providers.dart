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
