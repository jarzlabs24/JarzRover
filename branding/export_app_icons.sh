#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MASTER="${SCRIPT_DIR}/source/jarzrover-app-icon-master.png"
ANDROID_RES="${REPO_ROOT}/android/robot/src/main/res"
IOS_APPICON="${REPO_ROOT}/ios/OpenBot/OpenBot/Assets.xcassets/AppIcon.appiconset"
ANDROID_CONTROLLER_RES="${REPO_ROOT}/android/controller/src/main/res"
FLUTTER_ANDROID_RES="${REPO_ROOT}/controller/flutter/android/app/src/main/res"
FLUTTER_IOS_APPICON="${REPO_ROOT}/controller/flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset"

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
  resize_png "${size}" "${ANDROID_CONTROLLER_RES}/mipmap-${density}/ic_launcher.png"
  resize_png "${size}" "${ANDROID_CONTROLLER_RES}/mipmap-${density}/ic_launcher_round.png"
  resize_png "${size}" "${FLUTTER_ANDROID_RES}/mipmap-${density}/ic_launcher.png"
  resize_png "${size}" "${FLUTTER_ANDROID_RES}/mipmap-${density}/ic_launcher_round.png"
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

while read -r size filename; do
  resize_png "${size}" "${FLUTTER_IOS_APPICON}/${filename}"
done <<'FLUTTER_IOS_SIZES'
20 Icon-App-20x20@1x.png
40 Icon-App-20x20@2x.png
60 Icon-App-20x20@3x.png
29 Icon-App-29x29@1x.png
58 Icon-App-29x29@2x.png
87 Icon-App-29x29@3x.png
40 Icon-App-40x40@1x.png
80 Icon-App-40x40@2x.png
120 Icon-App-40x40@3x.png
120 Icon-App-60x60@2x.png
180 Icon-App-60x60@3x.png
76 Icon-App-76x76@1x.png
152 Icon-App-76x76@2x.png
167 Icon-App-83.5x83.5@2x.png
1024 Icon-App-1024x1024@1x.png
FLUTTER_IOS_SIZES

echo "Exported JarzRover icons for robot and controller apps."
