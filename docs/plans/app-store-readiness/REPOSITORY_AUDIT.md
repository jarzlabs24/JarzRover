# Repository inspection — 2026-09-06

Baseline: `27ea32b289718196a05d89c1d3aef75d80268860`, branch `jarz-development`, clean working tree before this documentation change. Read-only local inspection; no builds, physical tests, remote fetch, store-console inspection, or secret audit performed.

## Existing assets retained

AGENTS.md, README.md and docs/PROJECT_CONTEXT.md already establish JarZLabs/Codex handoff. HARDWARE.md, WIRING.md and TEST_LOG.md preserve source-verified pin assignments and explicitly labeled user-reported tests. Recent commits preserve second-Mac Flutter/iOS work and add a Creature Lab demo. Existing translated docs, OpenBot attribution, LICENSE, issue templates and history remain in place. The earlier suggested directory layout is conceptual; moving existing code would add risk without improving the handoff.

| Area | Observed source | Gap / backlog |
| --- | --- | --- |
| Android robot | android/robot/build.gradle: org.openbot, compile 33, target 32, min 21; release lint disabled | JR-001/003/004/010: select app, identity, current requirements, meaningful release checks |
| Native Android controller | android/controller/build.gradle: namespace org.openbot.controller; target 32; release debuggable true | JR-001/004/006 |
| Flutter controller | controller/flutter/README.md describes a second-device controller; pubspec 1.0.0+1; Android org.openbot.flutter_controller, target/compile 36, min 24; release signs with debug config | JR-001/003/006; not proof of robot-app feature parity |
| Flutter iOS | Runner project: com.openbot.openbotController, target 15.0 | JR-001/003/005: shipping role, identities and physical connectivity |
| Native iOS robot | ios/OpenBot project: com.jarzlabs.openbot; app target 15.0, some test configs 15.5; README has inconsistent minimums | JR-002/005: reconcile supported versions and actual build/test |
| Features | tools/creature-lab exists; tests/colorBalls.js exists; context says end-to-end green-ball acceptance unestablished | JR-014/015; demo/file existence is not mobile integration evidence |
| CI | gradle.yml targets master; cocoapod.yml targets master and only installs pods, deletes lockfile; releases.yml uploads debug APKs | JR-010: cover integration/release branches, deterministic dependency use, real builds/tests |
| Services | Android robot declares Firebase auth, storage, Firestore, analytics and Crashlytics; native iOS has GoogleService-Info.plist | JR-007/008: inspect actual runtime data flows and credential/config ownership; config presence is not proof of secret exposure |
| Remotes | origin private-named repository; public-fork JarzRover; upstream ob-f/OpenBot | JR-002: live visibility/settings unverified; do not publish to wrong remote |
| Default branch | cached origin/HEAD → codex/import-second-mac-flutter | JR-002: verify live setting before changing PR/CI defaults |

## Intended workflow versus current state

Existing context handoff is a sound starting point but lacks a release backlog, explicit Dad/Aarav ownership, a release-branch gate and a reusable task packet. This change adds those components without reorganizing implementation directories. App-store readiness is still work to execute, not a claim of compliance.

## Source conversation and limits

[JarzRover Bot Design and Testing](chatgpt-conversation://6a6f8d1e-a238-83ea-902c-71b13ec9e8f6), retrieved 2026-09-06: Dad requested Android/iOS store preparation; Aarav owns ball detection and creature generation. Prior assistant suggested com.jarzlabs.jarzrover and 1.0.0 as examples, not confirmed identifiers. Retrieved readiness answer is truncated after its proposed folder layout; no unseen remainder is treated as agreed scope. Recent discussion mentions a 2S LiPo and switch/pigtail work, but no verified as-built change is imported into the hardware baseline.
