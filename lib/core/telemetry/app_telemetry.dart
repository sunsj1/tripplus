import 'package:logger/logger.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';
import 'package:journeyplus/core/domain/poi.dart';

/// Lightweight structured logs for new Phase 1 flows (`P1-060`).
///
/// Mirrors [CommunityTelemetry] — no analytics SDK yet; grep-friendly lines.
class AppTelemetry {
  AppTelemetry._();

  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  static void tripPrepared({required String tripId}) {
    _log.i('trip.prepared tripId=$tripId');
  }

  static void tripStarted({required String tripId}) {
    _log.i('trip.started tripId=$tripId');
  }

  static void tripEnded({required String tripId, required int alertCount}) {
    _log.i('trip.ended tripId=$tripId alertCount=$alertCount');
  }

  static void alertFired({
    required AlertType type,
    required AlertSeverity severity,
  }) {
    _log.i('alert.fired type=${type.name} severity=${severity.name}');
  }

  static void alertFiredBackground({
    required AlertType type,
    required AlertSeverity severity,
  }) {
    _log.i(
      'alert.fired_background type=${type.name} severity=${severity.name}',
    );
  }

  static void alertEvalOk({required String trigger, required int alertCount}) {
    _log.i('alert.eval_ok trigger=$trigger alertCount=$alertCount');
  }

  static void alertEvalSkippedNoGps({required String trigger}) {
    _log.i('alert.eval_skipped_no_gps trigger=$trigger');
  }

  static void alertEvalSkipped({
    required String reason,
    required String trigger,
  }) {
    _log.i('alert.eval_skipped reason=$reason trigger=$trigger');
  }

  static void alertBannerDismissed({required AlertType type}) {
    _log.i('alert.banner_dismissed type=${type.name}');
  }

  static void alertNotificationOpened({
    required String tripId,
    required AlertType type,
  }) {
    _log.i('alert.notification_opened tripId=$tripId type=${type.name}');
  }

  static void poiCategoryOpened({required PoiCategory category}) {
    _log.i('poi.category_opened category=${category.wireValue}');
  }

  static void alertHistoryOpened({required String tripId}) {
    _log.i('alert.history_opened tripId=$tripId');
  }
}
