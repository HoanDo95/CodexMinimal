# Flows

## Repository Bootstrap

`task-router -> project-init -> project-indexer`

Use this when `AGENTS.md` or `docs/ai` is missing, stale, or inconsistent.

## New Feature

`task-router -> feature-intake-gate -> repo-phase-orchestrator -> external execution -> project-indexer`

Use this when the requirement is new, underspecified, or changes behavior and should be steered through design before code.

Inside `feature-intake-gate`, the expected pre-implementation path is:

`brainstorming -> nestjs-sdd-planner -> repo-phase-orchestrator`

## Spec To Plan

`task-router -> nestjs-sdd-planner -> repo-phase-orchestrator`

Use this when the design direction is already agreed but implementation should still go through a concrete spec, phase plan, and tracker before coding.

## Bug Fix

Optional NestJS profile flow:

`task-router -> nestjs-bug-fixer -> project-indexer`

Use this when a failing test, regression, runtime error, or incorrect API behavior is already known and the repo still wants the bundled NestJS execution profile.

## Code Review

Optional NestJS profile flow:

`task-router -> nestjs-code-reviewer`

Use this when the user wants findings without code changes.

## Refactor

Optional NestJS profile flow:

`task-router -> nestjs-refactor-guardian -> project-indexer`

Use this when work involves moving, renaming, splitting, or restructuring code and the repo wants the bundled NestJS refactor profile.

## Large Phased Work

`task-router -> repo-phase-orchestrator -> external execution`

Use this when the work spans multiple modules, needs explicit phase boundaries, or requires tracker-driven progress.

Before execution starts, keep these files aligned:

- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`

For speed-priority sessions, prefer `compact` response mode and `low` or `medium` context budget unless risk forces escalation.

For long sessions, compact after discovery when the active working set is smaller than the accumulated conversation history.
