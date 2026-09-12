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
- Optional speed sensors, indicator LEDs, and bumper may be removed or disabled as appropriate. Do not infer installation from pin definitions.
- Preserve known working pin mappings and prefer small changes with clear tests.

## Current status and focus

Work is focused on OpenBot object navigation and green-ball behavior: detection, centering, approach, and stopping. This describes the development goal; the supplied history does not establish an end-to-end pass or a verified stopping distance.

Creature Lab is being developed in `tools/creature-lab` as a separate, computer-first Maker Faire experience. Its initial flow uses the computer camera to capture one object, creates a local demo creature when paid AI generation is unavailable, and displays a creature image with a generated name, type, description, and special ability. Keep this experience stationary while it is being built and tested; rover roaming is out of scope for this phase.

The selected Creature Lab visual direction is original, clean late-1990s/early-2000s Japanese game-guide creature art: smooth medium-thin outlines, simple friendly silhouettes, expressive geometric eyes, mostly flat moderately saturated colors, one restrained cel-shadow layer, small highlights, and a plain white background. Avoid watercolor, paper grain, sketch texture, painterly rendering, photorealism, and 3D rendering. Prompts must describe these general visual properties while continuing to prohibit imitation of Pokemon, existing characters, or a named artist.

Creature morphology must be object-led rather than mascot-led. Before image generation, AI identifies the source object, selects a justified body plan, and names two to four defining features. Limbless, quadruped, many-legged, radial, floating, aquatic, plant-like, mechanical, asymmetric, or bipedal forms are all allowed; arms, legs, ears, and tails are never automatic defaults.

The design target is "creature first, object inspiration second." The source object must not be copied whole and given a face. AI should reinterpret only two or three traits—material, color, texture, function, or a distinctive shape—as distributed anatomy, armor, markings, or powers, then invent the rest. Purposeful locomotion appendages are recommended unless a limbless, radial, or floating concept is genuinely stronger.

## Creature Patrol architecture

The Maker Faire target is a phone-controlled Creature Patrol mode: patrol, detect a stable object candidate, stop, request visitor confirmation, capture, generate, show the result, wait for removal, and only then resume. The phone must never contain the OpenAI API key; it will send approved captures to a server that performs generation.

The first Android component is a hardware-independent state machine in `org.openbot.creature`. Non-zero motor commands must eventually be gated by its `allowsMotion()` result. Camera and motor integration is intentionally deferred until the state transitions pass unit tests and the object-zone strategy is selected and tested while stationary.

The checked-in firmware selects `OPENBOT DIY` and `MCU NANO`. Sonar, front speed sensors, indicators, voltage-divider sensing, and OLED are disabled in the DIY block. A successful standalone ultrasonic serial test does not establish that sonar is enabled or validated in the integrated robot firmware. Confirm the actually flashed sketch before the next hardware test.

## Next implementation handoff

1. Read the [hardware baseline](HARDWARE.md), [wiring notes](WIRING.md), and [test log](TEST_LOG.md).
2. Confirm installed optional components, flashed firmware, battery arrangement, and driver connections before hardware-affecting work.
3. Establish the current green-ball behavior and test detection, centering, approach, and stopping in small steps; record observed results.
4. Update these documents when a decision or verified result changes the baseline.

Battery specifications, driver jumper positions, exact terminal assignments, and original test dates remain unrecorded. Do not fill these gaps with assumptions.

## App-store planning handoff — 2026-09-06

The user now has two work tracks: Dad prepares Google Play and Apple App Store readiness; Aarav develops ball detection and object-to-creature experiences. Green-ball behavior remains a feature goal with the evidence limits above.

[Execution workflow](CODEX_WORKFLOW.md), [readiness plan](plans/app-store-readiness/PLAN.md), [issue-ready backlog](plans/app-store-readiness/BACKLOG.md), and [repository inspection](plans/app-store-readiness/REPOSITORY_AUDIT.md) extend this context without replacing hardware history. The repository contains native Android robot/controller, native iOS robot, Flutter controller, and a Creature Lab demo. Shipping apps, identifiers and iOS transport remain decisions; com.jarzlabs.jarzrover was an example, not an adopted ID.

Next: Dad starts JR-001 (scope) and JR-002 (baseline). Aarav prepares JR-014/015 after baseline, with release inclusion decided through JR-016. No app code, branch/default settings, signing or store records were changed by this documentation setup.
