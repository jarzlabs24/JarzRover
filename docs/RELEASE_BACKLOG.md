# Release execution backlog

> **Status: deferred on 2026-09-19.** The store-submission backlog below is retained so it can be resumed later; it is not the active execution queue. Current work follows [OPEN_SOURCE_READINESS](OPEN_SOURCE_READINESS.md).

Snapshot: 2026-09-07. [GitHub issues](https://github.com/jarzlabs24/JarzRover-Private/issues) are authoritative for live status. Read [readiness plan](APP_STORE_READINESS.md) and [AI-agent handoff](CODEX_HANDOFF.md). All items below start **Open / planned**, not completed implementation.

The 20 agreed IDs are preserved. REL-006/007/008, AND-006, PLAY-003 and IOS-004 make the original roadmap's context, privacy, CI, failure recovery and final store submissions explicit. There were no existing issues or milestones to duplicate. Existing code, hardware context and issue templates were inspected first.

Owner labels are `owner:jarvis414-bot`, `owner:jarzlabs24`, and `owner:joint`. The GitHub identities are verified. @jarvis414-bot owns REL-001 execution; scope approval is joint. Milestones group outcomes, not strict serial phases. Dependencies gate completion; preparatory work may start earlier. Creature Lab has since been promoted into the open-source baseline; the retained store backlog remains deferred.

## Issue map

| Task | Issue | Owner | Milestone | Depends on | Snapshot |
| --- | --- | --- | --- | --- | --- |
| REL-006: Maintain repository context and AI-agent handoff | [#1](https://github.com/jarzlabs24/JarzRover-Private/issues/1) | @jarvis414-bot | M0 — Repo workflow | None | Open / planned |
| REL-001: Define JarzRover 1.0 feature scope | [#2](https://github.com/jarzlabs24/JarzRover-Private/issues/2) | @jarvis414-bot | M1 — Release scope | [REL-006 (#1)](https://github.com/jarzlabs24/JarzRover-Private/issues/1) | Open / planned |
| PLAY-001: Set up Google Play Console | [#15](https://github.com/jarzlabs24/JarzRover-Private/issues/15) | @jarvis414-bot | M2 — Repo hardening | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2) | Open / planned |
| REL-002: Establish develop and release/1.0 workflow | [#3](https://github.com/jarzlabs24/JarzRover-Private/issues/3) | @jarvis414-bot | M2 — Repo hardening | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2) | Open / planned |
| REL-003: Audit dependencies, models and licenses | [#4](https://github.com/jarzlabs24/JarzRover-Private/issues/4) | @jarvis414-bot | M2 — Repo hardening | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2) | Open / planned |
| REL-004: Remove secrets and development artifacts | [#5](https://github.com/jarzlabs24/JarzRover-Private/issues/5) | @jarvis414-bot | M2 — Repo hardening | None | Open / planned |
| REL-005: Document reproducible Android build | [#6](https://github.com/jarzlabs24/JarzRover-Private/issues/6) | @jarvis414-bot | M2 — Repo hardening | [REL-003 (#4)](https://github.com/jarzlabs24/JarzRover-Private/issues/4), [REL-004 (#5)](https://github.com/jarzlabs24/JarzRover-Private/issues/5) | Open / planned |
| AND-001: Upgrade Android target and compile SDK for Play | [#7](https://github.com/jarzlabs24/JarzRover-Private/issues/7) | @jarvis414-bot | M3 — Android production | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2), [REL-005 (#6)](https://github.com/jarzlabs24/JarzRover-Private/issues/6) | Open / planned |
| AND-002: Create production release configuration | [#8](https://github.com/jarzlabs24/JarzRover-Private/issues/8) | @jarvis414-bot | M3 — Android production | [AND-001 (#7)](https://github.com/jarzlabs24/JarzRover-Private/issues/7), [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2) | Open / planned |
| AND-003: Configure signing and Android App Bundle | [#20](https://github.com/jarzlabs24/JarzRover-Private/issues/20) | @jarvis414-bot | M3 — Android production | [AND-002 (#8)](https://github.com/jarzlabs24/JarzRover-Private/issues/8), [REL-004 (#5)](https://github.com/jarzlabs24/JarzRover-Private/issues/5), [PLAY-001 (#15)](https://github.com/jarzlabs24/JarzRover-Private/issues/15) | Open / planned |
| AND-004: Audit permissions and SDK privacy behavior | [#9](https://github.com/jarzlabs24/JarzRover-Private/issues/9) | @jarvis414-bot | M3 — Android production | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2), [REL-003 (#4)](https://github.com/jarzlabs24/JarzRover-Private/issues/4) | Open / planned |
| AND-005: Add reviewer and hardware-free demo mode | [#10](https://github.com/jarzlabs24/JarzRover-Private/issues/10) | @jarvis414-bot | M3 — Android production | [AND-002 (#8)](https://github.com/jarzlabs24/JarzRover-Private/issues/8), [AND-004 (#9)](https://github.com/jarzlabs24/JarzRover-Private/issues/9) | Open / planned |
| AND-006: Harden lifecycle and communication failure recovery | [#21](https://github.com/jarzlabs24/JarzRover-Private/issues/21) | @jarvis414-bot | M3 — Android production | [AND-001 (#7)](https://github.com/jarzlabs24/JarzRover-Private/issues/7), [AI-002 (#12)](https://github.com/jarzlabs24/JarzRover-Private/issues/12) | Open / planned |
| REL-007: Document privacy, audience and public support | [#18](https://github.com/jarzlabs24/JarzRover-Private/issues/18) | @jarvis414-bot | M3 — Android production | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2), [REL-003 (#4)](https://github.com/jarzlabs24/JarzRover-Private/issues/4), [AND-004 (#9)](https://github.com/jarzlabs24/JarzRover-Private/issues/9) | Open / planned |
| REL-008: Align continuous integration with release workflow | [#19](https://github.com/jarzlabs24/JarzRover-Private/issues/19) | @jarvis414-bot | M3 — Android production | [REL-002 (#3)](https://github.com/jarzlabs24/JarzRover-Private/issues/3), [REL-005 (#6)](https://github.com/jarzlabs24/JarzRover-Private/issues/6), [AND-001 (#7)](https://github.com/jarzlabs24/JarzRover-Private/issues/7), [AI-003 (#13)](https://github.com/jarzlabs24/JarzRover-Private/issues/13) | Open / planned |
| AI-001: Stabilize colored-ball inference | [#11](https://github.com/jarzlabs24/JarzRover-Private/issues/11) | @jarzlabs24 | M4 — Feature stabilization | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2), [REL-003 (#4)](https://github.com/jarzlabs24/JarzRover-Private/issues/4) | Open / planned |
| AI-002: Harden red, green and blue behaviors | [#12](https://github.com/jarzlabs24/JarzRover-Private/issues/12) | @jarzlabs24 | M4 — Feature stabilization | [AI-001 (#11)](https://github.com/jarzlabs24/JarzRover-Private/issues/11) | Open / planned |
| AI-003: Add regression tests for behavior logic | [#13](https://github.com/jarzlabs24/JarzRover-Private/issues/13) | @jarzlabs24 | M4 — Feature stabilization | [AI-002 (#12)](https://github.com/jarzlabs24/JarzRover-Private/issues/12) | Open / planned |
| QA-001: Create and execute physical rover release checklist | [#22](https://github.com/jarzlabs24/JarzRover-Private/issues/22) | @jarvis414-bot and @jarzlabs24 | M4 — Feature stabilization | [AI-003 (#13)](https://github.com/jarzlabs24/JarzRover-Private/issues/13), [AND-003 (#20)](https://github.com/jarzlabs24/JarzRover-Private/issues/20), [AND-005 (#10)](https://github.com/jarzlabs24/JarzRover-Private/issues/10), [AND-006 (#21)](https://github.com/jarzlabs24/JarzRover-Private/issues/21), [REL-007 (#18)](https://github.com/jarzlabs24/JarzRover-Private/issues/18) | Open / planned |
| PLAY-002: Distribute internal and closed testing release | [#23](https://github.com/jarzlabs24/JarzRover-Private/issues/23) | @jarvis414-bot | M5 — Google Play beta | [QA-001 (#22)](https://github.com/jarzlabs24/JarzRover-Private/issues/22), [REL-008 (#19)](https://github.com/jarzlabs24/JarzRover-Private/issues/19), [PLAY-001 (#15)](https://github.com/jarzlabs24/JarzRover-Private/issues/15) | Open / planned |
| PLAY-003: Submit Android 1.0 and prepare rollout support | [#24](https://github.com/jarzlabs24/JarzRover-Private/issues/24) | @jarvis414-bot | M6 — Android 1.0 | [PLAY-002 (#23)](https://github.com/jarzlabs24/JarzRover-Private/issues/23) | Open / planned |
| IOS-001: Decide iPhone-to-rover communication architecture | [#16](https://github.com/jarzlabs24/JarzRover-Private/issues/16) | @jarvis414-bot | M7 — iOS POC | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2) | Open / planned |
| IOS-002: Build connectivity and vision proof of concept | [#17](https://github.com/jarzlabs24/JarzRover-Private/issues/17) | @jarvis414-bot and @jarzlabs24 | M7 — iOS POC | [IOS-001 (#16)](https://github.com/jarzlabs24/JarzRover-Private/issues/16), [AI-001 (#11)](https://github.com/jarzlabs24/JarzRover-Private/issues/11) | Open / planned |
| IOS-003: Establish TestFlight pipeline and App Store submission | [#26](https://github.com/jarzlabs24/JarzRover-Private/issues/26) | @jarvis414-bot | M8 — iOS production | [IOS-004 (#25)](https://github.com/jarzlabs24/JarzRover-Private/issues/25) | Open / planned |
| IOS-004: Prepare iOS production application and review package | [#25](https://github.com/jarzlabs24/JarzRover-Private/issues/25) | @jarvis414-bot | M8 — iOS production | [IOS-002 (#17)](https://github.com/jarzlabs24/JarzRover-Private/issues/17), [REL-007 (#18)](https://github.com/jarzlabs24/JarzRover-Private/issues/18), [REL-003 (#4)](https://github.com/jarzlabs24/JarzRover-Private/issues/4) | Open / planned |
| AI-004: Prototype creature generation after 1.0 | [#14](https://github.com/jarzlabs24/JarzRover-Private/issues/14) | @jarzlabs24 | M9 — Feature 1.1+ | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2) | Open / planned |

## Acceptance criteria by task

Criteria below mirror the initial issues. Update the issue and this snapshot when scope changes. Completion also requires actual evidence, limitations, PR/commit and a result handoff.

### REL-006 — Maintain repository context and AI-agent handoff

- [ ] AGENTS.md preserves existing hardware instructions and links readiness, backlog and handoff documents
- [ ] All tasks have issue links, owner labels, milestones, acceptance criteria and dependencies
- [ ] A new AI-agent session can start from repository documents alone; documentation links verified

### REL-001 — Define JarzRover 1.0 feature scope

- [ ] @jarvis414-bot and @jarzlabs24 record approved included/deferred features and measurable release thresholds
- [x] Decide Android app identity, robot distribution, package ID, temporary support contact, audience and account needs
- [ ] Decide minimum Android version and explicit sonar/Blockly release scope against installed hardware and tests; Creature Lab is in 1.0 but stays disabled in Play until its service/privacy gate passes

### PLAY-001 — Set up Google Play Console

- [x] Choose organization account type and legal/representative identity; complete D-U-N-S and applicable identity/organization verification
- [ ] Create app record matching agreed package identity and configure access/tester roles
- [ ] Record account-specific current testing/production eligibility requirements and secure account recovery ownership

### REL-002 — Establish develop and release/1.0 workflow

- [ ] Inspect jarz-development, master and remote branches before mapping proposed main/develop/release/1.0 roles; preserve existing work
- [ ] Document feature PRs, release selection, fixes returned to development, tagging and review ownership
- [ ] Configure agreed branch protection and verify workflow triggers against actual branch names

### REL-003 — Audit dependencies, models and licenses

- [ ] Inventory Android/iOS dependencies, native libraries, OpenBot ancestry, models, datasets, icons and fonts with versions and provenance
- [ ] Verify actual redistribution terms including YOLO and dataset attribution; create docs/THIRD_PARTY_LICENSES.md and required notices without assuming chat license claims
- [ ] Resolve release-blocking license/security findings and verify notices survive packaging

### REL-004 — Remove secrets and development artifacts

- [ ] Scan tracked files and history without printing secret values; classify public service configuration separately from secrets
- [ ] Remove inappropriate artifacts and personal paths; update ignores; rotate exposed credentials through their provider
- [ ] Document secure signing/credential storage and clean scan evidence; any coordinated history rewrite is a separate reviewed operation

### REL-005 — Document reproducible Android build

- [ ] Create docs/BUILD_ANDROID.md with verified JDK/Gradle/AGP/SDK/NDK versions, model downloads/checksums and local configuration
- [ ] Build robot debug from a clean environment and record exact revision, commands, outputs and unresolved failures
- [ ] Document controller build only if included in REL-001; no personal absolute paths or embedded credentials

### AND-001 — Upgrade Android target and compile SDK for Play

- [ ] Verify current official Play requirements at implementation; select supported AGP/Gradle/JDK/SDK versions and document sources/date
- [ ] Migrate current compile 33/target 32 and validate native library/ABI and page-size compatibility where required
- [ ] Build and test permissions, camera, USB and lifecycle behavior on minimum and current supported Android; record regressions

### AND-002 — Create production release configuration

- [ ] Apply agreed JarzRover identity, icons and version/build numbering without incidental source namespace changes
- [ ] Remove development endpoints/banners and sensitive verbose logs; explicitly decide production feature flags and R8
- [ ] Enable meaningful release lint, build release variant and smoke-test packaged models/native libraries

### AND-003 — Configure signing and Android App Bundle

- [ ] Configure upload signing and Play App Signing with credentials outside Git; record backup/recovery ownership
- [ ] Produce signed release AAB with correct application ID and monotonic version code
- [ ] Verify bundle install behavior and document reproducible release commands and artifact hash

### AND-004 — Audit permissions and SDK privacy behavior

- [ ] Inventory manifest and merged-manifest permissions and Firebase/Auth/Firestore/Storage/Analytics/Crashlytics behavior
- [ ] Remove unused capabilities or document purpose, consent, retention and network behavior for retained features
- [ ] Test permission denial/revocation and offline operation; provide findings to REL-007

### AND-005 — Add reviewer and hardware-free demo mode

- [ ] Launch without a robot and show useful setup/disconnected states without crashes
- [ ] Provide clearly identified demo/camera workflow that cannot actuate motors
- [ ] Document reviewer steps and hardware-dependent limitations; arrange demonstration resources where review requires them

### AND-006 — Harden lifecycle and communication failure recovery

- [ ] Define and enforce bounded command expiry and STOP on communication loss, target loss and background transition
- [ ] Handle camera/model initialization errors, malformed messages, cable removal, reconnect and app restart without stale motor commands
- [ ] Record unit/integration evidence and physical fail-safe results with firmware revision; escalate any required watchdog change explicitly

### REL-007 — Document privacy, audience and public support

- [ ] Create docs/PRIVACY.md mapping actual camera, storage, transport, account, analytics and third-party SDK data flows
- [ ] Publish matching privacy policy/support pages; document retention/deletion, audience decision and account-deletion flow if applicable
- [ ] Prepare evidence-backed Play Data Safety and Apple privacy answers; do not claim no collection until verified

### REL-008 — Align continuous integration with release workflow

- [ ] Reuse existing workflows; fix actual branch/path triggers and valid style tasks
- [ ] Demonstrate PR compile, lint and meaningful unit tests plus secret/dependency checks on the selected branch
- [ ] Document artifact retention and protected credentials; no automatic store publishing

### AI-001 — Stabilize colored-ball inference

- [ ] Version model, labels, checksum, preprocessing and confidence thresholds; verify model/dataset provenance
- [ ] Evaluate varied lighting, distances, backgrounds, distractors and no-target frames against agreed metrics
- [ ] Record latency/FPS/memory/thermal behavior on target phones and missing/corrupt model handling

### AI-002 — Harden red, green and blue behaviors

- [ ] Agree color-to-action mapping and Recognition/RobotCommand interface including timestamp, confidence, bounds and command expiry
- [ ] Verify green centering/approach/stopping and agreed red/blue behavior, including ambiguous/stale/lost detections and bounded motor output
- [ ] Document sonar availability explicitly; validate agreed stopping criteria on actual hardware without changing pin mappings incidentally

### AI-003 — Add regression tests for behavior logic

- [ ] Extend existing test suite with color mapping, stale/absent targets, motor limits, transition and stop cases
- [ ] Use deterministic recognition fixtures independent of camera/UI where practical
- [ ] Demonstrate tests catch incorrect behavior; document command and results without claiming physical tests from unit tests

### QA-001 — Create and execute physical rover release checklist

- [ ] Create docs/RELEASE_CHECKLIST.md with device/OS/app/firmware/hardware matrix and agreed pass thresholds
- [ ] Record launch, camera, Nano handshake, manual motors, color behaviors, disconnect/reconnect, background, kill/restart, missing model and permission denial results
- [ ] Test sonar only when installed/enabled and in scope; profile sustained operation; record evidence in docs/TEST_LOG.md and link all blockers

### PLAY-002 — Distribute internal and closed testing release

- [ ] Upload verified signed AAB to internal testing and confirm tester installation
- [ ] Complete applicable listing, Data Safety, rating, audience and app-access declarations from actual release behavior
- [ ] Run required closed testing if applicable, collect feedback and pre-launch findings, and link fixes and eligibility evidence

### PLAY-003 — Submit Android 1.0 and prepare rollout support

- [ ] Resolve release blockers and complete applicable production-access requirements
- [ ] Finalize screenshots, description, privacy/support URLs, reviewer instructions and release notes matching shipped scope
- [ ] @jarvis414-bot submits approved candidate; record submission/result, release tag, staged rollout and halt/hotfix plan; monitor initial crashes

### IOS-001 — Decide iPhone-to-rover communication architecture

- [ ] Audit existing ios/OpenBot and Flutter controller code before choosing reuse or port
- [ ] Compare supported BLE/Wi-Fi/accessory approaches against actual Nano hardware; verify platform/accessory constraints from current official sources
- [ ] Record architecture, hardware changes, protocol, camera/inference approach and POC pass criteria in docs/ARCHITECTURE.md

### IOS-002 — Build connectivity and vision proof of concept

- [ ] Run camera and versioned ball model on a real supported iPhone
- [ ] Send bounded control commands to actual rover and prove response, STOP on loss and reconnect
- [ ] Record device/OS/firmware, latency and limitations; make explicit go/no-go decision before production investment

### IOS-003 — Establish TestFlight pipeline and App Store submission

- [ ] Configure secure signing/provisioning and reproducible archive with correct bundle/version/build identity
- [ ] Upload to App Store Connect and validate TestFlight installs; complete applicable external beta review and address feedback
- [ ] @jarvis414-bot submits approved candidate with review notes; record outcome and release/hotfix process without claiming approval from upload alone

### IOS-004 — Prepare iOS production application and review package

- [ ] Reuse validated code, implement agreed identity/features, permissions, lifecycle recovery and hardware-free reviewer workflow
- [ ] Create docs/BUILD_IOS.md; validate supported iPhones, privacy manifests/SDK requirements, account deletion if applicable and physical release checklist
- [ ] Prepare App Store Connect identity, screenshots, privacy/age/export declarations, support URLs and review resources from actual app behavior

### AI-004 — Prototype creature generation after 1.0

- [ ] Keep experiment outside release/1.0 unless @jarvis414-bot and @jarzlabs24 explicitly approve promotion
- [ ] Specify object-to-creature experience, model/service licensing, image retention and any cloud transmission/cost
- [ ] Demonstrate bounded prototype and document results, privacy implications and next feature decision

## Starting work

Finish verifying REL-006 documentation setup, then take REL-001. REL-004 can be prepared independently. Do not mark platform, privacy, licensing or physical testing tasks complete from this planning pass. Future tasks should reuse these IDs/issues; search all issue states and PRs before adding a follow-up.

## Preserved JR planning cross-reference

A concurrent task added [the AI-agent workflow](CODEX_WORKFLOW.md) and [the JR backlog](plans/app-store-readiness/BACKLOG.md) during this setup. Those files are preserved. Their statements that GitHub issues are not created describe the earlier planning snapshot. Use the REL/AND/AI/QA/PLAY/IOS issues above for live execution; do not create duplicate JR issues. Retain useful additional JR acceptance details for the applicable selected app. Milestone numbering differs between snapshots; GitHub M0–M9 is the execution grouping. Branch names in both plans remain proposals to reconcile under REL-002, not adopted settings.

| Preserved planning ID | GitHub execution coverage |
| --- | --- |
| JR-001 | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2) |
| JR-002 | [REL-005 (#6)](https://github.com/jarzlabs24/JarzRover-Private/issues/6), [IOS-001 (#16)](https://github.com/jarzlabs24/JarzRover-Private/issues/16), [IOS-004 (#25)](https://github.com/jarzlabs24/JarzRover-Private/issues/25) |
| JR-003 | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2), [AND-002 (#8)](https://github.com/jarzlabs24/JarzRover-Private/issues/8), [PLAY-001 (#15)](https://github.com/jarzlabs24/JarzRover-Private/issues/15), [IOS-004 (#25)](https://github.com/jarzlabs24/JarzRover-Private/issues/25) |
| JR-004 | [AND-001 (#7)](https://github.com/jarzlabs24/JarzRover-Private/issues/7), [AND-002 (#8)](https://github.com/jarzlabs24/JarzRover-Private/issues/8), [AND-004 (#9)](https://github.com/jarzlabs24/JarzRover-Private/issues/9) |
| JR-005 | [IOS-001 (#16)](https://github.com/jarzlabs24/JarzRover-Private/issues/16), [IOS-002 (#17)](https://github.com/jarzlabs24/JarzRover-Private/issues/17), [IOS-004 (#25)](https://github.com/jarzlabs24/JarzRover-Private/issues/25) |
| JR-006 | [AND-003 (#20)](https://github.com/jarzlabs24/JarzRover-Private/issues/20), [IOS-003 (#26)](https://github.com/jarzlabs24/JarzRover-Private/issues/26) |
| JR-007 | [REL-004 (#5)](https://github.com/jarzlabs24/JarzRover-Private/issues/5), [AND-004 (#9)](https://github.com/jarzlabs24/JarzRover-Private/issues/9) |
| JR-008 | [REL-007 (#18)](https://github.com/jarzlabs24/JarzRover-Private/issues/18), [AND-004 (#9)](https://github.com/jarzlabs24/JarzRover-Private/issues/9) |
| JR-009 | [REL-003 (#4)](https://github.com/jarzlabs24/JarzRover-Private/issues/4) |
| JR-010 | [REL-008 (#19)](https://github.com/jarzlabs24/JarzRover-Private/issues/19), [IOS-003 (#26)](https://github.com/jarzlabs24/JarzRover-Private/issues/26) |
| JR-011 | [QA-001 (#22)](https://github.com/jarzlabs24/JarzRover-Private/issues/22), [IOS-004 (#25)](https://github.com/jarzlabs24/JarzRover-Private/issues/25) |
| JR-012 | [AND-005 (#10)](https://github.com/jarzlabs24/JarzRover-Private/issues/10), [PLAY-002 (#23)](https://github.com/jarzlabs24/JarzRover-Private/issues/23), [IOS-004 (#25)](https://github.com/jarzlabs24/JarzRover-Private/issues/25) |
| JR-013 | [PLAY-002 (#23)](https://github.com/jarzlabs24/JarzRover-Private/issues/23), [IOS-003 (#26)](https://github.com/jarzlabs24/JarzRover-Private/issues/26) |
| JR-014 | [AI-001 (#11)](https://github.com/jarzlabs24/JarzRover-Private/issues/11), [AI-002 (#12)](https://github.com/jarzlabs24/JarzRover-Private/issues/12), [AI-003 (#13)](https://github.com/jarzlabs24/JarzRover-Private/issues/13), [QA-001 (#22)](https://github.com/jarzlabs24/JarzRover-Private/issues/22) |
| JR-015 | [AI-004 (#14)](https://github.com/jarzlabs24/JarzRover-Private/issues/14) |
| JR-016 | [REL-001 (#2)](https://github.com/jarzlabs24/JarzRover-Private/issues/2), [REL-002 (#3)](https://github.com/jarzlabs24/JarzRover-Private/issues/3), [QA-001 (#22)](https://github.com/jarzlabs24/JarzRover-Private/issues/22) |
| JR-017 | [PLAY-003 (#24)](https://github.com/jarzlabs24/JarzRover-Private/issues/24), [IOS-003 (#26)](https://github.com/jarzlabs24/JarzRover-Private/issues/26) |
