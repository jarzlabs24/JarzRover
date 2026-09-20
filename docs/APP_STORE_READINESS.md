# JarzRover app-store readiness

> **Status: deferred on 2026-09-19.** JarzRover is currently being prepared as an open-source project, not as a Google Play or Apple App Store submission. This document preserves completed research and prior decisions for a future restart. The active plan is [OPEN_SOURCE_READINESS](OPEN_SOURCE_READINESS.md).

Planning baseline: 2026-09-07. Source: JarzRover Bot Design and Testing (conversation `6a6f8d1e-a238-83ea-902c-71b13ec9e8f6`). Read with [project context](PROJECT_CONTEXT.md), [execution backlog](RELEASE_BACKLOG.md) and [handoff template](CODEX_HANDOFF.md).

## Inspected repository facts

- Private repository: `jarzlabs24/JarzRover-Private`; checkout `/Users/naturetracker/Code/3DPrint/OpenBot`, branch `jarz-development`, inspected commit `27ea32b`. GitHub default branch is also `jarz-development`; the local remote HEAD alias was stale. No open/closed issues, milestones or open PRs existed during initial inspection; standard labels and an execution issue template already existed.
- Existing AGENTS, PROJECT_CONTEXT, HARDWARE, WIRING and TEST_LOG capture working DIY/Nano context. Preserve them. Integrated sonar and end-to-end ball stopping are not established by historical standalone tests.
- Before the branding implementation, `android/robot/build.gradle` used application ID `org.openbot`, compile SDK 33, target SDK 32, min SDK 21, Java/Kotlin target 17; release minification and release lint checks were disabled. The JarzRover branding branch changes the application ID to `com.jarzlabs.jarzrover` and adds explicit Maker Faire and Play distributions. Root Android AGP remains 7.4.2. Build results must be recorded separately.
- Firebase authentication, storage, Firestore, analytics and Crashlytics dependencies exist. Actual release data flows must be audited before claiming on-device-only/no collection.
- `ios/OpenBot` and Flutter controller code already exist. Audit reuse and hardware compatibility before assuming a new app or a working iPhone-to-Nano path.
- Existing Gradle CI targets `master`. Reconcile it with the chosen workflow; do not add duplicate pipelines. Existing GameController/Vehicle tests are a starting point, not evidence of complete ball regression coverage.

## Product and ownership decisions

Dad owns release engineering, platform compatibility, accounts, privacy, signing and submission. Aarav owns inference, behavior algorithms and later experiments. Both validate hardware and agree the final scope.

The selected Android product is the native robot app named **JarzRover**, published under **JARzLabs**, application ID `com.jarzlabs.jarzrover`, and audience 13+. Candidate Android 1.0 scope is connection, manual drive, diagnostics, camera, colored-ball behavior, setup and safe recovery. Sonar requires installed/enabled hardware and integrated evidence; Blockly is conditional on stability. Creature Lab is in the 1.0 product scope but is disabled in the Play distribution until its reliable HTTPS service and privacy disclosures are ready; it remains enabled in the Maker Faire distribution. Google sign-in, OpenBot Playground/cloud projects, and Google Drive saving are excluded from 1.0. OpenBot attribution belongs in About and packaged notices.

The intended Play developer identity is an organization profile for Aarambh LLC (DBA JARzLabs), with Mukti Patel as authorized representative. `jarzlabs24@gmail.com` is the temporary business/support contact and may be replaced before submission. The user plans to request a D-U-N-S number for Aarambh LLC; the request and verification remain external dependencies.

Keep the current directory layout. Add supporting documents/assets when their implementation issue has real content; do not move firmware or models to match an illustrative tree.

## Milestones and exit gates

| Group | Owner | Exit gate |
| --- | --- | --- |
| M0 Repo workflow | Dad | Context, issue map and repeatable Codex handoff available |
| M1 Release scope | Dad + Aarav agreement | Explicit included/deferred features and acceptance thresholds |
| M2 Repo hardening | Dad | Branch workflow, license/secrets review, reproducible debug build, account setup |
| M3 Android production | Dad | Compatible signed release, privacy evidence, failure recovery, reviewer path and CI |
| M4 Feature stabilization | Aarav / Both for QA | Inference/behavior regression coverage and physical release evidence |
| M5 Google Play beta | Dad | Internal/required closed testing, feedback and eligibility evidence |
| M6 Android 1.0 | Dad | Submission outcome, release record and rollout/support plan |
| M7 iOS POC | Both | Real iPhone camera/inference/control/reconnect and fail-safe evidence |
| M8 iOS production | Dad | Production application, TestFlight validation and submission outcome |
| M9 Feature 1.1+ | Aarav | Isolated creature prototype and decision on future scope |

Milestones group outcomes; dependencies in issues determine readiness. iOS exploration can start alongside Android work. Proposed future branches are main for released code, develop for integration, release/1.0 for stabilization and feature branches for experiments. REL-002 must map these roles to existing branches before creating or renaming anything. Return stabilization fixes to development and select only accepted features for release.

## Execution sequence

1. Freeze scope and identity (REL-001). Audit OpenBot/library/model/dataset/asset provenance and required attribution (REL-003); previous chat claims about dataset licensing are unverified until this audit. Resolve release-blocking findings.
2. Scan secrets/artifacts safely, rotate exposed credentials and document secure storage (REL-004). Record exact tools, model hashes and clean-build steps in BUILD_ANDROID (REL-005). Reconcile branch/CI workflows (REL-002/008).
3. Upgrade Android compatibility (AND-001), production identity/logging/lint/configuration (AND-002), and secure signing/AAB generation (AND-003). Evaluate native dependency compatibility as part of the upgrade.
4. Audit permissions, SDK traffic, accounts, image storage, telemetry and retention (AND-004). Produce PRIVACY and public policy/support pages (REL-007). Decide target audience and applicable family/children requirements from actual positioning; no unverified no-data or no-upload claims.
5. Version inference assets and define a stable interface: recognition class/confidence/bounds/timestamp into behavior logic; bounded motor commands with expiry out. Aarav stabilizes color behavior and meaningful regression tests (AI-001/002/003). Dad handles camera/transport/lifecycle failures and STOP on loss (AND-006). No stale commands should resume after reconnect.
6. Provide clear disconnected/setup and labeled demo experiences (AND-005). Demo mode must not actuate motors; reviewer instructions identify remaining hardware-dependent functions.
7. Run QA-001 against exact candidate app/firmware/device/hardware revisions. Cover permission refusal, missing models, camera failure, manual/color behavior, disconnect, reconnect, app background/restart and sustained performance. Agree numerical thresholds before testing; document failures and unrun checks in TEST_LOG. Do not substitute demo/unit tests for physical evidence.
8. Set up accurate developer identity (PLAY-001); prepare store graphics/screenshots/descriptions, audience/rating/Data Safety, app access, support/policy and release notes. Distribute internal and any applicable closed tests (PLAY-002), resolve findings, then submit and record production outcome (PLAY-003). Keep a release tag/artifact hash, rollout halt/hotfix process and support owner.
9. Audit iOS code and select a supported transport (IOS-001); prove it on real hardware with inference and connection-loss stopping (IOS-002). Then complete production features, BUILD_IOS, permissions/privacy/SDK requirements and reviewer resources (IOS-004). Configure signing/archive, App Store Connect metadata, TestFlight and submission (IOS-003). Upload is not approval.
10. Keep Creature Lab gated by distribution until its model/service license, privacy, reliability and cost decisions are complete; promotion into the Play build requires recorded evidence.

## Evidence and submission rules

Supporting deliverables belong to their issues: BUILD_ANDROID (REL-005), THIRD_PARTY_LICENSES and notices (REL-003), PRIVACY/public pages (REL-007), RELEASE_CHECKLIST (QA-001), ARCHITECTURE (IOS-001), BUILD_IOS (IOS-004), store assets/release notes (PLAY-002/003 and IOS-004/003). Do not claim these documents exist until created.

A release candidate needs a reproducible signed artifact, verified scope, resolved blocking findings, current policy evidence, accurate metadata, a physical test record and reviewer access resources. Every build increments its platform build number. Dad records the submission decision and outcome; this backlog setup does not submit or publish an app.

Official sources checked again on 2026-09-12; recheck at submission:

- [Google Play target API requirements](https://support.google.com/googleplay/android-developer/answer/11926878): since 2026-08-31, new phone/tablet apps and updates must target Android 16/API 36 or higher. The current target 32 is therefore a release blocker handled by AND-001.
- [Google Play organization account information](https://support.google.com/googleplay/android-developer/answer/13628312): an organization profile requires a D-U-N-S number plus matching organization name/address, organization phone and website, authorized contact details, and verified public developer email/phone. Google recommends official organization email addresses; replace the temporary Gmail address before verification if practical.
- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) and [review preparation](https://developer.apple.com/app-store/review/): reviewer access can require additional hardware/resources beyond a demo. Plan for those resources.

No Android/iOS build or physical robot test was performed for this documentation setup. Existing historical results retain their original limitations.
