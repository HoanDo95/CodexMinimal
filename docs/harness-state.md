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

### User-Confirmed Feedback

Repeated user-confirmed feedback is durable memory. Write it directly into `docs/ai/rule-registry.md` under `Promoted Feedback Rules` — there is no separate ledger, strike count, or promotion threshold. The tool's built-in memory may also retain it; the rule registry is the team-visible source of truth.

## Improvement Log Locations

Use these files for different kinds of improvement evidence:

| Need | File or folder | Notes |
|---|---|---|
| Active task state | `docs/codexminimal/current-work.json` | Current topic, stage, phase, artifact paths, blockers, and open questions. |
| Artifact links | `docs/codexminimal/artifact-registry.json` | Machine-readable links between intent/spec/plan/tracker artifacts. |
| Runtime measurements | `docs/codexminimal/telemetry.json` | Session summaries, phase handoffs, verification outcomes, budget raises, broad scans, and other workflow metrics. |
| Repeated user feedback | `docs/ai/rule-registry.md` (`Promoted Feedback Rules`) | User-confirmed repeated issues written directly as durable rules. |
| Full IDSD evidence | `docs/codexminimal/idsd-traces/<topic>/` | Per-task trace folder with prompt, repo context, ADR, specification, tests, implementation, verification, and results. |
| Refactor history | `docs/ai/refactor-log.md` | Human-readable record of structural changes when a refactor profile is used. |

Do not mix these surfaces:

- put measurements and phase events in `telemetry.json`
- put repeated correction patterns directly in `docs/ai/rule-registry.md`
- put per-task evidence in an IDSD trace folder
- treat explicit user-confirmed feedback as durable immediately; do not auto-promote raw execution logs or noisy review chatter

## Why This Matters

Without these files, a workflow can look structured while still drifting between sessions.

These runtime files make it easier to:

- block execution when artifacts are stale
- confirm which spec and tracker are authoritative
- measure whether the harness is actually reducing exploration waste
- stop repeating the same corrected mistake after the same feedback appears multiple times
- compare before/after behavior during real-repo trials

## Enforcement

Use `scripts/validate_harness_runtime.py` to validate that:

- required runtime files exist
- active paths point to real files
- the registry and current-work file agree
- later stages are not marked active without the artifacts they require
