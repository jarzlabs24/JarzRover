# JarzRover test log

## Historical baseline

Recorded on 2026-09-04 from the user's JarZLabs handoff. Original test dates, firmware revisions, measurements, and detailed procedures were not supplied. These are user-reported completed tests, not tests rerun during this documentation work.

| Test / observation | Reported outcome | Limits / current status |
| --- | --- | --- |
| Direct wiring without breadboard | Robot successfully operated | Exact as-built schematic not recorded |
| Left motor test | Completed successfully | Speed, load, and procedure not recorded |
| Right motor test | Completed successfully | Speed, load, and procedure not recorded |
| HC-SR04 serial readings | Eventually worked | Fix, sketch, accuracy, and range not recorded; sonar currently disabled in checked-in DIY firmware |
| Android USB OTG power to Nano | Nano powered from phone | Full robot still requires proper battery power |

## Documentation verification — 2026-09-04

Inspected `firmware/openbot/openbot.ino` at commit `5d7e4ce`: `OPENBOT DIY`, `MCU NANO`, and all pin assignments in [HARDWARE.md](HARDWARE.md) match the source. Sonar, front speed sensors, indicators, voltage-divider sensing, and OLED are disabled in the DIY block. No firmware was changed and no physical robot tests were run for this setup.

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
- Detailed review: /Users/aarav/.codex/.chatgpt-projects/g-p-69eeb1ada73c81918e529342f131fd89/MERGE_READINESS_2026-09-07.md. Temporary build logs are /tmp/jarz-*-review.log and /tmp/jarz-*-ios.log, plus /tmp/jarz-flutter-analyze.log and /tmp/jarz-flutter-test.log.

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
- The corrected build was installed and launched on Aarav's iPhone through Xcode. Reopening Creature Lab and testing capture/generation remain user-device checks.
- Physical iPhone verification: pass. Creature Lab opened without crashing, captured a photo, reached the Mac-hosted server at `http://192.168.251.244:3000`, and returned an AI-generated creature result.
- This verification used the iPhone and Mac on the same local network with the development server running; rover mounting, motor behavior, autonomous detection, and Maker Faire network reliability remain untested.
