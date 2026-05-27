import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/features/profile/data/repository/profile_repository.dart';
import 'package:tripplus/features/profile/domain/profile_data.dart';
import 'package:tripplus/features/profile/presentation/controller/profile_ui_state.dart';

class ProfileController extends StateNotifier<ProfileUiState> {
  ProfileController({
    required ProfileRepository repository,
    required String uid,
  })  : _repository = repository,
        _uid = uid,
        super(ProfileUiState.idle(repository.readLocal())) {
    _bootstrap();
  }

  final ProfileRepository _repository;
  final String _uid;

  Future<void> _bootstrap() async {
    final result = await _repository.hydrateFromFirestore(_uid);
    result.match(
      (_) {/* network/firestore error on hydrate: keep local snapshot */},
      (data) => state = ProfileUiState.idle(data),
    );
  }

  void updateDraftVehicle(Vehicle vehicle) {
    state = ProfileUiState.idle(state.data.copyWith(vehicle: vehicle));
  }

  void updateDraftPreferences(UserPreferences preferences) {
    state = ProfileUiState.idle(state.data.copyWith(preferences: preferences));
  }

  Future<bool> save() async {
    final draft = state.data;
    state = ProfileUiState.saving(draft);
    final result = await _repository.save(uid: _uid, data: draft);
    return result.match(
      (failure) {
        state = ProfileUiState.error(draft, failure);
        return false;
      },
      (saved) {
        state = ProfileUiState.idle(saved);
        return true;
      },
    );
  }
}

extension ProfileUiStateX on ProfileUiState {
  ProfileData get data => switch (this) {
        ProfileIdle(:final data) => data,
        ProfileSaving(:final data) => data,
        ProfileErrored(:final data) => data,
      };
}
