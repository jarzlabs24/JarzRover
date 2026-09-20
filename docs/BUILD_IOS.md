# Building the iOS apps on this Mac

Verified 2026-09-11 at source commit `f7f2b10` on `jarz-development`. Both apps built for a generic physical iOS device in Debug without signing. No source changes were necessary. Installation, launch, camera, networking and rover control remain untested.

## Environment

- Apple Silicon Mac, macOS 26.6.2
- Xcode 26.6 (17F113), installed at `/Applications/Xcode.app`
- Flutter stable 3.47.0, Dart 3.13.0
- Flutter SDK: `/Users/naturetracker/Applications/flutter`
- CocoaPods 1.17.0
- Flutter doctor passed iOS setup. Android SDK is missing; that does not prevent iOS builds.

## Native OpenBot robot app

From `ios/OpenBot`:

```sh
pod install --deployment
xcodebuild -workspace OpenBot.xcworkspace -scheme OpenBot -configuration Debug -destination 'generic/platform=iOS' -derivedDataPath /private/tmp/jarzrover-ios-build CODE_SIGNING_ALLOWED=NO build
```

The initial build failed because Pods/Manifest.lock was out of sync with Podfile.lock. Installing with `--deployment` synchronized local dependencies without changing tracked files. Retrying succeeded.

Output: `/private/tmp/jarzrover-ios-build/Build/Products/Debug-iphoneos/OpenBot.app`.

For Xcode use `ios/OpenBot/OpenBot.xcworkspace`, not the project alone. The existing app ID is `org.jarzlabs.openbot`; its app target already contains a development team. Verify that team is yours before signed deployment. Test targets have different legacy team settings.

CocoaPods reports conflicting simulator architecture exclusions among GoogleWebRTC/TensorFlowLite targets and dependency deprecations. This run validates physical-device compilation only, not simulator compatibility.

## Flutter controller app

From `controller/flutter`:

```sh
flutter doctor -v
flutter build ios --debug --no-codesign
```

Output: `controller/flutter/build/ios/iphoneos/Runner.app` (relative to repository).

For Xcode use `controller/flutter/ios/Runner.xcworkspace`. The current app ID is `com.openbot.openbotController`; development team is blank. Set the correct team and a team-owned app identifier before signed deployment, accounting for any registered app identity. Do not silently reuse the robot app ID for the controller.

Flutter reports that `nsd_ios` does not support Swift Package Manager; the current CocoaPods-backed build succeeds. `flutter analyze` reports 64 informational lint/deprecation findings and returns nonzero. `flutter test` cannot run because this app has no `test` directory. Neither outcome is a clean test-suite pass.

## Device testing next

Choose the intended iPhone and signing team, then build/install through the workspace or Flutter. Device installation was not performed in this run. Verify permission denial, launch, discovery and connection before motor tests. Read HARDWARE, WIRING and TEST_LOG before physical rover work. The native iOS README describes BLE rover transport; the existing Android USB/Nano arrangement is not proof of iOS connectivity.

These outputs are unsigned Debug apps, not App Store archives or submission-ready releases. Build caches under `/private/tmp` may be removed by the system; rerun the commands to recreate them.
