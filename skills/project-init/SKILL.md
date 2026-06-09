---
name: project-init
description: Initialize or sync CodexMinimal in a repository. Creates or updates AGENTS.md, docs/ai indexes, rule-registry, protected-files, and durable project rules. Use for repo bootstrap, rule changes, protected path changes, or AGENTS.md synchronization.
---

# Project Init

## Goal

Initialize and maintain CodexMinimal repository guidance.

This skill owns:

- `AGENTS.md`
- `docs/ai/rule-registry.md`
- `docs/ai/stack-profile.md`
- `docs/ai/protected-files.md`
- `docs/ai/architecture-notes.md`
- `docs/ai/refactor-log.md`
- starter `docs/ai/*-index.md` files
- `docs/ai/context-map.json`
- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`
- `docs/codexminimal/feedback-ledger.json`

## Use When

Use this skill when:

- setting up CodexMinimal in a repo
- `AGENTS.md` is missing
- `docs/ai` is missing
- stack profile is missing or stale
- user changes durable rules
- user defines protected files/folders
- repo conventions need to be persisted
- AGENTS.md needs sync or cleanup

## Do Not Use When

Do not use for:

- feature implementation
- bug fixing
- direct refactor execution
- code review


## Modes

- `bootstrap`: create missing AGENTS.md and docs/ai files.
- `sync`: update CodexMinimal generated blocks while preserving custom rules.
- `repair`: restore missing generated blocks, missing docs/ai files, and missing templates.

## Required Behavior

1. Check whether `AGENTS.md` exists.
2. If missing, create it from `assets/AGENTS.template.md`.
3. If present, preserve user custom content.
4. Update only CodexMinimal managed blocks.
5. Create `docs/ai/` if missing.
6. Create missing docs/ai files from templates or bundled assets.
7. Create `docs/codexminimal/` runtime state files if missing.
8. Read `docs/codexminimal/feedback-ledger.json` if it already exists.
9. Treat the ledger as user-mediated memory:
   - only explicit user feedback should add or increment strikes
   - execution logs may suggest issues, but should not auto-write ledger strikes on their own
10. Normalize repeat-feedback status so the ledger uses:
   - `observed` before the watch threshold
   - `watch` one strike before promotion
   - `promoted` at or above the promotion threshold
11. Promote repeat feedback into durable rules once the configured strike threshold is reached.
12. Keep promoted feedback rules synchronized into `docs/ai/rule-registry.md`.
13. Detect package manager, framework cues, test commands, lint/build commands, env/deployment files, and protected integration files.
14. Detect the active stack profile:
   - default to `generic`
   - promote to `nestjs` only when the repository structure or dependencies clearly support it
   - promote to `rust` when Cargo manifests, workspace structure, or Rust-specific conventions clearly support it
15. Update `docs/ai/stack-profile.md` with the active profile, evidence, and allowed profile-specific skills.
16. Update `docs/ai/rule-registry.md`.
17. Update `docs/ai/protected-files.md`.
18. Do not delete user custom rules.

If helper scripts are available, prefer them for deterministic work:

- `scripts/sync_agents_blocks.py`
- `scripts/bootstrap_docs_ai.py`
- `scripts/bootstrap_harness_runtime.py`
- `scripts/record_feedback_issue.py`
- `scripts/promote_feedback_rules.py`

The bootstrap helpers should resolve bundled templates or assets automatically when no explicit template path is provided.

Do not push this work onto the user by default.
If the environment allows local script execution, run these helpers before attempting prompt-only manual reconstruction.

## Managed AGENTS.md Blocks

Update only these blocks:

- `CODEXMINIMAL:ROUTING`
- `CODEXMINIMAL:MODEL_ROUTING`
- `CODEXMINIMAL:RESPONSE_MODE`
- `CODEXMINIMAL:CONTEXT_BUDGET`
- `CODEXMINIMAL:AUTO_COMPACT`
- `CODEXMINIMAL:PROJECT_INDEX`
- `CODEXMINIMAL:HELPER_POLICY`
- `CODEXMINIMAL:SKILL_POLICY`
- `CODEXMINIMAL:STACK_PROFILE`
- `CODEXMINIMAL:TESTING_SPEC`
- `CODEXMINIMAL:PROTECTED_FILES`
- `CODEXMINIMAL:USER_RULE_MUTATION`
- `CODEXMINIMAL:SEARCH_POLICY`
  If a block is missing, append it.
  If a block exists, replace only content inside that block.

## Default Rules To Persist

Persist these defaults unless the user overrides them:

- classify non-trivial tasks before starting
- use the smallest suitable skill
- route new feature intake through `idsd-orchestrator` by default
- capture intent, agent cards, decision ledger, and acceptance evidence before phase planning
- reduce standalone spec requests into IDSD bounded specification, decisions, tasks, tests, and verification evidence
- write a phase plan and tracker after IDSD acceptance evidence and before coding
- default to tool adapter execution after the phase plan exists
- keep `current-work.json` and `artifact-registry.json` aligned with the active implementation path
- read `docs/codexminimal/feedback-ledger.json` before planning or execution-oriented routing
- record repeat-feedback strikes only from explicit user feedback or an explicitly approved review authority
- promote repeated user feedback into durable rules at the configured strike threshold
- treat promoted feedback rules as non-regression constraints, not advisory notes
- read `docs/ai` indexes before broad repository search
- check `docs/ai/protected-files.md` before editing
- ask before touching protected files
- update rule-registry when user changes durable rules
- keep stack-specific rules outside the AGENTS entrypoint unless the active profile requires them
- record the active stack profile and evidence in `docs/ai/stack-profile.md`
- unit tests should live outside production source folders when the active stack supports that convention
- do not commit secrets or `.env`
- do not break env/deployment contract
- run Task Router Protocol automatically before non-trivial requests
- use `$task-router` explicitly for ambiguous, risky, or multi-skill tasks
- do not require user to manually call `$task-router`
- rate the highest-risk action before execution
- ask before high-risk actions and block critical actions until scope is confirmed
- default to compact responses when speed matters
- set a context budget before exploration and avoid broad scan under low budget
- auto-compact long sessions by budget pressure and workflow state, not by fixed percentage alone
- prefer local helper scripts for deterministic repository setup work before prompt-only reconstruction

## Model Routing Defaults

- `gpt-5.5`: default for planning, architecture, complex coding, refactor, orchestration
- `gpt-5.5 high`: multi-module, high-risk, failing tests, database/env/deploy work
- `gpt-5.4`: balanced fallback for clear everyday coding and focused implementation
- `gpt-5.4-mini`: bounded scan, quick summarization, low-risk analysis
- do not recommend stale legacy model aliases as current default paths

Ask before expensive model/effort escalation unless the task is trivial or already authorized.

## Output Format

Return:

### Initialized or updated files

### Detected project facts

### Active stack profile

### Protected files/folders

### AGENTS.md changes

### Rule registry changes

### Missing information

### Recommended next command

If the caller requests machine-readable output, return JSON that conforms to `assets/init-output.schema.json`.
