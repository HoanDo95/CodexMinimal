---
name: repo-phase-orchestrator
description: Write and maintain multi-phase repository plans with tracker files, ordered phase boundaries, execution handoff, and progress control. Use for approved specs that need phase planning and tracking before tool adapter execution. Do not implement code directly.
---

# Repo Phase Orchestrator

## Goal

Write and maintain a detailed phase plan plus tracker, then hand off each current phase to a tool adapter execution workflow.

## Use When

Use when:
- an approved spec exists
- work has phases
- tracker file is needed
- commits may be required per phase
- long fix-test-loop is expected
- task spans multiple modules
- explicit phase planning or tracking is requested

## Do Not Use When

Do not use for:
- simple bug fix
- isolated code review
- small feature
- one-file edit
- direct coding without planning

## Required Reads

1. `AGENTS.md`
2. `docs/ai/stack-profile.md`
3. `docs/ai/context-map.json`
4. `docs/ai/project-index.md`
5. relevant indexes
6. approved spec file
7. existing phase plan if any
8. tracker file if any
9. protected-files policy
10. `docs/codexminimal/current-work.json`
11. `docs/codexminimal/artifact-registry.json`
12. `docs/codexminimal/telemetry.json`

## Workflow

1. If the request continues an existing tracker, use compact phase execution mode:
   - read only the active tracker, `current-work.json`, `telemetry.json`, protected-files policy, and files named by the current phase or blocker
   - execute or triage only the next open phase
   - write terse tracker/current-work/telemetry updates
   - stop after verification or blocker capture
2. Read the approved spec and identify phase boundaries when creating or revising a plan.
3. Write or update the phase plan at:
   - `docs/codexminimal/plans/YYYY-MM-DD-<topic>-phase-plan.md`
4. Ensure the plan is detailed enough to drive execution.
5. Keep each individual plan file concise: maximum 200 lines.
6. If a plan would exceed 200 lines, split it into phase files and keep the root plan as an index.
7. Create or update the tracker at:
   - `docs/codexminimal/trackers/YYYY-MM-DD-<topic>-tracker.md`
8. Update `docs/codexminimal/artifact-registry.json` so the approved spec, active phase plan, and tracker are linked.
9. Update `docs/codexminimal/current-work.json` with the active topic, stage, phase, artifact paths, and execution workflow.
10. Mark the current phase, scope, and verification expectations.
11. Check protected files and risk boundaries.
12. Handoff the current phase to a tool adapter execution workflow:
   - selected execution adapter recommended
   - external skill or team executor acceptable fallback
13. After execution returns, update tracker status, failures, fixes, and next phase.
14. Record phase outcome in `docs/codexminimal/telemetry.json`.
15. Stop before advancing if the tracker, runtime state, or verification state is stale.

## Blocking Rules

Do not advance if:
- required checks fail
- tracker is stale
- current-work or artifact-registry state is stale
- protected file requires approval
- scope drift is detected
- the phase plan is missing or under-specified for execution

## Compact Phase Execution

Use this mode for prompts such as `Continue CodexMinimal next phase`, `Continue Phase 0 only`, or `triage the current blocker`.

Rules:

- do not regenerate IDSD artifacts
- do not rewrite the full phase plan unless it is stale or missing
- do not scan beyond the active tracker and named files unless verification proves it is necessary
- keep telemetry to one short phase event
- keep the final report to current phase, changed files, verification, blocker, and next action

## Output Format

Return:

### Phase plan path
### Tracker path
### Current phase
### Scope
### Execution handoff
### Verification commands
### Tracker status
### Runtime state update
### Next phase
### Blockers
