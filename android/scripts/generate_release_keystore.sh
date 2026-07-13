#!/usr/bin/env bash
# Generates the JourneyPlus Android upload keystore and key.properties template.
# Run from repo root: ./android/scripts/generate_release_keystore.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ANDROID_DIR="${REPO_ROOT}/android"
KEYSTORE="${ANDROID_DIR}/journeyplus-release.keystore"
KEY_PROPS="${ANDROID_DIR}/key.properties"
EXAMPLE="${ANDROID_DIR}/key.properties.example"

if [[ -f "${KEYSTORE}" ]]; then
  echo "Keystore already exists: ${KEYSTORE}"
  echo "Delete it first if you intend to regenerate."
  exit 1
fi

if [[ -f "${KEY_PROPS}" ]]; then
  echo "key.properties already exists: ${KEY_PROPS}"
  exit 1
fi

echo "Creating upload keystore for com.journeyplus.journeyplus"
echo "You will be prompted for keystore and key passwords — store them securely."
echo ""

keytool -genkeypair -v \
  -keystore "${KEYSTORE}" \
  -alias journeyplus \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -dname "CN=JourneyPlus, OU=Mobile, O=JourneyPlus, L=India, ST=India, C=IN"

cp "${EXAMPLE}" "${KEY_PROPS}"
echo ""
echo "Edit ${KEY_PROPS} and replace YOUR_KEYSTORE_PASSWORD / YOUR_KEY_PASSWORD."
echo ""
echo "Print release certificate fingerprints (add to Firebase → Project settings → Android app):"
keytool -list -v -keystore "${KEYSTORE}" -alias journeyplus 2>/dev/null | grep -E 'SHA1:|SHA256:' || true
echo ""
echo "Next: flutter build appbundle --release"
