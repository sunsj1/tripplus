import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/core/utils/trip_plan_copy.dart';
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
      (_) {/* keep local snapshot */},
      (data) {
        if (!mounted) return;
        state = ProfileUiState.idle(data);
      },
    );
  }

  void updateDraftVehicle(Vehicle vehicle) {
    if (!mounted) return;
    var prefs = state.data.preferences;
    if (!TripPlanCopy.isEv(vehicle.type) && prefs.fastChargersOnly) {
      prefs = prefs.copyWith(fastChargersOnly: false);
    }
    if (vehicle.type == VehicleType.ev || vehicle.type == VehicleType.bike) {
      prefs = prefs.copyWith(preferredFuelBrands: const []);
    }
    state = ProfileUiState.idle(
      state.data.copyWith(vehicle: vehicle, preferences: prefs),
    );
  }

  void updateDraftPreferences(UserPreferences preferences) {
    if (!mounted) return;
    final vehicle = state.data.vehicle;
    final prefs = vehicle != null && !TripPlanCopy.isEv(vehicle.type)
        ? preferences.copyWith(fastChargersOnly: false)
        : preferences;
    state = ProfileUiState.idle(state.data.copyWith(preferences: prefs));
  }

  Future<bool> save() async {
    if (!mounted) return false;
    final draft = state.data;
    if (draft.vehicle == null) return false;

    state = ProfileUiState.saving(draft);
    final result = await _repository.save(uid: _uid, data: draft);
    return result.match(
      (failure) {
        if (!mounted) return false;
        state = ProfileUiState.error(draft, failure);
        return false;
      },
      (saved) {
        if (!mounted) return false;
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
