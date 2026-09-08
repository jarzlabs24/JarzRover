# JarzRover app-store readiness plan

Revision 1 — 2026-09-06. Planning workflow established; implementation and submission not started by this setup. Dad owns release readiness; Aarav owns feature development. Source and verified baseline: [inspection](REPOSITORY_AUDIT.md). Tasks: [backlog](BACKLOG.md). Execution: [workflow](../../CODEX_WORKFLOW.md).

## Release scope decision

Decide the product matrix before branding or signing changes: Android robot app, Android controller (native versus Flutter), iOS controller, and/or native iOS robot app. A cross-platform controller is not the same as a cross-platform robot brain. Prove iPhone-to-robot connectivity on intended hardware; do not assume Android USB OTG support transfers to iOS. Recommend a minimal verified control/connect/disconnect/stop release, with ball and creature features admitted only after their gates pass. Dad must confirm that recommendation and whether Android/iOS ship together or independently.

JarzRover name, JarzLabs brand, 1.0.0 and com.jarzlabs.jarzrover are planning candidates. Record actual chosen identifiers per distinct app, store ownership, countries, audience, minimum OS versions, support contact, privacy/support URLs and monetization in JR-001/003. Kit pricing is separate from app pricing and entitlements.

## Milestones and exit evidence

| Milestone | Owner | Depends on | Exit gate |
| --- | --- | --- | --- |
| M0 — Scope and baseline | Dad; Aarav consults | none | JR-001/002 done; shipping matrix and repeatable baseline with actual failure inventory |
| M1 — Platform and service readiness | Dad | M0 | JR-003–009 done for every selected app; identity, connectivity, signing, data and licenses documented |
| M2 — Verified release candidate | Dad; Aarav feature tests | M1 | JR-010/011 done, selected feature gates passed; tested commit recorded before release branch cut |
| M3 — Beta and store package | Dad | M2 | JR-012/013 done; signed artifacts tested, metadata accurate, reviewer access usable |
| M4 — Submission and support | Dad | M3 | JR-017 done; store responses handled, release monitoring and recovery documented |
| F1 — Ball behavior | Aarav | JR-002 and hardware confirmation | JR-014 accepted or explicitly deferred from release |
| F2 — Creature experience | Aarav | JR-002 and generation/data decision | JR-015 accepted or explicitly deferred from release |

Milestones are evidence gates, not calendar promises. Sequence Dad's M0/M1 work alongside Aarav's isolated experiments; integrate features through JR-016 only when ready. If a feature changes permissions, data flows, dependencies or robot protocol, reopen affected release checks. If one platform blocks, Dad records a deliberate split-release decision rather than marking both ready.

## Release evidence and definition of done

For each chosen app retain build commit, toolchain/lockfile versions, package/bundle ID, version/build number, artifact digest/location, signing identity reference (no private keys), OS/device matrix, firmware version, test results, privacy inventory version and store metadata revision. A task is Done only with acceptance evidence or a documented scope decision making it inapplicable. A proposed test is not a pass.

Store requirements change: JR-004/005/008/012 must check current official Android/Google Play and Apple guidance at execution time and record source URL, date, requirement and how the selected app satisfies it. Do not treat SDK numbers from this inspection or old upstream READMEs as submission requirements.

## Open decisions and risks

- Which apps ship, and what is the iOS role? Dad, JR-001/005.
- Which GitHub branch becomes the verified default? Dad, JR-002; preserve import work.
- Which account/entity owns stores, signing and backend services? Dad, JR-003/006/007.
- Target audience, child-directed use, accounts, uploaded images, cloud generation and monetization? Dad with Aarav, JR-001/008/015.
- Physical configuration, safe stop/target-loss behavior and feature maturity lack current acceptance evidence. Aarav with Dad, JR-011/014.
- Existing CI does not establish release readiness. Dad, JR-010.

## Change record

2026-09-06: Added execution workflow and issue-ready backlog; retained existing code layout and history. No app IDs, branches, settings, code, signing material or store records changed.
