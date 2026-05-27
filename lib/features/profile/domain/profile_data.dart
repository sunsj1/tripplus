import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';

part 'profile_data.freezed.dart';
part 'profile_data.g.dart';

/// Bundles the trip-relevant slice of a user's profile: their vehicle and
/// their preference flags. Stored in Hive (`user_profile` box) and mirrored
/// to Firestore `users/{uid}` under the `vehicle` and `preferences` fields.
///
/// `vehicle` is nullable so we can express the "post-onboarding, not yet
/// configured" state — which gates the AppShell.
@freezed
abstract class ProfileData with _$ProfileData {
  const ProfileData._();

  const factory ProfileData({
    Vehicle? vehicle,
    @Default(UserPreferences()) UserPreferences preferences,
  }) = _ProfileData;

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  /// True once the user has picked at least their vehicle. The setup gate
  /// uses this to decide between [ProfileSetupScreen] and [AppShell].
  bool get isVehicleSetupComplete => vehicle != null;
}
