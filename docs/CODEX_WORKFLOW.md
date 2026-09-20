# JarZLabs → JarzRover execution workflow

## Source of truth

ChatGPT project **JarZLabs** holds planning and discussion. Codex project **JarzRover** points to `/Users/naturetracker/Code/3DPrint/OpenBot`. That checkout, despite its OpenBot directory name, has private origin `https://github.com/jarzlabs24/JarzRover-Private.git`. Repository documents are the maintained execution contract; a conversation link alone does not transfer full history or attachments.

Start with [project context](PROJECT_CONTEXT.md), [readiness plan](plans/app-store-readiness/PLAN.md), [backlog](plans/app-store-readiness/BACKLOG.md), and [handoff template](plans/app-store-readiness/HANDOFF_TEMPLATE.md). The [inspection](plans/app-store-readiness/REPOSITORY_AUDIT.md) records what was actually inspected.

## Ownership and branches

@jarvis414-bot owns release scope, platform selection, identity, privacy, signing, store accounts, release acceptance and submission. @jarzlabs24 owns ball detection, creature generation, and feature demos. @jarvis414-bot reviews release/security/configuration changes; @jarzlabs24 reviews feature behavior. These are the verified GitHub identities for the maintainers.

Keep `jarz-development` as the existing integration branch. Do not rename `master` or discard `codex/import-second-mac-flutter`. Local `origin/HEAD` points to the import branch; verify the live GitHub default before setting PR bases or branch protection.

Use short branches `jarvis414-bot/JR-<id>-<slug>` and `jarzlabs24/JR-<id>-<slug>` from the agreed integration commit, with a separate checkout/worktree per concurrent coding task. First inspect uncommitted changes and preserve them; never reset or stash someone else's work implicitly. Proposed names are conventions, not branches created by this setup.

After M2 passes, @jarvis414-bot cuts `release/1.0.0` from a recorded tested commit (version provisional until JR-001). Only scoped release fixes enter it. Merge fixes back to `jarz-development`; avoid merging the entire moving feature branch into the release branch. New features remain on integration or behind verified disabled-by-default gates. Tag accepted releases only after artifact validation. Use explicit private `origin` for pushes; `public-fork` and `upstream` are separate remotes.

## Planning to implementation

1. In JarZLabs, develop the goal, chosen behavior, exclusions, owner, dependencies, acceptance criteria, and unresolved decisions. Label suggestions separately from approved decisions.
2. Export the relevant plan as text using the handoff template. Include source conversation, plan revision, exact repository/branch/base commit, relevant attachment filenames, and the actual needed content. Do not include secrets or rely on inaccessible attachments.
3. Open a coding task in the saved **JarzRover** project. Give it the handoff and relevant JR IDs. Ask it to read AGENTS.md and reconcile the handoff with current code before editing. Starting from the default branch may select the import branch; explicitly select the intended integration state.
4. Codex checks branch, remote, status, scoped instructions and prerequisites. Material contradictions become documented decisions/blockers; routine implementation choices proceed within scope. First update the local backlog/handoff to capture the accepted plan.
5. Implement one bounded task, run relevant checks, and record actual evidence. No status becomes Done solely because code was written. Include file changes, commands/results, device/firmware details where relevant, and outstanding gaps.
6. Review the diff and PR against acceptance criteria. Use the private repository and explicit base. Posting issues, PRs, or messages and publishing builds is separate work requiring user authorization when not already requested.
7. Update backlog status, project context if durable decisions changed, and TEST_LOG.md for actual validation. Copy the completed handoff summary into JarZLabs. Next planning starts from that summary and commit, not stale chat recollection.

## Backlog contract

Statuses: Todo → Ready → In progress → In review → Done; Blocked includes reason, owner, and unblock condition. Ready requires dependencies resolved, owner assigned and measurable acceptance criteria. The initial backlog is local issue-ready text, not posted GitHub issues. Keep JR IDs stable; add GitHub URLs when created. GitHub can own live status after migration, but retain acceptance criteria and a dated status snapshot here. Record plan amendments with date, rationale and affected IDs; do not silently rewrite historical results.

## Verification entry points

These are candidate commands, not checks run by this documentation setup. Establish toolchain/dependencies in JR-002 first. From `android/`: `./gradlew checkStyle lint test assembleDebug`; narrow to selected modules as appropriate. From `controller/flutter/`: `flutter doctor -v`, `flutter pub get`, `flutter analyze`, `flutter test`, then selected Android/iOS build. For native iOS, inspect workspace/schemes with `xcodebuild -list` before recording the exact build/test invocation. Release validation must inspect signed AAB/archive output, not accept debug builds as submission evidence.

Existing test log remains the hardware evidence source. Documentation-only work uses link/diff checks; do not run full builds solely to validate prose.

## Ready-to-use next coding prompt

> Work in the saved JarzRover project, private origin JarzRover-Private. Read AGENTS.md, docs/PROJECT_CONTEXT.md, docs/CODEX_WORKFLOW.md, and docs/plans/app-store-readiness/{PLAN,BACKLOG,REPOSITORY_AUDIT}.md. Start JR-001 and JR-002 on a `jarvis414-bot/` task branch based on the explicitly verified jarz-development state. Preserve all existing changes and history. Inventory the candidate apps and establish reproducible baseline checks. Present the app/identity decisions @jarvis414-bot must resolve; do not silently select a shipping app or change registered identifiers. Update the backlog and return a completed handoff with evidence. Do not submit or publish builds as part of this task.

Official reference: [Codex AGENTS.md guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md). Keep durable instructions in AGENTS.md and detailed evolving plans in linked documents.
