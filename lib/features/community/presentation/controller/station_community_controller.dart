import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tripplus/features/community/data/community_telemetry.dart';
import 'package:tripplus/features/community/data/community_submit_queue.dart';
import 'package:tripplus/features/community/data/repository/community_report_repository.dart';
import 'package:tripplus/features/community/domain/models/station_community_report.dart';
import 'package:tripplus/features/community/domain/models/station_community_submit_input.dart';
import 'package:tripplus/features/community/domain/models/station_community_ui_state.dart';

class StationCommunityController extends StateNotifier<StationCommunityUiState> {
  StationCommunityController(this._repo, this._queue, this._stationKey)
      : super(const StationCommunityUiState()) {
    unawaited(_retryQueued());
    _sub = _repo.watchStationReports(_stationKey).listen(
      (either) {
        either.fold(
          (msg) => state = state.copyWith(loading: false, errorMessage: msg),
          (list) {
            final next = state.copyWith(
              loading: false,
              errorMessage: null,
              reports: list,
            );
            state = next;
            CommunityTelemetry.staleDataViewed(
              lowConfidence: next.lowConfidence,
              count: next.reports.length,
            );
            if (next.hasConflictInRecent) {
              CommunityTelemetry.conflictDetected();
            }
          },
        );
      },
      onError: (Object e, StackTrace _) {
        state = state.copyWith(loading: false, errorMessage: '$e');
      },
    );
  }

  final CommunityReportRepository _repo;
  final CommunitySubmitQueue _queue;
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
    await result.fold((msg) async {
      if (msg.startsWith('network:')) {
        await _queue.enqueue(input);
        CommunityTelemetry.submitFailure(reasonCode: 'network');
        state = state.copyWith(
          submitting: false,
          errorMessage: 'Saved offline. Auto retry will run shortly.',
        );
      } else {
        CommunityTelemetry.submitFailure(reasonCode: msg.split(':').first);
        state = state.copyWith(submitting: false, errorMessage: _mapError(msg));
      }
    }, (_) async {
      CommunityTelemetry.submitSuccess(fromRetryQueue: false);
      state = state.copyWith(submitting: false);
      unawaited(_retryQueued());
    });
    return result;
  }

  Future<void> _retryQueued() async {
    final pending = await _queue.loadAll();
    if (pending.isEmpty) return;

    final retained = <StationCommunitySubmitInput>[];
    var attempted = 0;
    for (final item in pending) {
      attempted++;
      final result = await _repo.submitReport(item);
      result.fold((err) {
        if (err.startsWith('network:')) {
          retained.add(item);
          CommunityTelemetry.submitFailure(reasonCode: 'network');
        }
      }, (_) {
        CommunityTelemetry.submitSuccess(fromRetryQueue: true);
      });
    }
    await _queue.replaceAll(retained);
    CommunityTelemetry.retryBatch(
      attempted: attempted,
      pendingAfter: retained.length,
    );
  }

  Future<void> retryPendingNow() => _retryQueued();

  String _mapError(String raw) {
    if (raw.startsWith('permission:')) {
      return 'Permission denied for report submission.';
    }
    if (raw.startsWith('index:')) {
      return 'Backend index is still provisioning. Please retry shortly.';
    }
    if (raw.startsWith('firestore:')) {
      return 'Could not submit right now. Please retry.';
    }
    if (raw.startsWith('platform:')) {
      return 'Device operation failed. Please retry.';
    }
    return raw.replaceFirst(RegExp(r'^[a-z]+:'), '');
  }
}
