import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Thin wrapper around [FlutterLocalNotificationsPlugin] for TripPlus alerts.
///
/// Initialized from [main] (`P1-027`). [AlertNotifier] (`P1-028`) calls
/// [showTripAlert] when the engine fires a new alert.
class LocalNotificationService {
  LocalNotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _androidChannelId = 'tripplus_alerts';
  static const _androidChannelName = 'Trip alerts';
  static const _androidChannelDescription =
      'Predictive highway alerts during an active trip';

  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// Platform setup — safe to call once at app start.
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _androidChannelId,
            _androidChannelName,
            description: _androidChannelDescription,
            importance: Importance.high,
          ),
        );

    _initialized = true;
  }

  /// Requests notification permission where the OS requires it (Android 13+,
  /// iOS). No-op on unsupported platforms.
  Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        final granted = await android.requestNotificationsPermission();
        if (granted == true) return true;
      }
      final status = await Permission.notification.request();
      return status.isGranted;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        final granted = await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    }

    return true;
  }

  /// Shows a high-priority local notification for a trip alert.
  Future<void> showTripAlert({
    required int notificationId,
    required String title,
    required String body,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      notificationId,
      title,
      body,
      const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Deep-link routing wired in P1-028 (AlertNotifier).
  }
}
