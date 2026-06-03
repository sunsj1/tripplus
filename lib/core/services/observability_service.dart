import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// P2-071 — Thin wrapper that attaches *context* to Crashlytics so crash
/// reports are actionable.
///
/// We expose three signals that any controller can call:
/// - [bindUser] — sets the Firebase user identifier on every report.
/// - [setVehicleType] / [setRouteMode] — custom keys for product context.
/// - [recordEvent] — a non-fatal breadcrumb (logged in debug, kept off the
///   wire for `release` to avoid polluting Crashlytics with info-level noise).
///
/// All calls are best-effort: any failure inside Crashlytics is swallowed
/// because observability must never crash the app.
class ObservabilityService {
  ObservabilityService();

  final _logger = Logger();
  final bool _enabled = !kDebugMode;

  bool get isEnabled => _enabled;

  Future<void> bindUser(String? userId) async {
    if (!_enabled) return;
    try {
      await FirebaseCrashlytics.instance
          .setUserIdentifier(userId ?? 'anonymous');
    } catch (e) {
      _logger.w('Crashlytics.setUserIdentifier failed: $e');
    }
  }

  Future<void> setVehicleType(String? type) async =>
      _setKey('vehicle_type', type ?? 'unset');

  Future<void> setRouteMode(String mode) async =>
      _setKey('route_mode', mode);

  Future<void> setActiveTrip(bool active) async =>
      _setKey('trip_active', active.toString());

  /// Non-fatal breadcrumb. `name` should be a stable identifier
  /// (snake_case) — keep details on the optional `data` map.
  Future<void> recordEvent(
    String name, {
    Map<String, String>? data,
  }) async {
    _logger.d('event: $name ${data ?? ''}');
    if (!_enabled) return;
    try {
      await FirebaseCrashlytics.instance.log(
        data == null || data.isEmpty
            ? name
            : '$name ${data.entries.map((e) => "${e.key}=${e.value}").join(" ")}',
      );
    } catch (e) {
      _logger.w('Crashlytics.log failed: $e');
    }
  }

  Future<void> _setKey(String key, String value) async {
    if (!_enabled) return;
    try {
      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    } catch (e) {
      _logger.w('Crashlytics.setCustomKey($key) failed: $e');
    }
  }
}
