# JarzRover test log

## Historical baseline

Recorded on 2026-09-04 from the user's JarZLabs handoff. Original test dates, firmware revisions, measurements, and detailed procedures were not supplied. These are user-reported completed tests, not tests rerun during this documentation work.

| Test / observation | Reported outcome | Limits / current status |
| --- | --- | --- |
| Direct wiring without breadboard | Robot successfully operated | Exact as-built schematic not recorded |
| Left motor test | Completed successfully | Speed, load, and procedure not recorded |
| Right motor test | Completed successfully | Speed, load, and procedure not recorded |
| HC-SR04 serial readings | Eventually worked | Fix, sketch, accuracy, and range were not recorded in the original handoff; later integrated readings were reported working |
| Android USB OTG power to Nano | Nano powered from phone | Full robot still requires proper battery power |

## Documentation verification — 2026-09-04

Inspected `firmware/openbot/openbot.ino` at commit `5d7e4ce`: `OPENBOT DIY`, `MCU NANO`, and all pin assignments in [HARDWARE.md](HARDWARE.md) match the source. Sonar, front speed sensors, indicators, voltage-divider sensing, and OLED are disabled in the DIY block. No firmware was changed and no physical robot tests were run for this setup.

This paragraph is a historical snapshot of commit `5d7e4ce`. The current working source later enabled sonar and front speed sensors; see the Android motor-direction and handoff entries below.

## Current development status

OpenBot object navigation / green-ball behavior is the active focus. End-to-end detection, centering, approach, stopping, and target-loss behavior have no recorded acceptance result in the supplied history. Standalone sonar success must not be treated as proof of integrated obstacle handling.

Creature Lab's computer-camera flow is under active development in `tools/creature-lab`. Code-level build results should be recorded below; camera interaction and the complete visitor flow remain unverified until they are tested in a browser with a real object.

## Creature Lab build verification — 2026-09-05

- Added local creature details: generated name, type, description, and special ability derived from the captured image's sampled colors.
- `npm run build`: pass.
- Focused `oxlint` check for `app/page.tsx` and `app/api/generate/route.ts`: pass.
- Local development route at `http://localhost:3000/`: HTTP 200.
- Full-project `npm run lint`: fail because of 19 existing findings in generated `components/ui/*` and `hooks/use-mobile.ts` files; no reported finding was in the Creature Lab page or generation route changed for this step.
- Real camera capture, retake, local transformation, result display, and timing: not run by Codex; requires user interaction in the browser.

## Creature Lab recognition refinement — 2026-09-05

- User verified that real AI image generation and AI creature abilities work.
- User observed that some photos prioritize people instead of the intended object and that the camera background appears blurred.
- Capture was changed to send only the centered square guide area rather than the entire camera frame.
- Object-analysis image detail was raised to high, and both AI prompts now explicitly exclude people and body parts as possible subjects.
- The apparent live-camera blur is not applied by Creature Lab capture code; check macOS camera Video Effects / Portrait mode during browser testing.

## Creature Lab art direction — 2026-09-05

- User reported that the initial AI artwork did not match the intended creature-collecting illustration aesthetic.
- The image prompt now specifies original retro anime creature art using hand-inked variable linework, simple rounded silhouettes, expressive geometric eyes, muted watercolor-like color, restrained cel shadows, and a warm paper-wash presentation.
- The prompt explicitly excludes photorealism, 3D rendering, copied characters, and named-artist imitation.
- Visual output from the revised prompt remains to be tested with a new user-approved camera image.

## Creature Lab morphology refinement — 2026-09-05

- User observed that generated creatures overused an upright two-arm, two-leg, ears-and-tail body plan.
- Reference examples were reviewed for high-level morphology only: limbless, quadruped, and radial/floating silhouettes. No reference character is supplied to the generation API or requested for imitation.
- Object analysis now chooses an explicit body plan and two to four source-specific defining features before image generation.
- The image prompt receives that design decision and prohibits replacing it with a generic upright mascot.
- Revised morphology output remains to be tested with new user-approved camera images.

## Creature Lab abstraction refinement — 2026-09-05

- User tested a screwdriver and observed that the result remained essentially a screwdriver with a face.
- The design rule is now "creature first, object inspiration second": reinterpret two or three source traits and invent the remaining creature anatomy.
- Prompts now reject preserving the entire object outline, recommend purposeful locomotion appendages, and tell the model to translate tool functions into distributed features such as claws, horns, arms, armor, markings, or abilities.
- Revised abstraction remains to be tested with another user-approved screwdriver generation.

## Creature Lab rendering-style refinement — 2026-09-05

- User confirmed that the object-to-creature concept now looks good but reported excessive watercolor treatment and an inaccurate rendering style.
- New references were reviewed for high-level rendering characteristics only: clean controlled outlines, flat base colors, minimal cel shading, small highlights, and white backgrounds.
- The prompt now explicitly excludes watercolor washes, paper texture, brush or pencil grain, painterly rendering, heavy gradients, photorealism, and 3D surfaces.
- Revised rendering style remains to be tested with a new user-approved generation.

## Creature Patrol state-machine scaffold — 2026-09-05

- Added a hardware-independent Android state machine for patrol, stable object confirmation, capture, generation, result display, and object removal.
- Motion is permitted only in the `PATROLLING` state; no motor-control code is connected in this scaffold.
- Added unit coverage for motion gating, unstable detections, stable removal, and invalid transitions.
- `./gradlew :robot:testDebugUnitTest --tests org.openbot.creature.CreaturePatrolStateMachineTest`: pass on 2026-09-05.
- Physical rover behavior, camera capture, network upload, and object-zone detection were not run or changed in this step.

Next checks should establish installed hardware and flashed firmware, then verify green-ball behavior incrementally. Record actual observations rather than marking planned checks as passed.

## Future entry template

- Date and tester:
- Goal / behavior tested:
- Firmware or app revision and feature flags:
- Hardware, wiring, and power configuration:
- Procedure and expected result:
- Actual result / measurements:
- Outcome: pass, fail, partial, or not run:
- Hardware-impacting changes and follow-up:

## Merge-readiness verification — 2026-09-07

- Reviewed jarz-development 52b43ee against local master 87a9d17 and fetched origin/master b5e555a. Origin development was already current. Original firmware and native iOS bundle-ID edits were stashed, restored, and verified unchanged; backup stash retained.
- Android robot debug build and all nine unit tests passed using local cached dependencies. APK contains ignored local networks/ball_labels.txt; that file is not committed or downloaded, so this does not establish fresh-checkout detector readiness.
- Flutter analysis: 64 informational findings, no warnings/errors. Flutter tests unavailable (no test directory). Unsigned Flutter iOS release build passed. nsd_ios produced a Swift Package Manager support warning.
- No physical robot tests, device pairing, app signing, store submission, or merge performed. Ball safety/target-loss behavior remains unverified and has code-level blockers.
- Read-only merge preview found an iOS Podfile deployment-target conflict with origin/master (15.0 versus 14.0).
- Detailed review was recorded in the other Mac's local Codex project context. Temporary build logs were stored under `/tmp/jarz-*`; they were not committed.

- Native OpenBot unsigned iOS Debug device build: PASS with Xcode 26.3, using a fresh /tmp/jarz-native-ios-review derived-data directory and existing Pods. No simulator tests or signed device install performed.

## Native iOS Creature Lab build checkpoint — 2026-09-12

- Added the native Creature Lab camera, photo review, server request, and generated-creature result flow to the OpenBot iOS app.
- `plutil -lint ios/OpenBot/OpenBot.xcodeproj/project.pbxproj`: pass.
- `git diff --check`: pass.
- Direct Swift type-check of `CreatureLabViewController.swift` against the installed iOS Simulator SDK: pass.
- Xcode Debug build using the OpenBot workspace, OpenBot scheme, and `Any iOS Device (arm64)`: pass (`Build Succeeded` at 10:41 AM).
- Simulator link: fail because the existing GoogleWebRTC 1.1.32000 framework is built for the iOS device platform rather than the iOS Simulator platform. This is a pre-existing dependency limitation, not a Creature Lab Swift compile failure.
- Not run: installation on a physical iPhone, camera capture, local-network connection, API generation, or rover hardware behavior.
- Hardware impact: none in this change; motor, Bluetooth, wiring, and firmware behavior were not modified.
- After the first physical-device installation, opening Creature Lab terminated the app. Inspection found `AVCaptureSession.startRunning()` was called before `commitConfiguration()`, an invalid AVFoundation camera-session sequence.
- Corrected the sequence to commit the camera configuration before starting the session. Swift type-check, project plist validation, and `git diff --check` pass after the correction.
- The corrected build was installed and launched on the project test iPhone through Xcode. Reopening Creature Lab and testing capture/generation remain user-device checks.
- Physical iPhone verification: pass. Creature Lab opened without crashing, captured a photo, reached the Mac-hosted server at `http://192.168.251.244:3000`, and returned an AI-generated creature result.
- This verification used the iPhone and Mac on the same local network with the development server running; rover mounting, motor behavior, autonomous detection, and Maker Faire network reliability remain untested.

## Native iOS stationary discovery prototype — 2026-09-12

- Added a visible center discovery zone, empty-arena calibration, low-resolution on-device scene comparison, stable-object confirmation, and a user approval prompt before photo capture.
- Detection sends no camera frames to the server and issues no motor commands. Generation still starts only after the visitor approves a captured photo and taps Create Creature.
- Direct Swift type-check against the installed iPhone SDK, project plist validation, and `git diff --check`: pass.
- Incremental Xcode build, installation, and launch on the project test iPhone: pass.
- Physical calibration sensitivity, stable-object prompt timing, false positives, capture framing, and generation from the discovery flow: not yet tested.
- Physical orientation test reported that the UIKit discovery guide rotated in landscape while the AVFoundation preview remained sideways.
- Added explicit interface-orientation updates for the camera preview and photo-output connection. Direct Swift type-check and incremental iPhone build/install: pass; corrected landscape preview and saved-photo orientation await user verification.
- First physical detector test: calibration completed, but a cricket ball in the discovery zone did not trigger the prompt. Local detection does not depend on the Mac server.
- Increased the fingerprint grid from 10×8 to 20×15, reduced the changed-area threshold for smaller objects, and added a live scene-change percentage for tuning. Direct Swift type-check and incremental iPhone installation: pass; physical retest remains pending.

## Native iOS rover-link investigation — 2026-09-12

- User-reported physical test: Robot Info showed no connected vehicle sensors, and its manual forward/reverse commands produced no motor movement.
- The recorded rover hardware is an ATmega328p Arduino Nano using the `OPENBOT DIY` firmware path. That path receives phone commands through USB serial and does not enable the firmware's built-in BLE server.
- The native iOS robot app communicates solely through the OpenBot BLE service/characteristic UUIDs. Its current UI sets the global connected flag when a peripheral connects, before verifying writable/notifiable characteristics or receiving the firmware-ready message, so a connected icon alone does not prove a usable robot link.
- User confirmed the rover has only the Lafvin/ATmega328p Arduino Nano connected by USB, with no ESP32 or separate BLE module.
- Outcome: fail / architecture mismatch confirmed. The current native iOS app cannot use this Nano USB link for robot commands or telemetry. No motor pins, wiring, firmware, or BLE code were changed during this investigation.

## Android ball-detector asset-path verification — 2026-09-12

- Corrected `DetectorYoloV5` to load the tracked `networks/colored_balls.txt` asset rather than the ignored, local-only `networks/ball_labels.txt` copy. Both files contained the same blue/green/red labels on this Mac.
- `./gradlew :robot:assembleDebug :robot:testDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 22 seconds; 47 tasks, 10 executed and 37 up-to-date).
- This verifies compilation, APK packaging, and unit tests using the tracked asset path. Physical ball detection, centering, approach, target-loss stopping, and rover motion were not run.

## Android Creature Lab manual-flow checkpoint — 2026-09-12

- Added a Creature Lab tile to the Android robot app without replacing or modifying the existing Object Tracking / colored-ball mode.
- Added an in-app rear-camera capture flow that rotates and center-crops the camera frame to a 1024×1024 image, plus photo review, retake, local server address persistence, generation progress, and creature result/profile display.
- The Android app sends the captured image only to the existing Mac-hosted `/api/generate` route. No OpenAI API key is stored in the APK or sent directly to OpenAI by the phone.
- Creature Lab consumes no controller commands and issues no motor commands in this milestone; the rover remains stationary while using it.
- Final `./gradlew :robot:assembleDebug :robot:testDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 14 seconds; 47 tasks, 13 executed and 34 up-to-date).
- APK inspection: pass. `robot-debug.apk` includes `colored_ball_yolov5.tflite`, `colored_balls.txt`, and the Creature Lab layout.
- `git diff --check`: pass.
- Android SDK `adb` was found in the other Mac's user SDK directory. The debug APK installed successfully on the connected Pixel 7 and `org.openbot/.main.MainActivity` launched and remained running in the foreground.
- The Mac-hosted Creature Lab returned HTTP 200 at `http://localhost:3000`; the Mac Wi-Fi address was `192.168.251.244` at this checkpoint.
- Physical Android camera capture, landscape orientation, same-network generation, Nano USB connection, colored-ball behavior, and rover motion: not run. The Pixel was showing its system shade during the automated UI-label check and requires user interaction for the feature tests.
- First physical Android Creature Lab test: generation completed successfully, but the square result image was cropped by the full-screen `centerCrop` presentation. Changed the photo/result view to `fitCenter` on a white background so the complete square creature image is visible on portrait and landscape displays.
- Cropping fix verification: full Android build and unit tests passed (`BUILD SUCCESSFUL` in 3 seconds), and the updated APK installed successfully and launched on the connected Pixel 7. Visual confirmation of a newly generated result remains a user-device check.
- Second physical result-layout observation: `fitCenter` centered the full image, but the overlaid creature-description card still covered part of it. The image is now constrained to end above the description card; the server panel and Create button are hidden on the completed-result screen to provide additional image space.
- Separated-layout verification: full Android build and unit tests passed (`BUILD SUCCESSFUL` in 9 seconds), and the updated APK installed successfully and launched on the Pixel 7. Physical visual confirmation remains pending.

## Android stationary discovery checkpoint — 2026-09-12

- Added a visible centered yellow discovery zone, **Learn empty area**, and **Watch for object** controls to Android Creature Lab.
- Ported the tuned iPhone scene-change approach: a 20×15 color fingerprint, ten-frame empty-area baseline, small-object change threshold, and seven stable comparison frames before prompting.
- Detection runs locally on sampled camera pixels. It does not upload watching frames, call the AI service, or send any motor commands.
- Added an object-discovered confirmation dialog; a photo is captured only after the visitor taps **Take photo**.
- Creature Lab now keeps the Android screen awake while its view is open, including calibration, watching, capture review, and generation.
- Added unit coverage for baseline learning, stable-object recognition, and ignoring very small scene changes.
- `./gradlew :robot:assembleDebug :robot:testDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 16 seconds; 47 tasks, 14 executed and 33 up-to-date).
- Updated APK installation and launch on the connected Pixel 7: pass. Physical calibration sensitivity, object prompt timing, false positives, and landscape layout remain to be tested.
- Physical landscape observation: the yellow discovery zone appeared too high and pointed above the arena. Added an orientation-aware vertical bias that moves the guide lower in landscape while preserving its centered portrait position; rebuild and device retest follow.
- Landscape-zone build verification: Android build and unit tests passed (`BUILD SUCCESSFUL` in 7 seconds), and the updated APK installed successfully and was delivered to the running OpenBot activity on the Pixel 7. Physical alignment with the arena remains pending.
- Second physical landscape observation: the guide remained too high because its 48%-screen height left little room for vertical bias. In landscape, the guide is now 30% of screen height and bottom-aligned above the controls. The detector's sampled camera region was also moved from the centered 20–80% band to the lower 50–90% band so visual guidance and detection remain aligned.
- Lower-region verification: Android build and unit tests passed (`BUILD SUCCESSFUL` in 6 seconds), and the updated APK installed successfully and was delivered to the running Pixel 7 activity. Physical arena alignment remains pending.
- User supplied a landscape photo showing the server/status card covering roughly the upper third of the camera, discovery/action cards stacked across the arena, and the visual guide above the detector's effective lower region. Added a landscape-specific layout with a compact single-row status bar, controls in a right sidebar, and the guide directly bottom-anchored over the lower camera area. The landscape result view now reserves the right side for details instead of covering the creature image.
- The landscape visual guide is 60% of screen width and covers the lower ~42% of the screen. The matching detector fingerprint samples the centered horizontal 20–80% and lower vertical 55–95% of the camera frame, reducing triggers from people moving above or beside the arena.
- Simplified landscape build and unit tests passed (`BUILD SUCCESSFUL` in 8 seconds), and the APK installed successfully on the Pixel 7. Physical guide alignment and passerby rejection remain pending.

## Android motor-direction correction — 2026-09-12

- Physical Android/Nano test: all installed sensors reported correctly, but both forward and backward motion were reversed. The controller also pulsed while held; per user request, that separate behavior is not changed in this step.
- Added a **Reverse motor direction** setting, enabled by default for the current JarzRover wiring. Logical drive commands remain unchanged, and both left/right values are inverted only at the final USB/BLE hardware-command boundary, so manual and AI modes share the correction.
- Added unit coverage for reversed, unchanged, and stopped motor command values. Physical direction retest remains pending.
- Android build and all unit tests passed (`BUILD SUCCESSFUL` in 11 seconds; 47 tasks, 13 executed and 34 up-to-date). The corrected APK installed successfully and was delivered to the running Pixel 7 activity.

## Android higher-power timed turns — 2026-09-12

- Physical colored-ball test passed, but the rover could buzz or stall when attempting a low-power pivot near a wall after changing to a 7.4 V LiPo battery.
- Increased fixed-duration pivot commands from 50% to 75% for green-ball centering, blue-ball turning, wall avoidance, and the timed rectangle-patrol turn.
- Shortened each affected duration to approximately two-thirds of its previous value to preserve the intended turn angle: green 250→170 ms, blue 2600→1730 ms, wall 650→430 ms, and patrol 1300→870 ms.
- Left the red-ball turn at 50% because it is controlled by how long the red ball remains visible rather than by a fixed turn duration.
- `./gradlew :robot:assembleDebug :robot:testDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 7 seconds; 47 tasks, 9 executed and 38 up-to-date).
- Updated APK installation on the connected Pixel 7: pass. Physical torque, turn-angle, and floor tests remain pending; motor response is nonlinear, so the shortened times may require small hardware-specific adjustments.
- Physical retest: the stronger turns no longer stalled and red-ball behavior worked, but the 1730 ms blue-ball pivot produced approximately 270 degrees instead of 180 degrees. Reduced only the blue pivot to 1150 ms using the measured angle ratio.
- Blue-turn calibration build and unit tests passed (`BUILD SUCCESSFUL` in 6 seconds; 47 tasks, 9 executed and 38 up-to-date), and the updated APK installed successfully on the connected Pixel 7. User physical retest: pass; the blue-ball action now turns approximately 180 degrees.

## Creature Lab same-network gallery — 2026-09-12

- Added a server-side session list that receives each successful AI-generated creature directly inside `/api/generate`; the phone does not need a second upload or a new setting.
- Added `/api/creatures` and a full-screen `/gallery` display. The display checks for new results every two seconds, immediately selects the newest result, and rotates through up to 20 recent creatures every eight seconds.
- Gallery history is currently held in server memory and resets when the Creature Lab server restarts. This was selected over filesystem storage because the current Vinext runtime returned HTTP 500 when an API route attempted local filesystem access.
- Targeted formatter and linter checks for the new/changed Creature Lab files: pass. In-memory store smoke test: pass. `npm run build`: pass.
- Running-server checks: `/gallery` returned HTTP 200, `/api/creatures` returned HTTP 200 with an empty initial list, and the gallery returned HTTP 200 through the Mac Wi-Fi address at `http://192.168.251.244:3000/gallery`.
- Not run: a paid AI generation after adding the gallery, automatic appearance on a second physical computer, eight-second rotation with multiple real creatures, Wi-Fi isolation testing, or server-restart recovery.

## Creature Lab named abilities — 2026-09-12

- Changed the structured AI profile from one unconstrained ability string to separate `abilityName` and `abilityEffect` fields. The public API remains compatible by returning `ability` as `Ability Name: effect`.
- Required an original one-to-four-word name plus a concise, concrete effect for battle, exploration, defense, movement, or another situation; existing franchise ability names are explicitly excluded.
- Updated the computer demo abilities to include effects and updated the web capture and gallery pages to emphasize the named portion before the colon.
- Targeted Creature Lab formatting and lint checks: pass. `npm run build`: pass. A paid generation was not run, so the new model output remains to be verified with the next real creature.

## Android/Creature Lab GitHub handoff — 2026-09-12

- Prepared the complete working-tree feature set for the private `jarz-development` branch: Android Creature Lab capture/generation and stationary discovery, colored-ball turn calibration, shared motor-direction correction, Creature Lab named abilities and same-network gallery, documentation, and current firmware feature flags.
- Reconciled the hardware documentation with the current DIY firmware source: sonar and front speed sensors are enabled; indicators, voltage-divider sensing, and OLED remain disabled. The user reports the installed sensors work, but the exact flashed firmware revision was not independently read from the Nano.
- Final `./gradlew :robot:assembleDebug :robot:testDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 3 seconds; 47 tasks, 1 executed and 46 up-to-date).
- Final targeted Creature Lab lint and `npm run build`: pass.
- Commit-candidate filename and content review found no tracked/untracked API key or credential. Ignored `.env` files are intentionally excluded from Git.
- Not run: iOS build, Arduino firmware compilation (Arduino CLI is not installed), signed Android release/AAB generation, Play App Signing setup, Play Console validation, or Google Play policy/store-listing checks. Those remain the next release-readiness task on the other Mac.
## Android Free Roam controller stabilization — 2026-09-13

- User reported that Free Roam motion jerked and would not hold a steady speed, matching the previously deferred observation that forward controller input repeatedly stopped and restarted while held.
- Added a 120 ms confirmation before accepting a zero reading from the analog controller so a single transient zero sample does not stop the motors. A real released control still stops after the short confirmation delay.
- Added a 3% material-change threshold so small analog-stick noise does not continually change motor speed.
- Restricted button-derived drive commands to D-pad keys so unrelated gamepad button events cannot replace the active drive command with zero. Corrected the left/right comparison so a change to either motor is accepted.
- Added unit coverage for drive-button identification, stopped-control identification, jitter rejection, and real control changes.
- `./gradlew :robot:assembleDebug :robot:testDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 18 seconds; 47 tasks, 11 executed and 36 up-to-date).
- Updated APK installation on the connected Pixel 7: pass. Physical held-forward stability, release-stop timing, steering, and D-pad behavior remain pending.

## Android manual-assist colored-ball detection — 2026-09-13

- Changed Object Tracking so camera inference and colored-ball recognition continue while Auto is off.
- Auto on remains fully autonomous: patrol, sonar wall avoidance, and colored-ball actions control the rover. Auto off remains visitor-driven except while a detected red, green, or blue behavior is active; wall avoidance and patrol do not run in this mode.
- Controller commands received during a ball action are retained but prevented from fighting the AI motor command. When the action finishes or the ball disappears, the latest controller command is restored.
- Reset green centering/approach state when the green ball disappears so a later encounter starts fresh.
- `./gradlew :robot:assembleDebug :robot:testDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 19 seconds; 47 tasks, 10 executed and 37 up-to-date).
- Updated APK installation on the connected Pixel 7: pass. Physical manual driving, each color takeover, controller restoration, and Auto-mode regression remain pending.

## Creature Lab iPhone remote — 2026-09-19

- Added a dedicated Creature Lab control screen to the Flutter iPhone controller with live Android status, Learn Empty Area, Watch/Stop, Take Picture, Not Yet, Create Creature, and Retake controls.
- Added Android-to-controller Creature Lab state updates and controller-to-Android commands. The remote connection uses control-only mode so it does not intentionally start a competing WebRTC camera stream.
- Fixed controller startup and WebRTC signaling on iOS, added Bonjour/local-network declarations, and made WebRTC the Android default streaming mode.
- Fixed WebRTC shutdown so it stops and disposes its video capturer before CameraX opens Creature Lab. This addressed logs showing WebRTC still capturing at 30 FPS after its renderer had been released.
- Flutter release build, signing, and installation on the project test iPhone: pass. User confirmed the iPhone connected and displayed all Creature Lab controls.
- `./gradlew :robot:assembleDebug :robot:testDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 8 seconds; 47 tasks, 5 executed and 42 up-to-date).
- Updated APK installation on the connected Pixel 7: pass. Final physical confirmation of the Android preview after the camera-release fix remains pending.

## iOS Mac build baseline — 2026-09-11

- Source: `f7f2b10`, branch `jarz-development`; Xcode 26.6, Flutter 3.47.0, CocoaPods 1.17.0.
- Native OpenBot: initial failure from CocoaPods manifest/lock mismatch; `pod install --deployment` repaired local dependencies; generic iOS Debug build with signing disabled passed.
- Flutter controller: `flutter build ios --debug --no-codesign` passed.
- Flutter analysis: 64 informational lint/deprecation findings, nonzero exit. Tests: not run successfully; no `test` directory exists.
- No app source or tracked dependency changes needed. No device installation, runtime, simulator or physical rover tests performed.
- Reproduction and signing limitations: [BUILD_IOS.md](BUILD_IOS.md).

## Flutter controller device installation — 2026-09-12

- Target: Hiren's iPhone Pro Max, iOS 26.6.1; bundle ID `com.jarzlabs.openbotController`; Apple development team `94P2PNXKQ2`.
- A signed Debug build installed but exited with signal 11 when launched from the Home Screen. Captured device output identified the expected cause: Flutter debug mode on iOS 14+ requires Flutter tooling or Xcode to be attached.
- Rebuilt in Release configuration, installed successfully, and launched successfully. The `Runner` process remained present after launch.
- Corrected the Runner target's Debug, Profile, and Release signing team and bundle ID. This avoided a failed broad build-setting override that had assigned the app bundle ID to the embedded `nsd_ios` framework.
- Runtime controller discovery, video/control connection to the OpenBot phone, and physical rover behavior have not yet been tested.

## Android JarzRover branding variants — 2026-09-14

- Installed Homebrew OpenJDK 17 and Google's Android command-line tools on this Mac. Accepted the Android SDK license with explicit user authorization, then installed platform tools, Android 33, and build tools 33.0.1 under `/opt/homebrew/share/android-commandlinetools`.
- Added separate `makerFaire` and `play` distributions. Generated BuildConfig inspection confirms `CREATURE_LAB_ENABLED=true` for Maker Faire and `false` for Play.
- `./gradlew :robot:assembleMakerFaireDebug :robot:assemblePlayDebug :robot:testMakerFaireDebugUnitTest :robot:testPlayDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 1 minute 36 seconds; 86 tasks executed).
- Both APK manifests report application ID `com.jarzlabs.jarzrover`, version code `800`, and version name `v0.8.0`.
- Both variants ran 14 unit tests across six test suites with zero failures and zero errors.
- Build warnings remain for the command-line-tool/AGP SDK XML version mismatch, deprecated RenderScript use, and native libraries that could not be symbol-stripped. These are not build failures but must be revisited during the API 36/toolchain migration and release packaging checks.
- Not run: installation or UI smoke test on an emulator/device, signed release/AAB build, release lint, API 36 build, physical USB/robot behavior, or visual confirmation of the candidate launcher icon and removed account surfaces.

## Android open-source distributions — 2026-09-19

- Replaced the store-specific `play` distribution with a normal open-source `standard` distribution and retained `makerFaire` for event-specific behavior.
- Generated BuildConfig inspection confirms Creature Lab is enabled in both distributions. `MAKER_FAIRE_MODE=false` for `standard` and `true` for `makerFaire`.
- `./gradlew :robot:assembleStandardDebug :robot:assembleMakerFaireDebug :robot:testStandardDebugUnitTest :robot:testMakerFaireDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 18 seconds; 86 tasks, 56 executed and 30 up-to-date).
- Each distribution ran 16 unit tests across six suites with zero failures and zero errors. Both 44 MB debug APKs were produced under their respective `android/robot/build/outputs/apk` directories.
- Existing warnings remain for the command-line-tool/AGP SDK XML version mismatch, deprecated RenderScript use, and native libraries that could not be symbol-stripped.
- Not run: emulator/device installation, UI or launcher-icon inspection, physical Android/Nano rover behavior, iOS/ESP32 work, release build, release lint, or signed artifact generation. This software build does not establish physical rover compatibility.

## JarzRover app-icon exports — 2026-09-19

- Promoted the user-approved white-background printer/rover sketch with straight tires and no wheel-hub circles to `branding/source/jarzrover-app-icon-master.png`. Its SHA-256 matches the retained approved review image.
- Added a macOS `sips` exporter and generated Android robot launcher icons at 48, 72, 96, 144, and 192 pixels plus every filename referenced by the native iOS robot AppIcon catalog. Sample and 1024-pixel iOS files report no alpha channel.
- Updated the Android robot manifest to use density-specific `@mipmap/ic_launcher` and `@mipmap/ic_launcher_round` resources. The Flutter companion controller icon was intentionally not changed.
- Android `./gradlew :robot:assembleStandardDebug :robot:assembleMakerFaireDebug :robot:testStandardDebugUnitTest :robot:testMakerFaireDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 7 seconds; 86 tasks, 33 executed and 53 up-to-date). Both 44 MB debug APKs were produced.
- Native iOS robot unsigned generic-device Debug build: pass with `xcodebuild` and `CODE_SIGNING_ALLOWED=NO`; output `/private/tmp/jarzrover-ios-branding-build/Build/Products/Debug-iphoneos/OpenBot.app`. The AppIcon catalog compiled successfully.
- Existing iOS warnings remain for unassigned/duplicate non-app-icon assets, legacy icon slots, storyboards, Markdown resources, dependency scripts, and a missing inferred SocketIO-to-Starscream dependency. No app-icon error was reported.
- Visual inspection of the 192-pixel Android export retained the face and rover silhouette. Not run: Android or iOS installation, actual home-screen rendering under platform masks, signed iOS build, Flutter controller build, simulator test, or physical rover behavior.

## Open-source license, provenance, and secret audit — 2026-09-19

- Confirmed that the root MIT license retains the OpenBot/Intel ISL notice and documented the upstream relationship and release-notice boundaries in `docs/THIRD_PARTY_LICENSES.md`.
- Inventoried app/tool manifests, bundled TFLite assets, model download URLs, three downloaded Android AARs, and the native iOS nightly/branch dependencies. No dependency or model license was inferred merely from a successful build.
- Recorded SHA-256 hashes for bundled model/label files during review. The JarzRover colored-ball model was introduced by commit `27aa942`, but its training dataset, export version, author declaration, and redistribution license are not recorded; public release remains blocked on provenance or removal.
- Inspected tracked filenames, current tracked text, and Git history for high-confidence private-key headers and common OpenAI, GitHub, AWS, and Google service-account patterns. No matching high-confidence secret file was found. Values were not printed or recorded.
- Found four tracked Android/iOS client configurations bound to the upstream OpenBot Firebase project. Firebase client identifiers are not treated as server secrets, but the upstream backend binding must be removed or made optional before publication.
- Confirmed that local `open-code/.env` is ignored and that the tracked Creature Lab `.env.example` is a placeholder template. The local `.env` contents were not inspected.
- Limitation: Gitleaks, TruffleHog, and detect-secrets were not installed, so the targeted regex review is not a complete entropy/provider scan. Backend rules, service access, binary-embedded values, app builds, device behavior, and physical rover behavior were not tested in this documentation-only audit.

## Open-source ownership and model-provenance decisions — 2026-09-20

- User confirmed Aarambh LLC as owner of the original JARzLabs/JarzRover brand assets, operating under the registered Alameda County fictitious business name JARZLABS. Added `BRAND_POLICY.md` to reserve the names/artwork separately from MIT-licensed software and updated the branding inventory.
- User confirmed that the JARzLabs team created the colored-ball training images by photographing different colored balls, uploaded them to Roboflow, trained the model there, and exported the tracked TFLite model.
- Model provenance is partially resolved. The exact Roboflow workspace/project, dataset version and split, image/annotation ownership record, model family/version, export format/settings, training date, and applicable export terms have not yet been recovered.
- Documentation-only update: no app build, model inference, device test, network access, or physical rover test was run.

### Shared-session provenance follow-up

- Reviewed the user-provided shared ChatGPT session from the other Mac. It records creation of the public Roboflow project **OpenBot Colored Ball Detector** under default CC BY 4.0, 89 annotated images, and the classes `red-ball`, `green-ball`, and `blue-ball`.
- The session records recommended 80/10/10 splitting, non-stretch 512×512 preprocessing, and color-preserving augmentation guidance, but does not prove those settings were applied to the exported artifact. It also does not establish the exact dataset-version URL, training architecture/version, final metrics, export/quantization settings, or exact weights-license record.
- `file` identified the tracked artifact only as generic data. A string inspection found TensorFlow Lite conversion metadata but no embedded author, Roboflow identifier, model version, or license. Added `docs/models/COLORED_BALL_MODEL.md` to separate verified facts from remaining unknowns.
- No model execution, inference comparison, network service access, app build, device test, or physical rover test was performed.

## Optional Firebase decoupling — 2026-09-20

- Removed four tracked Android/iOS mobile client configurations for the upstream OpenBot Firebase project and removed the upstream iOS Google callback URL scheme. Both platforms now build without a Firebase configuration and skip explicit Firebase initialization; Android only applies the Google Services plugin when an ignored local robot-app configuration exists.
- Removed an accidental Firebase service construction from Android's local model-config writer. Local model updates, rover control, colored-ball detection, and Creature Lab do not require Firebase. Missing configuration is also handled safely by the inherited Android QR/Drive importer.
- Added `docs/FIREBASE_SETUP.md` for optional JARzLabs-owned Firebase use on authorized development or demo devices. Client configuration remains untracked; service-account credentials must never be distributed or committed.
- Android `./gradlew :robot:assembleStandardDebug :robot:assembleMakerFaireDebug :robot:testStandardDebugUnitTest :robot:testMakerFaireDebugUnitTest`: pass (`BUILD SUCCESSFUL` in 4 seconds; 86 tasks, 25 executed and 61 up-to-date). Generated BuildConfig inspection confirmed `CLOUD_SERVICES_ENABLED=false` and an empty web client ID in the default build.
- Native iOS robot unsigned generic-device Debug build without `GoogleService-Info.plist`: pass with `xcodebuild` and `CODE_SIGNING_ALLOWED=NO`; output `/private/tmp/jarzrover-ios-firebase-decoupling/Build/Products/Debug-iphoneos/OpenBot.app`.
- Artifact inspection found no `google-services.json`/`GoogleService-Info.plist` in either debug APK or the iOS app bundle, and no upstream OpenBot Firebase project identifier remained in current Android/iOS source outside historical documentation.
- `./gradlew :robot:checkStyle` could not run because the robot project defines no `checkStyle` task; this is a missing verification entry point, not a style-test pass.
- Not run: app launch on an emulator or device, physical rover behavior, JARzLabs Firebase sign-in/Drive flow with local configuration, Firebase Security Rules/App Check review, or signed/release artifact validation. The iOS build retained existing dependency and Markdown-resource warnings.

## Public-readiness branding and build verification — 2026-09-20

- Added the approved JARzLabs README banner and applied the approved JarzRover icon to the Android robot, native Android controller, native iOS robot, and Flutter controller export sets. Updated product labels and set controller identifiers to `com.jarzlabs.jarzrover.controller`.
- Removed upstream-owner issue automation, GPT workflows with broad permissions/API-secret dependencies, traffic collection, and automatic debug-APK release publishing. Android CI now builds the supported JarzRover robot variants and controller on `jarz-development` and `master`.
- Added SHA-256 verification for the three OpenBot-hosted Android AAR downloads. Verification passed with the locally downloaded payloads.
- Android debug build and unit-test command passed: `:robot:assembleStandardDebug`, `:robot:assembleMakerFaireDebug`, `:robot:testStandardDebugUnitTest`, `:robot:testMakerFaireDebugUnitTest`, and `:controller:assembleDebug` (`BUILD SUCCESSFUL` in 12 seconds; 121 tasks, 43 executed and 78 up-to-date).
- Android unsigned release build passed for `:robot:assembleStandardRelease` and `:controller:assembleRelease` (`BUILD SUCCESSFUL` in 30 seconds). Outputs are explicitly named `*-unsigned.apk` and are not distribution artifacts.
- Added an ignored `android/keystore.properties` path and a tracked placeholder template. Both release modules use the same signing identity when local values are supplied. Re-ran the unsigned release tasks without a local keystore: pass (`BUILD SUCCESSFUL` in 4 seconds), confirming that contributor builds remain available.
- Flutter dependencies resolved. `flutter analyze` completed with a nonzero exit because of 63 inherited informational style/deprecation findings; no analyzer errors were reported. `flutter test` could not run because the project has no `test` directory.
- `flutter build ios --release --no-codesign` passed and produced a 30.6 MB device app at `controller/flutter/build/ios/iphoneos/Runner.app`. It is unsigned and cannot be emailed or hosted as an installable iOS binary.
- `security find-identity -v -p codesigning` reports zero valid Apple signing identities on this Mac. No JARzLabs Android release keystore was found. Signed distribution remains blocked on those credentials/profiles.
- Installed Gitleaks 8.30.1 and scanned the final 1,041-commit history. The scan passed with no leaks after applying a checked-in allowlist limited to inherited OpenBot Firebase client configurations already present in the public upstream/history and CocoaPods checksum false positives.
- Not run: Android/iOS device installation, simulator UI, website/email installation, physical rover/controller behavior, signed APK/IPA creation, TestFlight/Ad Hoc provisioning, or public GitHub push. Model/AAR notice gaps documented in `docs/THIRD_PARTY_LICENSES.md` remain binary-release gates.
