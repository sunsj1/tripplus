import 'package:logger/logger.dart';

class CommunityTelemetry {
  CommunityTelemetry._();

  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  static void submitSuccess({required bool fromRetryQueue}) {
    _log.i('community.submit_success fromRetryQueue=$fromRetryQueue');
  }

  static void submitFailure({required String reasonCode}) {
    _log.w('community.submit_failure reason=$reasonCode');
  }

  static void retryBatch({required int attempted, required int pendingAfter}) {
    _log.i(
      'community.retry_batch attempted=$attempted pendingAfter=$pendingAfter',
    );
  }

  static void staleDataViewed({required bool lowConfidence, required int count}) {
    _log.i('community.view lowConfidence=$lowConfidence reportCount=$count');
  }

  static void conflictDetected() {
    _log.w('community.conflict_detected');
  }
}

