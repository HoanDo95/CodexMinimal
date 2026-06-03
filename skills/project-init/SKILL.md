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
6. Create missing docs/ai files from templates.
7. Create `docs/codexminimal/` runtime state files if missing.
7. Detect package manager, NestJS, TypeORM, test commands, lint/build commands, env/deployment files, and protected integration files.
8. Update `docs/ai/rule-registry.md`.
9. Update `docs/ai/protected-files.md`.
10. Do not delete user custom rules.

If helper scripts are available, prefer them for deterministic work:

- `scripts/sync_agents_blocks.py`
- `scripts/bootstrap_docs_ai.py`
- `scripts/bootstrap_harness_runtime.py`

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
- `CODEXMINIMAL:NESTJS_SPEC`
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
- route new feature intake through `feature-intake-gate` by default
- brainstorm before writing specs for new features or changed behavior
- write a phase plan and tracker after spec approval and before coding
- default to external execution after the phase plan exists
- keep `current-work.json` and `artifact-registry.json` aligned with the active implementation path
- read `docs/ai` indexes before broad repository search
- check `docs/ai/protected-files.md` before editing
- ask before touching protected files
- update rule-registry when user changes durable rules
- keep NestJS controllers thin
- place business logic in services
- return DTOs instead of TypeORM entities
- use DTO validation pipes
- keep feature modules by domain
- keep persistence inside feature directories
- unit tests go under `test/unit`
- e2e tests go under `test/e2e`
- keep TypeORM `synchronize: false`
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
- `gpt-5.4-mini`: bounded scan, quick summarization, low-risk analysis
- `gpt-5.3-codex`: quick local coding iteration

Ask before expensive model/effort escalation unless the task is trivial or already authorized.

## Output Format

Return:

### Initialized or updated files

### Detected project facts

### Protected files/folders

### AGENTS.md changes

### Rule registry changes

### Missing information

### Recommended next command

If the caller requests machine-readable output, return JSON that conforms to `assets/init-output.schema.json`.
