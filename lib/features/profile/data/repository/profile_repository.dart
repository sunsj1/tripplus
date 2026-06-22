import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journeyplus/core/domain/user_preferences.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/utils/failure.dart';
import 'package:journeyplus/features/profile/data/local_db/profile_box.dart';
import 'package:journeyplus/features/profile/domain/profile_data.dart';

/// Persists [ProfileData] to Hive (instant) and mirrors to Firestore
/// `users/{uid}` (cross-device sync). Hive is treated as the source of truth
/// for in-app reads; Firestore is best-effort hydration.
class ProfileRepository {
  ProfileRepository({
    required ProfileBox box,
    FirebaseFirestore? firestore,
  })  : _box = box,
        _db = firestore ?? FirebaseFirestore.instance;

  final ProfileBox _box;
  final FirebaseFirestore _db;

  static const _vehicleField = 'vehicle';
  static const _preferencesField = 'preferences';

  ProfileData readLocal() => _box.read();

  /// Hydrate from Firestore on sign-in or app launch, writing the merged
  /// result back into Hive so subsequent reads stay sync. Falls back to
  /// existing Hive data when Firestore returns no doc.
  Future<Either<Failure, ProfileData>> hydrateFromFirestore(String uid) async {
    try {
      final snap = await _db.collection('users').doc(uid).get();
      final data = snap.data();
      final local = _box.read();
      if (data == null) {
        return right(local);
      }

      final remoteVehicle = _readVehicle(data[_vehicleField]);
      final merged = ProfileData(
        vehicle: remoteVehicle ?? local.vehicle,
        preferences:
            _readPreferences(data[_preferencesField]) ?? local.preferences,
        setupComplete: data['setupComplete'] == true ||
            remoteVehicle != null ||
            local.setupComplete,
      );

      await _box.write(merged);
      return right(merged);
    } on FirebaseException catch (e) {
      return left(_mapFirebase(e));
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message ?? e.code));
    } catch (e) {
      return left(Failure.platform(e.toString()));
    }
  }

  Future<Either<Failure, ProfileData>> save({
    required String uid,
    required ProfileData data,
  }) async {
    final toSave = data.vehicle != null
        ? data.copyWith(setupComplete: true)
        : data;
    try {
      await _box.write(toSave);
      await _db.collection('users').doc(uid).set(
        {
          _vehicleField: toSave.vehicle?.toJson(),
          _preferencesField: toSave.preferences.toJson(),
          'setupComplete': toSave.setupComplete,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return right(toSave);
    } on FirebaseException catch (e) {
      return left(_mapFirebase(e));
    } on PlatformException catch (e) {
      return left(Failure.platform(e.message ?? e.code));
    } catch (e) {
      return left(Failure.platform(e.toString()));
    }
  }

  Vehicle? _readVehicle(Object? raw) {
    if (raw is! Map) return null;
    try {
      return Vehicle.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  UserPreferences? _readPreferences(Object? raw) {
    if (raw is! Map) return null;
    try {
      return UserPreferences.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  Failure _mapFirebase(FirebaseException e) {
    final msg = e.message ?? e.code;
    switch (e.code) {
      case 'unavailable':
      case 'deadline-exceeded':
      case 'network-request-failed':
        return Failure.network(msg);
      case 'permission-denied':
        return Failure.permission(msg);
      case 'failed-precondition':
        return Failure.index(msg);
      case 'resource-exhausted':
        return Failure.quota(msg);
      default:
        return Failure.firestore(msg);
    }
  }
}
