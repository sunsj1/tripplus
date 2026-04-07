import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/features/community/data/repository/community_report_repository.dart';
import 'package:tripplus/features/community/domain/models/station_community_ui_state.dart';
import 'package:tripplus/features/community/presentation/controller/station_community_controller.dart';

final communityReportRepositoryProvider =
    Provider<CommunityReportRepository>((ref) {
  return CommunityReportRepository();
});

/// Community feed + actions for one [stationKey] (see [communityStationKey]).
final stationCommunityControllerProvider = StateNotifierProvider.autoDispose
    .family<StationCommunityController, StationCommunityUiState, String>(
  (ref, stationKey) {
    final repo = ref.watch(communityReportRepositoryProvider);
    return StationCommunityController(repo, stationKey);
  },
);
