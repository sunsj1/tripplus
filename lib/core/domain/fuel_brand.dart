import 'package:flutter/material.dart';

/// Major Indian highway fuel retailers (wire values stored in Firestore / Hive).
enum FuelBrand {
  bpcl,
  indianOil,
  hpcl,
  jioBp,
  nayara,
  shell,
}

extension FuelBrandX on FuelBrand {
  String get wireValue {
    switch (this) {
      case FuelBrand.bpcl:
        return 'bpcl';
      case FuelBrand.indianOil:
        return 'indian_oil';
      case FuelBrand.hpcl:
        return 'hpcl';
      case FuelBrand.jioBp:
        return 'jio_bp';
      case FuelBrand.nayara:
        return 'nayara';
      case FuelBrand.shell:
        return 'shell';
    }
  }

  String get label {
    switch (this) {
      case FuelBrand.bpcl:
        return 'BPCL';
      case FuelBrand.indianOil:
        return 'Indian Oil';
      case FuelBrand.hpcl:
        return 'HP';
      case FuelBrand.jioBp:
        return 'JIO-BP';
      case FuelBrand.nayara:
        return 'Nayara';
      case FuelBrand.shell:
        return 'Shell';
    }
  }

  /// Short mark shown inside the brand tile (not official logos — brand colors only).
  String get monogram {
    switch (this) {
      case FuelBrand.bpcl:
        return 'BP';
      case FuelBrand.indianOil:
        return 'IO';
      case FuelBrand.hpcl:
        return 'HP';
      case FuelBrand.jioBp:
        return 'JIO';
      case FuelBrand.nayara:
        return 'NY';
      case FuelBrand.shell:
        return '🐚';
    }
  }

  Color get primaryColor {
    switch (this) {
      case FuelBrand.bpcl:
        return const Color(0xFF006CB7);
      case FuelBrand.indianOil:
        return const Color(0xFFE85D04);
      case FuelBrand.hpcl:
        return const Color(0xFFD71920);
      case FuelBrand.jioBp:
        return const Color(0xFF003DA5);
      case FuelBrand.nayara:
        return const Color(0xFF5B2C83);
      case FuelBrand.shell:
        return const Color(0xFFDD1D21);
    }
  }

  Color get secondaryColor {
    switch (this) {
      case FuelBrand.bpcl:
        return const Color(0xFFFDB913);
      case FuelBrand.indianOil:
        return const Color(0xFF003DA5);
      case FuelBrand.hpcl:
        return const Color(0xFF003DA5);
      case FuelBrand.jioBp:
        return const Color(0xFF00A651);
      case FuelBrand.nayara:
        return const Color(0xFF00A651);
      case FuelBrand.shell:
        return const Color(0xFFFFCD00);
    }
  }

  LinearGradient get tileGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor, Color.lerp(primaryColor, secondaryColor, 0.45)!],
      );

  static FuelBrand? tryParse(String? wire) {
    if (wire == null || wire.isEmpty) return null;
    for (final b in FuelBrand.values) {
      if (b.wireValue == wire) return b;
    }
    return null;
  }

  static List<FuelBrand> fromWireList(List<String> wires) =>
      wires.map(tryParse).whereType<FuelBrand>().toList();
}
