# App-store readiness backlog

Revision 1 — 2026-09-06. Stable local IDs; no GitHub issues posted. Human owner names must be mapped to actual accounts when posting. All tasks have GitHub URL: not created; evidence: not yet recorded. Ready means scoped enough to start discovery, not that all decisions are settled. See [plan](PLAN.md) and [workflow](../../CODEX_WORKFLOW.md).

## JR-001 — Choose shipping apps and v1 scope

- Owner: @jarvis414-bot
- Milestone: M0
- Status: Ready
- Dependencies: none
- Suggested branch: jarvis414-bot/JR-001-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Compare all four app roles from the audit; record platform matrix, included/excluded features, audience, monetization and launch sequencing.

**Acceptance / validation:**

- [ ] @jarvis414-bot records one explicit shipping matrix; @jarzlabs24 confirms feature boundaries; unresolved product choices have an owner and block dependent changes.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.
## JR-002 — Establish repository and build baseline

- Owner: @jarvis414-bot
- Milestone: M0
- Status: Ready
- Dependencies: none
- Suggested branch: jarvis414-bot/JR-002-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Verify private repository visibility, live default branch, branch divergence and preserved second-Mac work; record JDK/SDK/Flutter/Xcode/CocoaPods versions and build commands for candidate apps.

**Acceptance / validation:**

- [ ] Record actual build/test outcomes and failures with commit and environment; record explicit PR base; no history discarded and no existing failure hidden.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-003 — Finalize identity and store ownership

- Owner: @jarvis414-bot
- Milestone: M1
- Status: Todo
- Dependencies: 001
- Suggested branch: jarvis414-bot/JR-003-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Inventory existing store registrations before changing IDs; decide distinct app IDs, names, versions, icons, support/privacy URLs and developer account owner.

**Acceptance / validation:**

- [ ] Chosen IDs match console records and build outputs for each selected app; migration impact reviewed; version/build numbering and support owner documented.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-004 — Prepare selected Android apps

- Owner: @jarvis414-bot
- Milestone: M1
- Status: Todo
- Dependencies: 001,002,003
- Suggested branch: jarvis414-bot/JR-004-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Check current Play target/API and native-library requirements; upgrade selected modules incrementally; examine permissions, exported components, storage, background behavior, ABI/native dependencies and release lint.

**Acceptance / validation:**

- [ ] Selected apps build release AABs, pass meaningful lint/tests or documented resolved exceptions, and work on supported physical Android versions; current requirements cited and mapped to evidence.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-005 — Validate iOS role and platform readiness

- Owner: @jarvis414-bot
- Milestone: M1
- Status: Todo
- Dependencies: 001,002,003
- Suggested branch: jarvis414-bot/JR-005-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Prove intended robot/controller connectivity on physical iPhone; reconcile deployment targets, dependencies, entitlements and usage descriptions; verify current Xcode/SDK submission requirements.

**Acceptance / validation:**

- [ ] Document supported transport and device/OS matrix; selected app builds/tests and archives; denial/background/reconnect cases pass; no unsupported USB parity claims.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-006 — Configure production signing and artifacts

- Owner: @jarvis414-bot
- Milestone: M1
- Status: Todo
- Dependencies: 003,004,005 (selected platforms only)
- Suggested branch: jarvis414-bot/JR-006-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Replace debug signing for selected Flutter Android release and remove native controller release debugging if shipped; establish upload keys, Apple team/profiles and secure credential storage/recovery.

**Acceptance / validation:**

- [ ] Inspect signed release outputs for identity/version and non-debug configuration; install/test distributable builds; no private keys or passwords committed; recovery owner recorded.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-007 — Audit service configuration and secrets

- Owner: @jarvis414-bot
- Milestone: M1
- Status: Todo
- Dependencies: 001,002
- Suggested branch: jarvis414-bot/JR-007-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Map Firebase, network endpoints, analytics/crash reporting and generation services actually used; inspect tracked configuration and history with redacted secret scanning; separate development/production access.

**Acceptance / validation:**

- [ ] Each service has an owner/environment and least-needed access; sensitive findings remediated without printing secrets; any exposed credential rotated; retention/security rules and release configuration verified.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-008 — Implement privacy and audience requirements

- Owner: @jarvis414-bot
- Milestone: M1
- Status: Todo
- Dependencies: 001,007
- Suggested branch: jarvis414-bot/JR-008-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Trace camera, microphone, local network, images, identifiers, analytics, accounts and deletion flows; decide child-directed scope; check current official store privacy/account/AI rules applicable to selected features.

**Acceptance / validation:**

- [ ] Data inventory matches runtime observations and SDK behavior; permission denial works; required consent/deletion controls tested; policy URL and Play Data safety/Apple privacy declarations agree with behavior.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-009 — Preserve attribution and review dependencies

- Owner: @jarvis414-bot
- Milestone: M1
- Status: Todo
- Dependencies: 001,002
- Suggested branch: jarvis414-bot/JR-009-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Inventory OpenBot code, models, datasets, fonts, media and new packages; retain LICENSE/notices and confirm redistribution/use rights for shipped assets.

**Acceptance / validation:**

- [ ] Create docs/THIRD_PARTY_LICENSES.md with versions/sources/licenses and required notices; resolve unknown rights before shipping; private repo status is not treated as a license exemption.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-010 — Make CI cover the chosen workflow

- Owner: @jarvis414-bot
- Milestone: M2
- Status: Todo
- Dependencies: 002,004,005 (selected platforms only)
- Suggested branch: jarvis414-bot/JR-010-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Adapt existing workflows to agreed integration/release PR bases; add selected Flutter coverage and actual iOS builds/tests; preserve dependency locks; separate debug checks from signed release jobs.

**Acceptance / validation:**

- [ ] PR checks run on intended branches, fail on real errors and produce traceable artifacts; no secret exposure from untrusted PRs; published debug APK workflow cannot be mistaken for store release evidence.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-011 — Run release acceptance on devices and rover

- Owner: @jarvis414-bot
- Milestone: M2
- Status: Todo
- Dependencies: 004,005,006,008
- Suggested branch: jarvis414-bot/JR-011-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Create docs/TESTING.md covering install/upgrade, onboarding, permissions denied, connect/reconnect, disconnect, stop, background/lock, offline operation, accessibility, latency and prolonged use; confirm flashed firmware and hardware.

**Acceptance / validation:**

- [ ] Record actual matrix/results in TEST_LOG.md with build/firmware/configuration; stop and connection-loss behavior meet documented thresholds; no unresolved release-blocking defects.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-012 — Prepare store listings and reviewer instructions

- Owner: @jarvis414-bot
- Milestone: M3
- Status: Todo
- Dependencies: 001,003,008,009
- Suggested branch: jarvis414-bot/JR-012-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Create store-assets/google-play and store-assets/apple only for selected apps; prepare actual screenshots, icon, descriptions, age/content ratings, support URLs, hardware requirements and review demo/access instructions.

**Acceptance / validation:**

- [ ] All claims match release behavior; current official metadata/review requirements checked; reviewer can exercise app with documented hardware/demo approach; policy/support links work and assets are final.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-013 — Distribute and validate beta builds

- Owner: @jarvis414-bot
- Milestone: M3
- Status: Todo
- Dependencies: 010,011,012,016
- Suggested branch: jarvis414-bot/JR-013-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** Use selected platform beta channels after authorization; verify current account-specific testing eligibility/requirements; gather tester feedback and triage defects against release commit.

**Acceptance / validation:**

- [ ] Document signed artifact identity, tester/device results, required testing completion and fixed blockers; repeat affected checks after fixes; record release go/no-go.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-014 — Prove ball detection and rover behavior

- Owner: @jarzlabs24
- Milestone: F1
- Status: Todo
- Dependencies: 002
- Suggested branch: jarzlabs24/JR-014-task
- Suggested labels: app-store-readiness, owner:jarzlabs24
- GitHub URL: not created

**Scope:** Locate actual mobile detection/control path, distinguish tests/colorBalls.js from production; define detection, centering, approach, stopping and target-loss criteria before implementation; confirm hardware with @jarvis414-bot.

**Acceptance / validation:**

- [ ] Measured results across lighting, distances, distractors and target loss meet agreed thresholds; manual stop/disconnect verified; app/firmware/config recorded; changes stay isolated until JR-016.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-015 — Define and integrate object-to-creature experience

- Owner: @jarzlabs24
- Milestone: F2
- Status: Todo
- Dependencies: 002
- Suggested branch: jarzlabs24/JR-015-task
- Suggested labels: app-store-readiness, owner:jarzlabs24
- GitHub URL: not created

**Scope:** Inspect tools/creature-lab demo and choose actual mobile integration; decide local/cloud generation, inputs/outputs, persistence, latency/cost limits and audience-appropriate behavior with @jarvis414-bot.

**Acceptance / validation:**

- [ ] Mobile happy/error/offline/cancel paths tested; object images/data handled as specified; no embedded provider secrets; rights and privacy reviewed; demo alone not marked mobile-ready.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-016 — Gate feature promotion into release

- Owner: @jarvis414-bot
- Milestone: M2
- Status: Todo
- Dependencies: 001; 014/015 only if included
- Suggested branch: jarvis414-bot/JR-016-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** With @jarzlabs24, choose include/defer for each feature; review protocol, permissions, data and dependency changes; verify disabled features are inaccessible and absent from store claims.

**Acceptance / validation:**

- [ ] Record include/defer matrix and commits; included features meet acceptance and reopen affected privacy/device tests; deferred work does not block minimal release; release branch cut from tested integration commit.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.

## JR-017 — Submit, respond and operate release

- Owner: @jarvis414-bot
- Milestone: M4
- Status: Todo
- Dependencies: 013
- Suggested branch: jarvis414-bot/JR-017-task
- Suggested labels: app-store-readiness, owner:jarvis414-bot
- GitHub URL: not created

**Scope:** After explicit submission authorization, submit selected apps; track review questions/rejections and version changes; prepare phased rollout, support triage and recovery procedure.

**Acceptance / validation:**

- [ ] Store outcome recorded separately per app; affected fixes retested; released version/artifact and support owner recorded; rollout halt/recovery or forward-fix procedure documented without assuming store binary rollback is available.
- [ ] Record evidence, remaining gaps and completed handoff; update status after review.
