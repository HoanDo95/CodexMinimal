---
name: repo-phase-orchestrator
description: Write and maintain multi-phase repository plans with tracker files, ordered phase boundaries, execution handoff, and progress control. Use for approved specs that need phase planning and tracking before Codex CLI native execution. Do not implement code directly.
---

# Repo Phase Orchestrator

## Goal

Write and maintain a detailed phase plan plus tracker, then hand off each current phase to Codex CLI native execution by default.

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
2. Read the approved spec and selected IDSD quality-gate evidence before creating or revising a plan:
   - `solution_challenger` output for solution options, rejected paths, counterarguments, and residual risk
   - `system_designer` output for API, data, auth, integration, async, migration, compatibility, and architecture boundaries
   - `senior_qa` output for edge cases, regression targets, permissions, concurrency, idempotency, and acceptance evidence
3. Identify phase boundaries from the complete intent, spec, and gate evidence.
4. Write or update the phase plan at:
   - `docs/codexminimal/plans/YYYY-MM-DD-<topic>-phase-plan.md`
5. Draft the full detailed plan first so the sequence, dependencies, and acceptance path are continuous.
6. Write the plan as detailed as possible: full executable steps per phase, concrete files/modules, exact verification commands, expected outputs, stop conditions, and handoff notes. Project implementation plans and trackers have no line cap. The 200/120-line budgets apply only to `SKILL.md` entrypoints and generated guidance files such as `AGENTS.md`, never to project plans.
7. Split into per-phase plan files by phase boundary (not by line count) whenever a single file becomes hard to execute or review:
   - keep the root plan as a complete index with intent summary, gate summary, phase map, dependencies, and links
   - move phase detail into per-phase plan files with no line cap
   - preserve handoff context so each phase can be executed without guessing prior intent
8. Create or update the tracker at:
   - `docs/codexminimal/trackers/YYYY-MM-DD-<topic>-tracker.md`
9. In the tracker, record phase handoff status:
   - what the completed phase delivered
   - how that result matches or diverges from the original intent
   - selected gate evidence status and remaining gaps
   - what the next phase must do based on the completed phase
10. Update `docs/codexminimal/artifact-registry.json` so the approved spec, active phase plan, and tracker are linked.
11. Update `docs/codexminimal/current-work.json` with the active topic, stage, phase, artifact paths, and execution workflow.
12. Mark the current phase, scope, and verification expectations.
13. Check protected files and risk boundaries.
14. Handoff the current phase to Codex CLI native execution by default:
   - another tool adapter is acceptable only when selected by user or repository policy
   - team executor or CI workflow is acceptable fallback when Codex CLI cannot execute safely
15. After execution returns, update tracker status, failures, fixes, intent alignment, and next phase.
16. Record phase outcome in `docs/codexminimal/telemetry.json`.
17. Stop before advancing if the tracker, runtime state, or verification state is stale.

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
