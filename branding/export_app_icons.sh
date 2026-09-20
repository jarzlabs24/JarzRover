#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MASTER="${SCRIPT_DIR}/source/jarzrover-app-icon-master.png"
ANDROID_RES="${REPO_ROOT}/android/robot/src/main/res"
IOS_APPICON="${REPO_ROOT}/ios/OpenBot/OpenBot/Assets.xcassets/AppIcon.appiconset"

if ! command -v sips >/dev/null 2>&1; then
  echo "error: this exporter currently requires macOS sips" >&2
  exit 1
fi

if [[ ! -f "${MASTER}" ]]; then
  echo "error: missing approved icon master: ${MASTER}" >&2
  exit 1
fi

resize_png() {
  local size="$1"
  local destination="$2"
  mkdir -p "$(dirname "${destination}")"
  sips --resampleHeightWidth "${size}" "${size}" "${MASTER}" --out "${destination}" >/dev/null
}

while read -r density size; do
  resize_png "${size}" "${ANDROID_RES}/mipmap-${density}/ic_launcher.png"
  resize_png "${size}" "${ANDROID_RES}/mipmap-${density}/ic_launcher_round.png"
done <<'SIZES'
mdpi 48
hdpi 72
xhdpi 96
xxhdpi 144
xxxhdpi 192
SIZES

# The native iOS asset catalog reuses filenames where idioms require the same
# pixel dimensions. Keep Contents.json stable and regenerate every referenced
# numbered file from the approved master.
for size in 16 20 29 32 40 48 50 55 57 58 60 64 72 76 80 87 88 100 114 120 128 144 152 167 172 180 196 216 256 512 1024; do
  resize_png "${size}" "${IOS_APPICON}/${size}.png"
done

echo "Exported JarzRover icons for Android robot and native iOS robot apps."
