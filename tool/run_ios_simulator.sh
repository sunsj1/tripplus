#!/usr/bin/env bash
# Fixes: ArgumentError / objective_c.framework
#   "have 'iOS', need 'iOS-simulator'" / DOBJC_initializeApi
#
# Cause: Stale native assets (often after flutter build ipa/ios --release, or
# switching device → simulator) embed the wrong objective_c.framework slice.
# path_provider_foundation → objective_c (transitive via hive_flutter).
#
# Usage: ./tool/run_ios_simulator.sh
#        ./tool/run_ios_simulator.sh -d "iPhone 16"
set -euo pipefail
cd "$(dirname "$0")/.."

# CocoaPods can crash on paths with spaces if the shell locale is not UTF-8.
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

echo "→ flutter clean"
flutter clean

echo "→ remove CocoaPods artifacts (forces correct simulator/device slices)"
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks

echo "→ flutter pub get"
flutter pub get

echo "→ pod install"
(cd ios && pod install)

echo "→ flutter run (pass -d \"Device Name\" if needed)"
exec flutter run "$@"
