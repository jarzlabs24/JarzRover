# JarzRover project context

## Purpose and project relationship

JarZLabs is a youth-run STEM and 3D-printing project. JarzRover is its OpenBot-based robot project, using an Android phone for higher-level behavior and an Arduino Nano for motor and sensor control.

The existing Codex project is named **JarzRover**; its repository is the OpenBot checkout. JarZLabs is the broader ChatGPT planning and history project. Maintain this document as the durable handoff between them: bring relevant decisions into the repository and share revised context back into JarZLabs when needed. This setup does not automatically synchronize conversation history.

Source context: user-provided handoff from [Make Project Available](chatgpt-conversation://6a9b583a-fce0-83e9-9556-47c4a2e1e993), consolidated on 2026-09-04. Hardware outcomes below are historical user reports; their original dates and detailed measurements were not supplied. Firmware facts were checked against `firmware/openbot/openbot.ino` at commit `5d7e4ce`.

## Durable history and decisions

- Built around OpenBot DIY with a Lafvin/ATmega328p Arduino Nano, L298N driver, four TT motors, a front HC-SR04, and an Android phone connected by USB OTG.
- The robot has operated successfully with direct wiring and without a breadboard. Preserve that working architecture; avoid reintroducing a breadboard where practical.
- Left and right motor tests were completed successfully.
- HC-SR04 serial readings eventually worked after troubleshooting. The exact fix and test sketch were not recorded in the supplied history.
- The Android phone can power the Nano over OTG. Full robot operation requires proper battery power for the motor system.
- The current rover has no ESP32 or separate BLE module. The native iOS robot app is BLE-only and cannot control the installed ATmega328p Nano through its USB connection; the failed iPhone manual-control test is therefore a connection-architecture mismatch, not evidence of a motor-wiring failure.
- Sonar and front speed sensor readings are now reported working through the Android/Nano connection and enabled in the current DIY source. Indicator LEDs and bumper remain disabled or unestablished; do not infer installation from pin definitions alone.
- Preserve known working pin mappings and prefer small changes with clear tests.

## Current status and focus

Work is focused on OpenBot object navigation and green-ball behavior: detection, centering, approach, and stopping. This describes the development goal; the supplied history does not establish an end-to-end pass or a verified stopping distance.

Object Tracking now has two colored-ball operating modes. With Auto on, the rover controls patrol, wall avoidance, and all ball actions. With Auto off, camera detection remains active as a manual-assist layer: the visitor drives with the selected controller, a red/green/blue behavior temporarily takes motor control when triggered, and the latest controller command resumes when that behavior finishes or the ball disappears. Wall avoidance and autonomous patrol remain Auto-only.

Creature Lab is being developed in `tools/creature-lab` as a separate, computer-first Maker Faire experience. Its initial flow uses the computer camera to capture one object, creates a local demo creature when paid AI generation is unavailable, and displays a creature image with a generated name, type, description, and special ability. Keep this experience stationary while it is being built and tested; rover roaming is out of scope for this phase.

The Flutter iPhone controller now provides a dedicated Creature Lab remote when the Android app opens that feature. It mirrors status and generation progress and can learn the empty area, start or stop watching, respond to the object-found prompt, take or retake a photo, and start creature generation. Creature Lab uses a control-only phone connection so Android CameraX retains exclusive ownership of the rover camera.

The selected Creature Lab visual direction is original, clean late-1990s/early-2000s Japanese game-guide creature art: smooth medium-thin outlines, simple friendly silhouettes, expressive geometric eyes, mostly flat moderately saturated colors, one restrained cel-shadow layer, small highlights, and a plain white background. Avoid watercolor, paper grain, sketch texture, painterly rendering, photorealism, and 3D rendering. Prompts must describe these general visual properties while continuing to prohibit imitation of Pokemon, existing characters, or a named artist.

Every generated creature ability must have an original, memorable one-to-four-word name and a concise explanation of its concrete effect in battle, exploration, defense, movement, or another situation. The server obtains the name and effect as separate structured fields, then returns the backward-compatible display string `Ability Name: effect` to web, Android, and iOS clients.

Creature morphology must be object-led rather than mascot-led. Before image generation, AI identifies the source object, selects a justified body plan, and names two to four defining features. Limbless, quadruped, many-legged, radial, floating, aquatic, plant-like, mechanical, asymmetric, or bipedal forms are all allowed; arms, legs, ears, and tails are never automatic defaults.

The design target is "creature first, object inspiration second." The source object must not be copied whole and given a face. AI should reinterpret only two or three traits—material, color, texture, function, or a distinctive shape—as distributed anatomy, armor, markings, or powers, then invent the rest. Purposeful locomotion appendages are recommended unless a limbless, radial, or floating concept is genuinely stronger.

For the Maker Faire display, the Mac-hosted Creature Lab server also provides `/gallery`. Every successful server-side AI generation is added to a session-only list of the latest 20 creatures. Any display computer on the same Wi-Fi can open the Mac's port-3000 gallery URL; the page checks for new discoveries every two seconds, selects a new creature immediately, and rotates through recent creatures every eight seconds. Keep the server running throughout the event because this first simple version does not preserve gallery history across a restart.

## Creature Patrol architecture

The Maker Faire target is a phone-controlled Creature Patrol mode: patrol, detect a stable object candidate, stop, request visitor confirmation, capture, generate, show the result, wait for removal, and only then resume. The phone must never contain the OpenAI API key; it will send approved captures to a server that performs generation.

The first Android component is a hardware-independent state machine in `org.openbot.creature`. Non-zero motor commands must eventually be gated by its `allowsMotion()` result. Camera and motor integration is intentionally deferred until the state transitions pass unit tests and the object-zone strategy is selected and tested while stationary.

The checked-in firmware selects `OPENBOT DIY` and `MCU NANO`. Sonar and front speed sensors are enabled in the DIY block; indicators, voltage-divider sensing, and OLED remain disabled. The user reports that installed sensors now work through the Android/Nano connection. Confirm the actually flashed sketch when a physical result differs from the checked-in source.

## Next implementation handoff

1. Read the [hardware baseline](HARDWARE.md), [wiring notes](WIRING.md), and [test log](TEST_LOG.md).
2. Confirm installed optional components, flashed firmware, battery arrangement, and driver connections before hardware-affecting work.
3. Establish the current green-ball behavior and test detection, centering, approach, and stopping in small steps; record observed results.
4. Update these documents when a decision or verified result changes the baseline.

Battery specifications, driver jumper positions, exact terminal assignments, and original test dates remain unrecorded. Do not fill these gaps with assumptions.

## Open-source product handoff — 2026-09-19

The current goal is to prepare JarzRover as a useful open-source JARzLabs project derived from OpenBot, rather than submit Android or iOS binaries to an app store now. Preserve the store research and decisions in the deferred readiness documents so that work can resume later; do not treat store requirements as current release gates.

The repository contains the native Android robot/controller, native iOS robot, Flutter controller, firmware, and Creature Lab. The Android/Nano/USB path is the known working rover baseline and must remain intact. The planned iOS robot path is separate: an iPhone will use BLE to an ESP32, with its own firmware and verified wiring. The exact ESP32 board and electrical interface must be identified before pin or power decisions are made.

The product is **JarzRover** from **JARzLabs**, retains application ID `com.jarzlabs.jarzrover`, and provides OpenBot attribution in About and required license notices. Creature Lab is part of the open-source product and is enabled in both the normal and Maker Faire Android configurations. The Maker Faire configuration remains available for event-specific behavior without becoming the only usable build.

Active milestones and acceptance criteria are in [OPEN_SOURCE_READINESS](OPEN_SOURCE_READINESS.md). [APP_STORE_READINESS](APP_STORE_READINESS.md), [RELEASE_BACKLOG](RELEASE_BACKLOG.md), and the older [app-store plan](plans/app-store-readiness/PLAN.md) are retained as deferred inputs. No signing material, API key, private service credential, or developer-account secret belongs in this repository.

The initial public-source audit is documented in [THIRD_PARTY_LICENSES](THIRD_PARTY_LICENSES.md) and [SECURITY](SECURITY.md). Publication remains gated on colored-ball model provenance, an explicit brand-asset ownership/use policy, removal or optional configuration of the upstream OpenBot Firebase project, verification of downloaded binary/model provenance, and exact dependency acknowledgements. These findings do not change the Android/Nano hardware baseline.

On 2026-09-20, the project owner confirmed that Aarambh LLC operates under the registered Alameda County fictitious business name JARZLABS and owns the original JARzLabs/JarzRover brand assets. The public styling remains JARzLabs; the legal DBA spelling is JARZLABS. `BRAND_POLICY.md` reserves the marks separately from the MIT-licensed software.

The project owner also confirmed that the JARzLabs team created the colored-ball model by taking its own photographs of different colored balls, uploading those images to Roboflow, training there, and exporting the tracked TFLite file. Review of the other-Mac shared session established a public Roboflow project named **OpenBot Colored Ball Detector**, creation under default CC BY 4.0, 89 annotated images, and red-ball/green-ball/blue-ball classes. The exact dataset-version URL, final split and preprocessing/augmentation, architecture/version, export settings, metrics, weight-license record, and attribution still need to be recovered. Maintain these details in [the colored-ball model card](models/COLORED_BALL_MODEL.md).

JARzLabs owns a separate Firebase project. It is optional infrastructure for authorized local development and selected demo devices, not a requirement for the rover, ball model, local model configuration, or Creature Lab. Public clones must not connect automatically to JARzLabs or the upstream OpenBot backend. The upstream tracked client configurations were removed and local JARzLabs opt-in is documented in [FIREBASE_SETUP](FIREBASE_SETUP.md); never distribute service-account credentials to users.

For the first public-source milestone, the Android robot, native Android controller, native iOS robot, and Flutter controller share the approved JarzRover app icon. The public repository uses `jarz-development` as its integration branch and retains `upstream` as `ob-f/OpenBot`. Website/email binary distribution is separate from source publication: Android requires a long-lived JARzLabs release key, and iOS requires an Apple signing identity plus a supported Ad Hoc or TestFlight route.
