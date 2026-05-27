import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/core/utils/failure.dart';
import 'package:tripplus/features/profile/domain/profile_data.dart';

part 'profile_ui_state.freezed.dart';

/// UI state for the profile setup + edit screens.
/// `data` is always the latest known snapshot — never null, so the UI can
/// render even while saving / erroring.
@freezed
sealed class ProfileUiState with _$ProfileUiState {
  const factory ProfileUiState.idle(ProfileData data) = ProfileIdle;
  const factory ProfileUiState.saving(ProfileData data) = ProfileSaving;
  const factory ProfileUiState.error(ProfileData data, Failure failure) =
      ProfileErrored;
}
