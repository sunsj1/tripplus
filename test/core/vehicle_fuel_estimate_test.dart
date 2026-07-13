import 'package:flutter_test/flutter_test.dart';
import 'package:journeyplus/core/domain/vehicle.dart';

/// Mirrors [PlanController] fuel estimate constants for regression checks.
const _petrolPricePerLitre = 103.0;
const _dieselPricePerLitre = 90.0;

double fuelCostFor({
  required Vehicle vehicle,
  required double distanceKm,
}) {
  if (!vehicle.burnsFuel) return 0;
  final kmpl = vehicle.effectiveFuelEfficiencyKmpl;
  final price = vehicle.type == VehicleType.diesel
      ? _dieselPricePerLitre
      : _petrolPricePerLitre;
  return (distanceKm / kmpl) * price;
}

void main() {
  group('Vehicle fuel estimates (H7-04)', () {
    const distanceKm = 150.0;

    test('bike fuel cost is much lower than petrol car on same route', () {
      final bike = fuelCostFor(
        vehicle: const Vehicle(type: VehicleType.bike),
        distanceKm: distanceKm,
      );
      final petrol = fuelCostFor(
        vehicle: const Vehicle(type: VehicleType.petrol),
        distanceKm: distanceKm,
      );

      expect(bike, lessThan(petrol * 0.35));
      expect(bike, greaterThan(0));
    });

    test('diesel and petrol differ with type-specific defaults', () {
      final petrol = fuelCostFor(
        vehicle: const Vehicle(type: VehicleType.petrol),
        distanceKm: distanceKm,
      );
      final diesel = fuelCostFor(
        vehicle: const Vehicle(type: VehicleType.diesel),
        distanceKm: distanceKm,
      );

      expect(petrol, isNot(equals(diesel)));
    });

    test('custom mileage overrides default', () {
      const custom = Vehicle(type: VehicleType.petrol, fuelEfficiencyKmpl: 20);
      const defaultCar = Vehicle(type: VehicleType.petrol);

      final customCost = fuelCostFor(vehicle: custom, distanceKm: distanceKm);
      final defaultCost =
          fuelCostFor(vehicle: defaultCar, distanceKm: distanceKm);

      expect(custom.effectiveFuelEfficiencyKmpl, 20);
      expect(defaultCar.effectiveFuelEfficiencyKmpl, 14);
      expect(customCost, lessThan(defaultCost));
    });
  });
}
