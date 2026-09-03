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
8. Treat repeated user-confirmed feedback as durable: write it directly into `docs/ai/rule-registry.md` under `Promoted Feedback Rules`. No separate ledger, strikes, or thresholds.
9. Detect package manager, framework cues, test commands, lint/build commands, env/deployment files, and protected integration files.
10. Detect the active stack profile:
   - default to `generic`
   - promote to `nestjs` only when the repository structure or dependencies clearly support it
   - promote to `rust` when Cargo manifests, workspace structure, or Rust-specific conventions clearly support it
11. Update `docs/ai/stack-profile.md` with the active profile, evidence, and allowed profile-specific skills.
12. Update `docs/ai/rule-registry.md`.
13. Update `docs/ai/protected-files.md`.
14. Do not delete user custom rules.

If helper scripts are available, prefer them for deterministic work:

- `scripts/sync_agents_blocks.py`
- `scripts/bootstrap_docs_ai.py`
- `scripts/bootstrap_harness_runtime.py`

The bootstrap helpers should resolve bundled templates or assets automatically when no explicit template path is provided.

Do not push this work onto the user by default.
If the environment allows local script execution, run these helpers before attempting prompt-only manual reconstruction.

## Managed AGENTS.md Blocks

Update only these blocks (`templates/AGENTS.md` is the source of truth; never duplicate block text here):

- `CODEXMINIMAL:ROUTING`
- `CODEXMINIMAL:MODEL_ROUTING`
- `CODEXMINIMAL:CONTEXT_BUDGET`
- `CODEXMINIMAL:SEARCH_POLICY`
- `CODEXMINIMAL:SKILL_POLICY`
- `CODEXMINIMAL:TESTING_SPEC`
- `CODEXMINIMAL:PROTECTED_FILES`
- `CODEXMINIMAL:USER_RULE_MUTATION`
  If a block is missing, append it.
  If a block exists, replace only content inside that block.
  Remove legacy blocks (`RESPONSE_MODE`, `AUTO_COMPACT`, `PROJECT_INDEX`, `STACK_PROFILE`, `HELPER_POLICY`, `NESTJS_SPEC`) when found.

## Default Rules To Persist

Persist these defaults unless the user overrides them (keep them in the managed blocks and `docs/ai`, not in this skill):

- classify non-trivial tasks before starting; use the smallest suitable skill
- route new feature intake through `idsd-orchestrator`, then phase planning, then Codex CLI native execution
- keep `current-work.json` and `artifact-registry.json` aligned with the active work
- read `docs/ai` indexes before broad repository search; check protected files before editing
- record the active stack profile and evidence in `docs/ai/stack-profile.md`
- do not commit secrets or `.env`; do not break env/deployment contract
- start with the smallest context budget that can answer the task
- default to the cheapest capable model and effort; escalate only on concrete risk

## Model Routing Defaults

Default to the cheapest capable model and effort. Escalate only for complex architecture, multi-module or high-risk work, failing tests with unclear cause, or database/env/deploy and protected-boundary work. Never hardcode model names into repo guidance; the tool selects the concrete model.

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
