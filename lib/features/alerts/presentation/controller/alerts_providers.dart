import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/services/local_notification_service.dart';
import 'package:tripplus/features/alerts/domain/alert_engine.dart';

final alertEngineProvider = Provider<AlertEngine>((ref) => AlertEngine());

final localNotificationServiceProvider =
    Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});
