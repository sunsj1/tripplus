import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/features/discovery/presentation/controller/emergency_controller.dart';
import 'package:journeyplus/features/discovery/presentation/controller/emergency_ui_state.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_providers.dart';
import 'package:journeyplus/features/plan/presentation/controller/plan_state.dart';
import 'package:journeyplus/features/pois/presentation/controller/pois_providers.dart';

final emergencyControllerProvider = StateNotifierProvider.autoDispose<
    EmergencyController, EmergencyUiState>((ref) {
  final planState = ref.read(planControllerProvider);
  String? from;
  String? to;
  if (planState is PlanResult) {
    from = planState.from;
    to = planState.to;
  }
  return EmergencyController(
    poiRepository: ref.watch(poiRepositoryProvider),
    geocoding: ref.watch(geocodingServiceProvider),
    directions: ref.watch(directionsServiceProvider),
    planFrom: from,
    planTo: to,
  );
});
