#!/usr/bin/env bash
# Fixes: ArgumentError / objective_c.framework "have 'iOS', need 'iOS-simulator'"
# That happens when a *device* build's native assets are reused on the simulator.
set -euo pipefail
cd "$(dirname "$0")/.."
echo "flutter clean (drops device-only native assets like objective_c)…"
flutter clean
flutter pub get
echo "Starting on iOS Simulator — pass -d \"Device Name\" if needed."
exec flutter run "$@"
