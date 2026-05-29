import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// P1-044 — Connectivity stream provider.
///
/// Emits the current [List<ConnectivityResult>] whenever the device network
/// state changes. connectivity_plus v6 returns a list to support multi-homed
/// devices (e.g. WiFi + Cellular simultaneously).
final connectivityStreamProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Convenience provider: true if at least one active connection exists.
///
/// Defaults to [true] while the stream is loading so the UI doesn't flash
/// "offline" on startup before the first event arrives.
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStreamProvider).maybeWhen(
        data: (results) =>
            results.any((r) => r != ConnectivityResult.none),
        orElse: () => true, // optimistic default
      );
});
