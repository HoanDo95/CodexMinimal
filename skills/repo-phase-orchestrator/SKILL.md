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

1. Read the approved spec and identify phase boundaries.
2. Write or update the phase plan at:
   - `docs/codexminimal/plans/YYYY-MM-DD-<topic>-phase-plan.md`
3. Ensure the plan is detailed enough to drive execution.
4. Keep each individual plan file concise: maximum 200 lines.
5. If a plan would exceed 200 lines, split it into phase files and keep the root plan as an index.
6. Create or update the tracker at:
   - `docs/codexminimal/trackers/YYYY-MM-DD-<topic>-tracker.md`
7. Update `docs/codexminimal/artifact-registry.json` so the approved spec, active phase plan, and tracker are linked.
8. Update `docs/codexminimal/current-work.json` with the active topic, stage, phase, artifact paths, and execution workflow.
9. Mark the current phase, scope, and verification expectations.
10. Check protected files and risk boundaries.
11. Handoff the current phase to a tool adapter execution workflow:
   - selected execution adapter recommended
   - external skill or team executor acceptable fallback
12. After execution returns, update tracker status, failures, fixes, and next phase.
13. Record phase outcome in `docs/codexminimal/telemetry.json`.
14. Stop before advancing if the tracker, runtime state, or verification state is stale.

## Blocking Rules

Do not advance if:
- required checks fail
- tracker is stale
- current-work or artifact-registry state is stale
- protected file requires approval
- scope drift is detected
- the phase plan is missing or under-specified for execution

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
