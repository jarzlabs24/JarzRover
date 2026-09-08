# Codex handoff

JarZLabs/ChatGPT is the planning space; the private repository and GitHub issues are the durable execution record. Copy accepted decisions into repository context. Chat history does not synchronize automatically.

Read AGENTS.md, PROJECT_CONTEXT.md, APP_STORE_READINESS.md and RELEASE_BACKLOG.md before execution. For hardware work also read HARDWARE.md, WIRING.md and TEST_LOG.md. Reuse the existing [execution issue template](../.github/ISSUE_TEMPLATE/jarzrover-execution.md).

## Planning → implementation packet

```text
CODEX HANDOFF
Goal / user-visible outcome:
Issue ID(s) and GitHub URL(s):
Owner: Dad / Aarav / Both
Milestone and dependency status:
Repository / verified base branch / base commit / task branch:
Accepted decisions and relevant context files:
Included work / excluded work:
Hardware, firmware, model and data-flow constraints:
Acceptance criteria and required evidence:
Checks to run / physical tests requiring an available rover:
```

Start by inspecting files, worktree changes, issues and PRs. Preserve unrelated work. Use the issue dependencies to choose a bounded task and link the implementation PR back to its issue. Do not infer an assignee's GitHub username from an owner label.

## Implementation → planning packet

```text
RESULT HANDOFF
Issue(s), status and PR/commit:
What changed / exact files:
Acceptance criteria met / still open:
Checks actually run and results:
Checks not run and why:
Hardware/firmware/device/model revision used:
Decisions or verified results added to durable context:
Remaining blockers/dependencies:
Next bounded task:
```

GitHub is authoritative for issue status. Update the backlog snapshot and relevant durable context when closing work. Close only after acceptance evidence exists; a generated checklist is not a passed hardware test.

## First execution packet

Goal: freeze the Android 1.0 product and release scope.
Task: REL-001, with Dad owning the document and Dad/Aarav agreeing included features and thresholds.
Read first: AGENTS, PROJECT_CONTEXT, APP_STORE_READINESS, RELEASE_BACKLOG, then hardware notes for sonar decisions.
Definition of done: approved scope/identity decisions and unresolved questions recorded, post-1.0 boundary explicit, measurable release criteria agreed, linked issue and handoff updated.
