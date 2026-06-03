# Harness State

CodexMinimal is most useful as a harness when it has explicit runtime state, not only prompt conventions.

## Core Runtime Files

Inside a target repository, `project-init` should create:

- `docs/ai/stack-profile.md`
- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`

## Purpose

### `current-work.json`

The active control file for the current work item.

It should point to:

- current topic
- current stage
- current phase
- approved spec path
- active phase-plan path
- active tracker path
- execution workflow in use

### `artifact-registry.json`

The machine-readable registry that links design/spec/plan/tracker artifacts together.

It should answer:

- which artifact is active
- which topic it belongs to
- what stage it belongs to
- whether it is draft, approved, active, stale, or superseded

### `telemetry.json`

The lightweight measurement surface for harness behavior.

It can record:

- session summaries
- file-read counts
- broad-scan incidents
- budget raises
- compaction events
- phase handoffs
- verification results

## Why This Matters

Without these files, a workflow can look structured while still drifting between sessions.

These runtime files make it easier to:

- block execution when artifacts are stale
- confirm which spec and tracker are authoritative
- measure whether the harness is actually reducing exploration waste
- compare before/after behavior during real-repo trials

## Enforcement

Use `scripts/validate_harness_runtime.py` to validate that:

- required runtime files exist
- active paths point to real files
- the registry and current-work file agree
- later stages are not marked active without the artifacts they require
