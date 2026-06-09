# Harness State

CodexMinimal is most useful as a harness when it has explicit runtime state, not only prompt conventions.

## Core Runtime Files

Inside a target repository, `project-init` should create:

- `docs/ai/stack-profile.md`
- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`
- `docs/codexminimal/feedback-ledger.json`

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

### `feedback-ledger.json`

The lightweight learning-memory surface for repeated mistakes and repeated user feedback.

It should track:

- stable issue keys
- strike counts
- whether an issue is merely observed, close to promotion, or already promoted
- the durable rule text that should be enforced after promotion
- affected paths or artifacts when the pattern is specific

This ledger should be user-mediated:

- add or increment strikes only when explicit user feedback confirms the issue
- do not auto-promote raw execution logs or noisy review chatter into durable memory

Default lifecycle:

- `observed`: below the warning threshold
- `watch`: one strike before promotion
- `promoted`: at or above the configured promotion threshold, and therefore treated as a durable rule

## Improvement Log Locations

Use these files for different kinds of improvement evidence:

| Need | File or folder | Notes |
|---|---|---|
| Active task state | `docs/codexminimal/current-work.json` | Current topic, stage, phase, artifact paths, blockers, and open questions. |
| Artifact links | `docs/codexminimal/artifact-registry.json` | Machine-readable links between intent/spec/plan/tracker artifacts. |
| Runtime measurements | `docs/codexminimal/telemetry.json` | Session summaries, phase handoffs, verification outcomes, budget raises, broad scans, and other workflow metrics. |
| Repeated user feedback | `docs/codexminimal/feedback-ledger.json` | User-confirmed repeated issues that may become durable rules. |
| Full IDSD evidence | `docs/codexminimal/idsd-traces/<topic>/` | Per-task trace folder with prompt, repo context, ADR, specification, tests, implementation, verification, and results. |
| Refactor history | `docs/ai/refactor-log.md` | Human-readable record of structural changes when a refactor profile is used. |

Do not mix these surfaces:

- put measurements and phase events in `telemetry.json`
- put repeated correction patterns in `feedback-ledger.json`
- put per-task evidence in an IDSD trace folder
- promote only explicit user-confirmed feedback into `docs/ai/rule-registry.md`

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
- the feedback ledger has a valid strike/promotion structure
