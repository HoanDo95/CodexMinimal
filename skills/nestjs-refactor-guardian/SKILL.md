---
name: nestjs-refactor-guardian
description: Safely perform NestJS refactors that may move files, rename modules/services, change imports, alter folder structure, split modules, or risk breaking source code. Requires impact map, protected-file checks, verification, index updates, and rule persistence.
---

# NestJS Refactor Guardian

## Goal

Perform safe, traceable refactors without silently breaking source code.

## Use When

Use when:
- moving files
- changing folder structure
- renaming modules/services/controllers
- splitting modules
- changing import direction
- changing domain boundaries
- refactor may break runtime/tests

## Do Not Use When

Do not use for:
- simple bug fix
- feature implementation without structural change
- review-only task
- planning-only task

## Required Reads

1. `AGENTS.md`
2. `docs/ai/context-map.json`
3. all relevant `docs/ai` indexes
4. `docs/ai/protected-files.md`
5. `docs/ai/architecture-notes.md`
6. related source/tests/config

## Workflow

1. Classify as `refactor`.
2. Read protected-file policy.
3. Build impact map.
4. Identify rollback boundary.
5. Ask approval if protected files or architecture boundaries are affected.
6. Refactor the smallest coherent unit.
7. Fix imports and providers.
8. Run targeted tests.
9. Run build/lint if available.
10. Update relevant indexes.
11. Record refactor in `docs/ai/refactor-log.md`.
12. If durable rule changed, request or invoke `project-init` to persist it.

## Impact Map Must Include

- files moved
- exports renamed
- imports changed
- modules affected
- providers affected
- controllers/routes affected
- DTOs affected
- entities/repositories affected
- tests affected
- config/env/deploy risk
- protected-file risk
- rollback boundary

## Output Format

Return:

### Classification
refactor

### Impact map
### Approval needed
### Files changed
### Tests/checks run
### Index updates
### Rule updates needed
### Refactor log entry
### Remaining risks
