// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$UserPreferencesImpl(
  pureVeg: json['pureVeg'] as bool? ?? false,
  familyMode: json['familyMode'] as bool? ?? false,
  womenSafe: json['womenSafe'] as bool? ?? false,
  budgetTier:
      $enumDecodeNullable(_$BudgetTierEnumMap, json['budgetTier']) ??
      BudgetTier.mid,
  fastChargersOnly: json['fastChargersOnly'] as bool? ?? false,
  petFriendly: json['petFriendly'] as bool? ?? false,
  nightSafe: json['nightSafe'] as bool? ?? false,
  scenicRoute: json['scenicRoute'] as bool? ?? false,
  preferredFuelBrands:
      (json['preferredFuelBrands'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  dietaryFlags:
      (json['dietaryFlags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$$UserPreferencesImplToJson(
  _$UserPreferencesImpl instance,
) => <String, dynamic>{
  'pureVeg': instance.pureVeg,
  'familyMode': instance.familyMode,
  'womenSafe': instance.womenSafe,
  'budgetTier': _$BudgetTierEnumMap[instance.budgetTier]!,
  'fastChargersOnly': instance.fastChargersOnly,
  'petFriendly': instance.petFriendly,
  'nightSafe': instance.nightSafe,
  'scenicRoute': instance.scenicRoute,
  'preferredFuelBrands': instance.preferredFuelBrands,
  'dietaryFlags': instance.dietaryFlags,
};

const _$BudgetTierEnumMap = {
  BudgetTier.low: 'low',
  BudgetTier.mid: 'mid',
  BudgetTier.high: 'high',
};
