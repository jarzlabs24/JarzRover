# JarzRover operating instructions

JarzRover is the OpenBot-based robotics implementation project within JarZLabs, a youth-run STEM and 3D-printing project.

Before editing, read [docs/PROJECT_CONTEXT.md](docs/PROJECT_CONTEXT.md). For hardware or firmware work, also read [docs/HARDWARE.md](docs/HARDWARE.md), [docs/WIRING.md](docs/WIRING.md), and [docs/TEST_LOG.md](docs/TEST_LOG.md).

- Preserve the working OPENBOT DIY configuration and pin mappings. Do not change wiring assumptions incidentally to a software change.
- Prefer small, testable changes. Explain changes in plain language that youth project members can follow.
- Document hardware-impacting changes: affected pins, wiring, power, feature flags, expected behavior, and validation. Resolve discrepancies between these notes, source code, and the physical robot before changing hardware assumptions.
- Match optional feature flags to installed hardware. A declared pin does not mean its feature is enabled; sonar is currently disabled in the checked-in DIY configuration.
- Run checks appropriate to the change. Record actual results and limitations in TEST_LOG.md; never present a proposed or user-reported test as one you ran.
- Keep durable decisions and current status in PROJECT_CONTEXT.md, hardware details in HARDWARE.md, and connection changes in WIRING.md.
- Current focus: OpenBot object navigation and green-ball detection, centering, approach, and stopping. End-to-end completion is not yet established in these records.

Shared-context workflow: JarZLabs holds broader planning and discussion; this repository holds implementation context. Carry relevant decisions from ChatGPT into these documents, and share an updated context summary back with JarZLabs when needed. These files are the maintained handoff, not an automatic chat-history synchronization mechanism.

## App-store and planning execution

Read [docs/CODEX_WORKFLOW.md](docs/CODEX_WORKFLOW.md) for planning handoffs and branch conventions. For release work read [the readiness plan](docs/plans/app-store-readiness/PLAN.md) and [backlog](docs/plans/app-store-readiness/BACKLOG.md). Dad owns store readiness; Aarav owns ball/creature features. Preserve existing hardware guidance above.

- Inspect current branch, status and remote before changes; retain unrelated work and second-Mac history. The integration baseline is jarz-development, while cached origin/HEAD currently points to the import branch; verify before choosing a task base.
- Keep tasks bounded by stable JR IDs and acceptance criteria. Update status/evidence and return a completed handoff. Do not equate chat suggestions with approved product decisions.
- Identify the selected app before changing IDs, signing or shared code: native robot apps and Flutter controller are distinct products. Preserve OpenBot attribution and existing code layout.
- Keep private signing material and service credentials out of tracked files and handoffs. Use the private origin for authorized publication; public-fork and upstream are separate destinations.

## App-store execution and Codex handoff

For release work, read [APP_STORE_READINESS](docs/APP_STORE_READINESS.md), [RELEASE_BACKLOG](docs/RELEASE_BACKLOG.md) and [CODEX_HANDOFF](docs/CODEX_HANDOFF.md) after PROJECT_CONTEXT. GitHub issues track execution status; the backlog maps stable task IDs to those issues. Preserve the existing hardware context above.

- Dad owns platform/release/privacy/signing/store work; Aarav owns models and behaviors; `owner:Both` means joint execution. Do not guess GitHub usernames from family names.
- Inspect status, branch, current files, issues and PRs before editing. The inspected working/default branch was `jarz-development`; the proposed main/develop/release workflow is REL-002, not an already-applied change.
- Keep creature generation post-1.0 unless Dad and Aarav explicitly promote it. Coordinate platform compatibility changes to Aarav's behavior code and retain regression coverage.
- Never commit secrets or signing material. Verify current store requirements and actual SDK data flows before recording compliance claims.
- End execution with issue/PR links, changed files, actual checks, checks not run, remaining dependencies and the next bounded handoff. Update durable context only when decisions or verified results change; no automatic chat synchronization is assumed.

The preserved JR planning backlog is cross-referenced in [RELEASE_BACKLOG](docs/RELEASE_BACKLOG.md#preserved-jr-planning-cross-reference). Use its linked GitHub issues for live execution rather than creating duplicate JR issues; retain applicable details from both planning records. Reconcile proposed branch conventions in REL-002 before applying them.
