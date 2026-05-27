import 'package:freezed_annotation/freezed_annotation.dart';

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
    String? preferredFuelBrand,
    @Default(<String>[]) List<String> dietaryFlags,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  /// Convenience: returns true if any India-first safety mode is enabled.
  bool get hasSafetyOverlay => familyMode || womenSafe || nightSafe;
}
