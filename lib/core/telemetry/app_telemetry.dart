import 'package:logger/logger.dart';
import 'package:tripplus/features/alerts/domain/alert.dart';
import 'package:tripplus/core/domain/poi.dart';

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

  static void alertBannerDismissed({required AlertType type}) {
    _log.i('alert.banner_dismissed type=${type.name}');
  }

  static void poiCategoryOpened({required PoiCategory category}) {
    _log.i('poi.category_opened category=${category.wireValue}');
  }

  static void alertHistoryOpened({required String tripId}) {
    _log.i('alert.history_opened tripId=$tripId');
  }
}
