// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  bool get pureVeg => throw _privateConstructorUsedError;
  bool get familyMode => throw _privateConstructorUsedError;
  bool get womenSafe => throw _privateConstructorUsedError;
  BudgetTier get budgetTier => throw _privateConstructorUsedError;
  bool get fastChargersOnly => throw _privateConstructorUsedError;
  bool get petFriendly => throw _privateConstructorUsedError;
  bool get nightSafe => throw _privateConstructorUsedError;
  bool get scenicRoute => throw _privateConstructorUsedError;

  /// Selected fuel retailers for petrol/diesel trips (wire values from [FuelBrand]).
  List<String> get preferredFuelBrands => throw _privateConstructorUsedError;
  List<String> get dietaryFlags => throw _privateConstructorUsedError;

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
    UserPreferences value,
    $Res Function(UserPreferences) then,
  ) = _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call({
    bool pureVeg,
    bool familyMode,
    bool womenSafe,
    BudgetTier budgetTier,
    bool fastChargersOnly,
    bool petFriendly,
    bool nightSafe,
    bool scenicRoute,
    List<String> preferredFuelBrands,
    List<String> dietaryFlags,
  });
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pureVeg = null,
    Object? familyMode = null,
    Object? womenSafe = null,
    Object? budgetTier = null,
    Object? fastChargersOnly = null,
    Object? petFriendly = null,
    Object? nightSafe = null,
    Object? scenicRoute = null,
    Object? preferredFuelBrands = null,
    Object? dietaryFlags = null,
  }) {
    return _then(
      _value.copyWith(
            pureVeg: null == pureVeg
                ? _value.pureVeg
                : pureVeg // ignore: cast_nullable_to_non_nullable
                      as bool,
            familyMode: null == familyMode
                ? _value.familyMode
                : familyMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            womenSafe: null == womenSafe
                ? _value.womenSafe
                : womenSafe // ignore: cast_nullable_to_non_nullable
                      as bool,
            budgetTier: null == budgetTier
                ? _value.budgetTier
                : budgetTier // ignore: cast_nullable_to_non_nullable
                      as BudgetTier,
            fastChargersOnly: null == fastChargersOnly
                ? _value.fastChargersOnly
                : fastChargersOnly // ignore: cast_nullable_to_non_nullable
                      as bool,
            petFriendly: null == petFriendly
                ? _value.petFriendly
                : petFriendly // ignore: cast_nullable_to_non_nullable
                      as bool,
            nightSafe: null == nightSafe
                ? _value.nightSafe
                : nightSafe // ignore: cast_nullable_to_non_nullable
                      as bool,
            scenicRoute: null == scenicRoute
                ? _value.scenicRoute
                : scenicRoute // ignore: cast_nullable_to_non_nullable
                      as bool,
            preferredFuelBrands: null == preferredFuelBrands
                ? _value.preferredFuelBrands
                : preferredFuelBrands // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            dietaryFlags: null == dietaryFlags
                ? _value.dietaryFlags
                : dietaryFlags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(
    _$UserPreferencesImpl value,
    $Res Function(_$UserPreferencesImpl) then,
  ) = __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool pureVeg,
    bool familyMode,
    bool womenSafe,
    BudgetTier budgetTier,
    bool fastChargersOnly,
    bool petFriendly,
    bool nightSafe,
    bool scenicRoute,
    List<String> preferredFuelBrands,
    List<String> dietaryFlags,
  });
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
    _$UserPreferencesImpl _value,
    $Res Function(_$UserPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pureVeg = null,
    Object? familyMode = null,
    Object? womenSafe = null,
    Object? budgetTier = null,
    Object? fastChargersOnly = null,
    Object? petFriendly = null,
    Object? nightSafe = null,
    Object? scenicRoute = null,
    Object? preferredFuelBrands = null,
    Object? dietaryFlags = null,
  }) {
    return _then(
      _$UserPreferencesImpl(
        pureVeg: null == pureVeg
            ? _value.pureVeg
            : pureVeg // ignore: cast_nullable_to_non_nullable
                  as bool,
        familyMode: null == familyMode
            ? _value.familyMode
            : familyMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        womenSafe: null == womenSafe
            ? _value.womenSafe
            : womenSafe // ignore: cast_nullable_to_non_nullable
                  as bool,
        budgetTier: null == budgetTier
            ? _value.budgetTier
            : budgetTier // ignore: cast_nullable_to_non_nullable
                  as BudgetTier,
        fastChargersOnly: null == fastChargersOnly
            ? _value.fastChargersOnly
            : fastChargersOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
        petFriendly: null == petFriendly
            ? _value.petFriendly
            : petFriendly // ignore: cast_nullable_to_non_nullable
                  as bool,
        nightSafe: null == nightSafe
            ? _value.nightSafe
            : nightSafe // ignore: cast_nullable_to_non_nullable
                  as bool,
        scenicRoute: null == scenicRoute
            ? _value.scenicRoute
            : scenicRoute // ignore: cast_nullable_to_non_nullable
                  as bool,
        preferredFuelBrands: null == preferredFuelBrands
            ? _value._preferredFuelBrands
            : preferredFuelBrands // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        dietaryFlags: null == dietaryFlags
            ? _value._dietaryFlags
            : dietaryFlags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl extends _UserPreferences {
  const _$UserPreferencesImpl({
    this.pureVeg = false,
    this.familyMode = false,
    this.womenSafe = false,
    this.budgetTier = BudgetTier.mid,
    this.fastChargersOnly = false,
    this.petFriendly = false,
    this.nightSafe = false,
    this.scenicRoute = false,
    final List<String> preferredFuelBrands = const <String>[],
    final List<String> dietaryFlags = const <String>[],
  }) : _preferredFuelBrands = preferredFuelBrands,
       _dietaryFlags = dietaryFlags,
       super._();

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final bool pureVeg;
  @override
  @JsonKey()
  final bool familyMode;
  @override
  @JsonKey()
  final bool womenSafe;
  @override
  @JsonKey()
  final BudgetTier budgetTier;
  @override
  @JsonKey()
  final bool fastChargersOnly;
  @override
  @JsonKey()
  final bool petFriendly;
  @override
  @JsonKey()
  final bool nightSafe;
  @override
  @JsonKey()
  final bool scenicRoute;

  /// Selected fuel retailers for petrol/diesel trips (wire values from [FuelBrand]).
  final List<String> _preferredFuelBrands;

  /// Selected fuel retailers for petrol/diesel trips (wire values from [FuelBrand]).
  @override
  @JsonKey()
  List<String> get preferredFuelBrands {
    if (_preferredFuelBrands is EqualUnmodifiableListView)
      return _preferredFuelBrands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredFuelBrands);
  }

  final List<String> _dietaryFlags;
  @override
  @JsonKey()
  List<String> get dietaryFlags {
    if (_dietaryFlags is EqualUnmodifiableListView) return _dietaryFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryFlags);
  }

  @override
  String toString() {
    return 'UserPreferences(pureVeg: $pureVeg, familyMode: $familyMode, womenSafe: $womenSafe, budgetTier: $budgetTier, fastChargersOnly: $fastChargersOnly, petFriendly: $petFriendly, nightSafe: $nightSafe, scenicRoute: $scenicRoute, preferredFuelBrands: $preferredFuelBrands, dietaryFlags: $dietaryFlags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.pureVeg, pureVeg) || other.pureVeg == pureVeg) &&
            (identical(other.familyMode, familyMode) ||
                other.familyMode == familyMode) &&
            (identical(other.womenSafe, womenSafe) ||
                other.womenSafe == womenSafe) &&
            (identical(other.budgetTier, budgetTier) ||
                other.budgetTier == budgetTier) &&
            (identical(other.fastChargersOnly, fastChargersOnly) ||
                other.fastChargersOnly == fastChargersOnly) &&
            (identical(other.petFriendly, petFriendly) ||
                other.petFriendly == petFriendly) &&
            (identical(other.nightSafe, nightSafe) ||
                other.nightSafe == nightSafe) &&
            (identical(other.scenicRoute, scenicRoute) ||
                other.scenicRoute == scenicRoute) &&
            const DeepCollectionEquality().equals(
              other._preferredFuelBrands,
              _preferredFuelBrands,
            ) &&
            const DeepCollectionEquality().equals(
              other._dietaryFlags,
              _dietaryFlags,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pureVeg,
    familyMode,
    womenSafe,
    budgetTier,
    fastChargersOnly,
    petFriendly,
    nightSafe,
    scenicRoute,
    const DeepCollectionEquality().hash(_preferredFuelBrands),
    const DeepCollectionEquality().hash(_dietaryFlags),
  );

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(this);
  }
}

abstract class _UserPreferences extends UserPreferences {
  const factory _UserPreferences({
    final bool pureVeg,
    final bool familyMode,
    final bool womenSafe,
    final BudgetTier budgetTier,
    final bool fastChargersOnly,
    final bool petFriendly,
    final bool nightSafe,
    final bool scenicRoute,
    final List<String> preferredFuelBrands,
    final List<String> dietaryFlags,
  }) = _$UserPreferencesImpl;
  const _UserPreferences._() : super._();

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  bool get pureVeg;
  @override
  bool get familyMode;
  @override
  bool get womenSafe;
  @override
  BudgetTier get budgetTier;
  @override
  bool get fastChargersOnly;
  @override
  bool get petFriendly;
  @override
  bool get nightSafe;
  @override
  bool get scenicRoute;

  /// Selected fuel retailers for petrol/diesel trips (wire values from [FuelBrand]).
  @override
  List<String> get preferredFuelBrands;
  @override
  List<String> get dietaryFlags;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
