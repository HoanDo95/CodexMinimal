---
name: feature-intake-gate
description: Orchestrate the pre-implementation path for new features, changed behavior, or unclear requirements. Use when work should go through brainstorming, specification, and implementation planning before coding. Do not implement code.
---

# Feature Intake Gate

## Goal

Route feature work through the correct pre-implementation stages before coding begins.

This skill does not implement code.
This skill does not modify source files.
This skill only governs the path from rough intent to implementation-ready phase plan.

## Use When

Use when:

- a feature is new
- behavior will change
- requirements are still rough
- tradeoffs or constraints are not fully pinned down
- the user wants the safest path before implementation
- the team wants `brainstorm -> spec -> phase plan` enforced

## Do Not Use When

Do not use for:

- known bug fixes
- code review only
- small obvious edits
- direct repository bootstrap
- implementation that already has an approved plan

## Required Reads

1. `AGENTS.md`
2. `docs/ai/rule-registry.md`
3. `docs/ai/protected-files.md`
4. `docs/ai/context-map.json`
5. `docs/ai/project-index.md`

## Workflow

1. Confirm that the task is feature intake rather than bug-fix or direct implementation.
2. Decide whether `brainstorming` is still required.
3. If yes, route to `brainstorming` and stop after design approval.
4. Route approved design direction to `nestjs-sdd-planner`.
5. After spec approval, route to `repo-phase-orchestrator`.
6. Stop once a phase plan and tracker exist.
7. Handoff execution to `subagent-driven-development` or `executing-plans` only after the current phase is ready.

## Stage Model

Stages:

- `brainstorm`
- `spec`
- `phase-plan`
- `ready-to-execute`

Exit criteria:

- `brainstorm` exits only after direction and constraints are approved
- `spec` exits only after the spec is approved and open questions are bounded
- `phase-plan` exits only after a phase plan and tracker exist
- `ready-to-execute` means the current phase may be handed to an external execution skill

## Output Format

Return:

### Current stage

### Why this stage applies

### Approved direction status

### Open questions

### Protected-file or risk concerns

### Next skill

### Follow-up chain

### Stop condition

### Suggested prompt

If the caller requests machine-readable output, return JSON that conforms to `assets/intake-output.schema.json`.
