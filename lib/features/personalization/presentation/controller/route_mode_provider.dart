import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journeyplus/features/personalization/domain/route_mode.dart';

/// P2-020 / P2-021 / P2-022 — Globally active [RouteMode].
///
/// Not autoDispose — the selected mode persists across tab switches and
/// category screen opens for the lifetime of the app session. (Persisting to
/// Hive across restarts can come later if telemetry shows users want sticky
/// modes; for now it resets on cold start, which is intentional safety.)
///
/// Default = [RouteMode.off]; profile preferences influence the *ranker*
/// weights but never silently engage a mode. Engaging Family/Women-Safe/Bike
/// hides results — that must always be a deliberate user action.
final routeModeProvider = StateProvider<RouteMode>((ref) => RouteMode.off);
