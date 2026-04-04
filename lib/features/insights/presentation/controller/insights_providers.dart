import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripplus/features/insights/presentation/controller/insights_controller.dart';
import 'package:tripplus/features/insights/presentation/controller/insights_state.dart';

final insightsControllerProvider =
    StateNotifierProvider<InsightsController, InsightsState>((ref) {
  return InsightsController();
});
