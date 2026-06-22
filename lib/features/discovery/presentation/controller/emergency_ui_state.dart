import 'package:journeyplus/core/domain/poi.dart';
import 'package:journeyplus/core/utils/failure.dart';
import 'package:journeyplus/features/discovery/domain/emergency_hotline.dart';
import 'package:journeyplus/features/discovery/domain/emergency_service_type.dart';
import 'package:journeyplus/features/pois/presentation/controller/poi_category_ui_state.dart';

/// One emergency help section (ambulance, RSA, crane, …) with fetched places.
class EmergencySectionData {
  const EmergencySectionData({
    required this.type,
    required this.pois,
    this.failure,
  });

  final EmergencyServiceType type;
  final List<Poi> pois;
  final Failure? failure;

  bool get hasError => failure != null;
}

sealed class EmergencyUiState {
  const EmergencyUiState();
}

class EmergencyLoading extends EmergencyUiState {
  const EmergencyLoading();
}

class EmergencyData extends EmergencyUiState {
  const EmergencyData({
    required this.contextLabel,
    required this.source,
    required this.hotlines,
    required this.sections,
  });

  final String contextLabel;
  final PoiQuerySource source;
  final List<EmergencyHotline> hotlines;
  final List<EmergencySectionData> sections;
}

class EmergencyErrored extends EmergencyUiState {
  const EmergencyErrored(this.failure);
  final Failure failure;
}
