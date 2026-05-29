import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tripplus/core/domain/fuel_brand.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

enum BudgetTier {
  @JsonValue('low')
  low,
  @JsonValue('mid')
  mid,
  @JsonValue('high')
  high,
}

extension BudgetTierX on BudgetTier {
  String get label {
    switch (this) {
      case BudgetTier.low:
        return 'Budget';
      case BudgetTier.mid:
        return 'Standard';
      case BudgetTier.high:
        return 'Premium';
    }
  }
}

@freezed
abstract class UserPreferences with _$UserPreferences {
  const UserPreferences._();

  const factory UserPreferences({
    @Default(false) bool pureVeg,
    @Default(false) bool familyMode,
    @Default(false) bool womenSafe,
    @Default(BudgetTier.mid) BudgetTier budgetTier,
    @Default(false) bool fastChargersOnly,
    @Default(false) bool petFriendly,
    @Default(false) bool nightSafe,
    @Default(false) bool scenicRoute,
    /// Selected fuel retailers for petrol/diesel trips (wire values from [FuelBrand]).
    @Default(<String>[]) List<String> preferredFuelBrands,
    @Default(<String>[]) List<String> dietaryFlags,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(migrateUserPreferencesJson(json));

  /// Legacy Firestore/Hive docs may still carry singular [preferredFuelBrand].
  static Map<String, dynamic> migrateUserPreferencesJson(
    Map<String, dynamic> json,
  ) {
    final map = Map<String, dynamic>.from(json);
    if (!map.containsKey('preferredFuelBrands') &&
        map['preferredFuelBrand'] is String &&
        (map['preferredFuelBrand'] as String).isNotEmpty) {
      map['preferredFuelBrands'] = [map['preferredFuelBrand']];
    }
    return map;
  }

  /// Convenience: returns true if any India-first safety mode is enabled.
  bool get hasSafetyOverlay => familyMode || womenSafe || nightSafe;
}

extension UserPreferencesFuelX on UserPreferences {
  List<FuelBrand> get selectedFuelBrands =>
      FuelBrandX.fromWireList(preferredFuelBrands);

  UserPreferences toggleFuelBrand(FuelBrand brand) {
    final wire = brand.wireValue;
    final next = List<String>.from(preferredFuelBrands);
    if (next.contains(wire)) {
      next.remove(wire);
    } else {
      next.add(wire);
    }
    return copyWith(preferredFuelBrands: next);
  }
}
