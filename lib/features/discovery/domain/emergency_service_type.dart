import 'package:flutter/material.dart';
import 'package:journeyplus/core/domain/poi.dart';

/// Emergency help categories surfaced on the Discover → Emergency screen.
enum EmergencyServiceType {
  ambulance,
  rsa,
  crane,
  police,
  hospital,
}

extension EmergencyServiceTypeX on EmergencyServiceType {
  String get title {
    switch (this) {
      case EmergencyServiceType.ambulance:
        return 'Ambulance';
      case EmergencyServiceType.rsa:
        return 'Roadside assistance (RSA)';
      case EmergencyServiceType.crane:
        return 'Crane & towing';
      case EmergencyServiceType.police:
        return 'Police';
      case EmergencyServiceType.hospital:
        return 'Hospitals & trauma care';
    }
  }

  String get subtitle {
    switch (this) {
      case EmergencyServiceType.ambulance:
        return 'Emergency medical transport near you or along your route';
      case EmergencyServiceType.rsa:
        return 'Breakdown help, flat tyre, battery jump-start, minor repairs';
      case EmergencyServiceType.crane:
        return 'Vehicle recovery after accident or breakdown';
      case EmergencyServiceType.police:
        return 'Nearest police stations for accident reporting';
      case EmergencyServiceType.hospital:
        return 'Emergency rooms and trauma centres';
    }
  }

  IconData get icon {
    switch (this) {
      case EmergencyServiceType.ambulance:
        return Icons.medical_services;
      case EmergencyServiceType.rsa:
        return Icons.car_repair;
      case EmergencyServiceType.crane:
        return Icons.construction;
      case EmergencyServiceType.police:
        return Icons.local_police;
      case EmergencyServiceType.hospital:
        return Icons.local_hospital;
    }
  }

  /// How this section is fetched from Google Places.
  bool get usesKeyword {
    switch (this) {
      case EmergencyServiceType.ambulance:
      case EmergencyServiceType.rsa:
      case EmergencyServiceType.crane:
        return true;
      case EmergencyServiceType.police:
      case EmergencyServiceType.hospital:
        return false;
    }
  }

  String? get keyword {
    switch (this) {
      case EmergencyServiceType.ambulance:
        return 'ambulance emergency';
      case EmergencyServiceType.rsa:
        return 'roadside assistance RSA tow';
      case EmergencyServiceType.crane:
        return 'crane towing recovery service';
      case EmergencyServiceType.police:
      case EmergencyServiceType.hospital:
        return null;
    }
  }

  PoiCategory get poiCategory {
    switch (this) {
      case EmergencyServiceType.ambulance:
        return PoiCategory.medical;
      case EmergencyServiceType.rsa:
        return PoiCategory.mechanic;
      case EmergencyServiceType.crane:
        return PoiCategory.mechanic;
      case EmergencyServiceType.police:
        return PoiCategory.police;
      case EmergencyServiceType.hospital:
        return PoiCategory.medical;
    }
  }
}
