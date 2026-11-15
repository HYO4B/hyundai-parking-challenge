#!/usr/bin/env bash
set -euo pipefail

# Builds a signed, non-debuggable release candidate of the offline demo.
# The key and its password stay locally in private/ and must never be committed.
project_root="$(cd "$(dirname "$0")/.." && pwd)"
task_jdk="${SSADA_JDK:-${JAVA_HOME:-/Applications/Unity/Hub/Editor/6000.4.7f1/PlaybackEngines/AndroidPlayer/OpenJDK}}"
task_sdk="${SSADA_ANDROID_SDK:-${ANDROID_SDK_ROOT:-${ANDROID_HOME:-$HOME/Library/Android/sdk}}}"
task_build_tools="${SSADA_BUILD_TOOLS:-$task_sdk/build-tools/36.0.0}"
task_private="$project_root/private/release-signing"
task_keystore="$task_private/parking-release.p12"
task_password="$task_private/password.txt"
task_unsigned="$project_root/app/build/outputs/apk/release/app-release-unsigned.apk"
task_apk="$project_root/apk/김효섭_편한주차_release.apk"

for required in "$task_jdk/bin/java" "$task_jdk/bin/keytool" "$task_build_tools/apksigner"; do
  if [[ ! -x "$required" ]]; then printf 'Missing required tool: %s\n' "$required" >&2; exit 1; fi
done
command -v openssl >/dev/null || { echo 'Missing openssl' >&2; exit 1; }
umask 077
mkdir -p "$task_private" "$project_root/apk"
if [[ ! -e "$task_keystore" && ! -e "$task_password" ]]; then
  openssl rand -hex 32 > "$task_password"
  "$task_jdk/bin/keytool" -genkeypair -noprompt -storetype PKCS12 \
    -keystore "$task_keystore" -storepass:file "$task_password" \
    -keypass:file "$task_password" -alias parking-release -keyalg RSA \
    -keysize 3072 -validity 10000 -dname 'CN=Parking Release' >/dev/null 2>&1
elif [[ ! -f "$task_keystore" || ! -f "$task_password" ]]; then
  echo 'Signing key or password is missing. Restore both from the same backup.' >&2
  exit 1
fi

cd "$project_root"
JAVA_HOME="$task_jdk" ./gradlew :app:assembleRelease
JAVA_HOME="$task_jdk" "$task_build_tools/apksigner" sign --ks "$task_keystore" --ks-key-alias parking-release \
  --ks-pass "file:$task_password" \
  --out "$task_apk" "$task_unsigned"
JAVA_HOME="$task_jdk" "$task_build_tools/apksigner" verify --verbose "$task_apk"
printf '\nSigned release candidate: %s\n' "$task_apk"
