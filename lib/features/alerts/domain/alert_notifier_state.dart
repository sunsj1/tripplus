import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:journeyplus/features/alerts/domain/alert.dart';

part 'alert_notifier_state.freezed.dart';

@freezed
abstract class AlertNotifierState with _$AlertNotifierState {
  const factory AlertNotifierState({
    /// Latest alert surfaced in the in-app banner (if not dismissed).
    Alert? activeBanner,
    @Default(false) bool bannerDismissed,
  }) = _AlertNotifierState;
}
