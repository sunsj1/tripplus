import 'package:hive/hive.dart';
import 'package:tripplus/core/domain/user_preferences.dart';
import 'package:tripplus/core/domain/vehicle.dart';
import 'package:tripplus/features/profile/domain/profile_data.dart';

/// Hive-backed local mirror of [ProfileData]. The box itself is opened in
/// `main.dart` at boot so reads stay synchronous.
class ProfileBox {
  ProfileBox(this._box);

  static const String boxName = 'user_profile';
  static const String _vehicleKey = 'vehicle';
  static const String _preferencesKey = 'preferences';

  final Box<dynamic> _box;

  ProfileData read() {
    final vehicleJson = _box.get(_vehicleKey);
    final prefsJson = _box.get(_preferencesKey);

    Vehicle? vehicle;
    if (vehicleJson is Map) {
      vehicle = Vehicle.fromJson(Map<String, dynamic>.from(vehicleJson));
    }

    UserPreferences prefs = const UserPreferences();
    if (prefsJson is Map) {
      prefs = UserPreferences.fromJson(Map<String, dynamic>.from(prefsJson));
    }

    return ProfileData(vehicle: vehicle, preferences: prefs);
  }

  Future<void> write(ProfileData data) async {
    await _box.put(_vehicleKey, data.vehicle?.toJson());
    await _box.put(_preferencesKey, data.preferences.toJson());
  }

  Future<void> clear() => _box.clear();
}
