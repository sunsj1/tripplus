import 'package:flutter_riverpod/flutter_riverpod.dart';

/// P2-051 — Pre-fill instruction for the Plan screen.
///
/// When a user taps "Plan again" on a historical trip we stash the
/// origin/destination labels here, switch to the Plan tab, and the Plan
/// screen consumes-and-clears the values on mount.
class TripReplanRequest {
  const TripReplanRequest({required this.from, required this.to});
  final String from;
  final String to;
}

final tripReplanRequestProvider = StateProvider<TripReplanRequest?>((_) => null);
