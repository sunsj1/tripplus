import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tripplus/features/community/data/repository/community_report_repository.dart';
import 'package:tripplus/features/community/domain/models/station_community_report.dart';
import 'package:tripplus/features/community/domain/models/station_community_submit_input.dart';
import 'package:tripplus/features/community/domain/models/station_community_ui_state.dart';

class StationCommunityController extends StateNotifier<StationCommunityUiState> {
  StationCommunityController(this._repo, this._stationKey)
      : super(const StationCommunityUiState()) {
    _sub = _repo.watchStationReports(_stationKey).listen(
      (either) {
        either.fold(
          (msg) => state = state.copyWith(loading: false, errorMessage: msg),
          (list) => state = state.copyWith(
            loading: false,
            errorMessage: null,
            reports: list,
          ),
        );
      },
      onError: (Object e, StackTrace _) {
        state = state.copyWith(loading: false, errorMessage: '$e');
      },
    );
  }

  final CommunityReportRepository _repo;
  final String _stationKey;
  late final StreamSubscription<Either<String, List<StationCommunityReport>>>
      _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future<Either<String, Unit>> submit(StationCommunitySubmitInput input) async {
    state = state.copyWith(submitting: true, errorMessage: null);
    final result = await _repo.submitReport(input);
    result.fold(
      (msg) => state = state.copyWith(submitting: false, errorMessage: msg),
      (_) => state = state.copyWith(submitting: false),
    );
    return result;
  }
}
