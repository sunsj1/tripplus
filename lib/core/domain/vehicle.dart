import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

enum VehicleType {
  @JsonValue('petrol')
  petrol,
  @JsonValue('diesel')
  diesel,
  @JsonValue('ev')
  ev,
  @JsonValue('bike')
  bike,
}

extension VehicleTypeX on VehicleType {
  String get label {
    switch (this) {
      case VehicleType.petrol:
        return 'Petrol';
      case VehicleType.diesel:
        return 'Diesel';
      case VehicleType.ev:
        return 'EV';
      case VehicleType.bike:
        return 'Bike';
    }
  }

  bool get isElectric => this == VehicleType.ev;
  bool get burnsFuel => !isElectric;
  bool get isBike => this == VehicleType.bike;
  bool get isCarClass => !isBike && !isElectric;

  /// Typical Indian highway average when the user has not set a custom value.
  double get defaultFuelEfficiencyKmpl {
    switch (this) {
      case VehicleType.bike:
        return 50.0;
      case VehicleType.petrol:
        return 14.0;
      case VehicleType.diesel:
        return 17.0;
      case VehicleType.ev:
        return 0;
    }
  }
}

@freezed
abstract class Vehicle with _$Vehicle {
  const Vehicle._();

  const factory Vehicle({
    required VehicleType type,
    String? nickname,
    double? fuelEfficiencyKmpl,
    double? batteryKwh,
    @Default(<String>[]) List<String> connectorTypes,
    @Default(false) bool fastChargeOnly,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  bool get isElectric => type.isElectric;
  bool get burnsFuel => type.burnsFuel;

  /// User override when set; otherwise a vehicle-type default (bike ≠ car).
  double get effectiveFuelEfficiencyKmpl =>
      fuelEfficiencyKmpl ?? type.defaultFuelEfficiencyKmpl;
}
