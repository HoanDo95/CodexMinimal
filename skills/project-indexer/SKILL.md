---
name: project-indexer
description: Create, repair, or incrementally update compact AI-readable project indexes and context-map v2 for faster Codex navigation. Use after project-init, after file/module/route/entity/test changes, after refactors, or when indexes are missing/stale. Do not implement product behavior.
---

# Project Indexer

## Goal

Create and maintain compact project memory under `docs/ai/` so future tasks can locate relevant files without broad repository scans.

This skill owns:

- `docs/ai/project-index.md`
- `docs/ai/module-index.md`
- `docs/ai/route-index.md`
- `docs/ai/entity-index.md`
- `docs/ai/test-index.md`
- `docs/ai/dependency-index.md`
- `docs/ai/context-map.json`

It may update these when relevant:

- `docs/ai/protected-files.md`
- `docs/ai/architecture-notes.md`
- `docs/ai/refactor-log.md`

## Use When

Use when:

- project was just initialized
- `docs/ai` indexes are missing
- `context-map.json` is missing or old
- files/modules/routes/entities/tests changed
- refactor moved, renamed, or split files
- Codex needs faster navigation
- indexes appear stale or contradictory
- user asks to index, map, scan, or summarize repository structure

## Do Not Use When

Do not use for:

- implementing product behavior
- fixing bugs directly
- reviewing code quality only
- planning product features
- broad refactors

## Modes

- `full`: indexes are missing, project was just initialized, context-map version is outdated, or repository structure is unknown
- `incremental`: changed files are known, git diff is available, or only specific modules/routes/entities/tests changed
- `repair`: index files exist but are malformed, context-map is invalid JSON, required sections are missing, or index conflicts with source code

## Required Reads

Read in this order:

1. `AGENTS.md`
2. `docs/ai/stack-profile.md` if present
3. `docs/ai/rule-registry.md` if present
4. `docs/ai/protected-files.md` if present
5. `docs/ai/context-map.json` if present
6. `docs/ai/project-index.md` if present
7. `package.json`
8. framework/config files
9. relevant source/test folders

Do not start with whole-repository search unless indexes are missing or full mode is required.

## Discovery Targets

See `references/discovery-targets.md`.

## Context Map And Output Rules

Write `docs/ai/context-map.json` using schema version 2.

See:

- `references/context-map-schema.md`
- `references/index-format.md`
- `references/search-strategy.md`

## Workflow

### full

1. detect package manager, framework, and scripts
2. map the repository's active surfaces, contracts, data layers, and tests
3. write or replace all owned index files
4. rebuild `context-map.json` from current source
5. verify JSON validity and basic consistency

### incremental

1. identify changed files or affected modules
2. update only relevant index entries
3. patch `context-map.json` for changed modules and routes
4. verify that unchanged sections remain intact

### repair

1. detect malformed, stale, or contradictory index content
2. rebuild only the broken sections
3. restore missing required headings or keys
4. verify JSON validity and required file presence

If helper scripts are available, prefer them for deterministic validation or stub rendering:

- `scripts/validate_context_map.py`
- `scripts/render_index_stubs.py`

Do not ask the user to run these scripts unless execution is blocked.
If local script execution is available, the workflow should use the helpers first and only fall back to prompt-only repair when necessary.

## Output Format

Return:

### Mode

### Files updated

### Project facts detected

### Index coverage

### Context-map changes

### Protected-path observations

### Verification

### Remaining gaps

If the caller requests machine-readable output, return JSON that conforms to `assets/indexer-output.schema.json`.
