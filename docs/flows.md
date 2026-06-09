# Flows

## Repository Bootstrap

`task-router -> project-init -> project-indexer`

Use this when `AGENTS.md` or `docs/ai` is missing, stale, or inconsistent.

## New Feature

`task-router -> idsd-orchestrator -> repo-phase-orchestrator -> tool adapter execution -> verification -> project-indexer`

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
- optional compatibility gates

## Legacy Spec To Plan

Legacy compatibility flow:

`task-router -> implementation-spec-writer -> repo-phase-orchestrator`

Use this only when the `legacy` profile is installed and the design direction must still go through a traditional spec, phase plan, and tracker before coding.

For old NestJS spec-first compatibility with the `legacy` profile active:

`task-router -> nestjs-sdd-planner -> repo-phase-orchestrator`

For old Rust spec-first compatibility with the `legacy` profile active:

`task-router -> rust-sdd-planner -> repo-phase-orchestrator`

Use these flows only when the user explicitly asks for legacy spec-first behavior or an existing team contract requires a traditional spec.

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

`task-router -> repo-phase-orchestrator -> tool adapter execution`

Use this when the work spans multiple modules, needs explicit phase boundaries, or requires tracker-driven progress.

Before execution starts, keep these files aligned:

- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`

For speed-priority sessions, prefer `compact` response mode and `low` or `medium` context budget unless risk forces escalation.

For long sessions, compact after discovery when the active working set is smaller than the accumulated conversation history.
