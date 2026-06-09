# Flows

## Repository Bootstrap

`task-router -> project-init -> project-indexer`

Use this when `AGENTS.md` or `docs/ai` is missing, stale, or inconsistent.

## New Feature

`task-router -> idsd-orchestrator -> repo-phase-orchestrator -> Codex CLI native execution -> verification -> project-indexer`

Use this when the requirement is new, underspecified, starts from intent, or changes behavior and should be steered through visible agent decisions before code.

Inside `idsd-orchestrator`, the expected pre-implementation package is:

- intent contract
- ADR-style architecture decisions
- bounded specification
- task breakdown
- TDD/test contract
- selected agent cards
- decision ledger
- acceptance evidence
- implementation handoff
- verification and report outline

## Bug Fix

Optional NestJS profile flow:

`task-router -> nestjs-bug-fixer -> project-indexer`

Use this when a failing test, regression, runtime error, or incorrect API behavior is already known and the repo still wants the bundled NestJS execution profile.

Optional Rust profile flow:

`task-router -> rust-bug-fixer -> project-indexer`

Use this when a failing test, compiler error, panic, runtime error, or incorrect behavior is already known and the repo wants the bundled Rust execution profile.

## Code Review

Optional NestJS profile flow:

`task-router -> nestjs-code-reviewer`

Use this when the user wants findings without code changes.

Optional Rust profile flow:

`task-router -> rust-code-reviewer`

Use this when the user wants Rust-focused findings without code changes.

## Refactor

Optional NestJS profile flow:

`task-router -> nestjs-refactor-guardian -> project-indexer`

Use this when work involves moving, renaming, splitting, or restructuring code and the repo wants the bundled NestJS refactor profile.

Optional Rust profile flow:

`task-router -> rust-refactor-guardian -> project-indexer`

Use this when work involves moving, renaming, splitting, or restructuring Rust modules or crates and the repo wants the bundled Rust refactor profile.

## Large Phased Work

`task-router -> repo-phase-orchestrator -> Codex CLI native execution`

Use this when the work spans multiple modules, needs explicit phase boundaries, or requires tracker-driven progress.

Before execution starts, keep these files aligned:

- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`

For speed-priority sessions, prefer `compact` response mode and `low` or `medium` context budget unless risk forces escalation.

For long sessions, compact after discovery when the active working set is smaller than the accumulated conversation history.
