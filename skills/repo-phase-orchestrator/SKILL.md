---
name: repo-phase-orchestrator
description: Write and maintain multi-phase repository plans with tracker files, ordered phase boundaries, execution handoff, and progress control. Use for approved specs that need phase planning and tracking before external execution. Do not implement code directly.
---

# Repo Phase Orchestrator

## Goal

Write and maintain a detailed phase plan plus tracker, then hand off each current phase to an external execution workflow.

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
2. `docs/ai/context-map.json`
3. `docs/ai/project-index.md`
4. relevant indexes
5. approved spec file
6. existing phase plan if any
7. tracker file if any
8. protected-files policy
9. `docs/codexminimal/current-work.json`
10. `docs/codexminimal/artifact-registry.json`
11. `docs/codexminimal/telemetry.json`

## Workflow

1. Read the approved spec and identify phase boundaries.
2. Write or update the phase plan at:
   - `docs/codexminimal/plans/YYYY-MM-DD-<topic>-phase-plan.md`
3. Ensure the plan is detailed enough to drive execution.
4. For non-trivial work, target a detailed plan of at least 200 lines.
5. Create or update the tracker at:
   - `docs/codexminimal/trackers/YYYY-MM-DD-<topic>-tracker.md`
6. Update `docs/codexminimal/artifact-registry.json` so the approved spec, active phase plan, and tracker are linked.
7. Update `docs/codexminimal/current-work.json` with the active topic, stage, phase, artifact paths, and execution workflow.
8. Mark the current phase, scope, and verification expectations.
9. Check protected files and risk boundaries.
10. Handoff the current phase to an external execution workflow:
   - `subagent-driven-development` recommended
   - `executing-plans` acceptable fallback
11. After execution returns, update tracker status, failures, fixes, and next phase.
12. Record phase outcome in `docs/codexminimal/telemetry.json`.
13. Stop before advancing if the tracker, runtime state, or verification state is stale.

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
