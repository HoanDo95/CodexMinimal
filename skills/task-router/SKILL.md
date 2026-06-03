---
name: task-router
description: Classify user requests before execution and select the smallest suitable CodexMinimal workflow, primary skill, optional follow-up chain, model, effort, and safety policy. Use for unclear, risky, multi-step, expensive, protected-file, refactor, planning, debugging, review, or orchestration tasks. Do not modify project files.
---

# Task Router

## Goal

Classify the user request and choose the smallest safe workflow before execution.

This skill does not implement code.
This skill does not modify files.
This skill only routes.

## Use When

Use when:
- the task is unclear
- the task is multi-step
- the task may touch multiple modules
- the task may require refactor
- the task may touch protected files
- the task may affect env/deployment/database
- the task may require model/effort escalation
- the user asks what workflow/model/skill to use

## Do Not Use When

Do not use for:
- trivial one-line explanation
- simple command answer
- obvious low-risk task

For trivial tasks, answer directly.

## Classification

Classify as one of:

- simple
- scan
- planner
- sdd
- tdd
- coding
- bug-fix
- debug
- review
- refactor
- orchestrator

## Skill Routing

Choose exactly one primary skill for the current step:

- none
- feature-intake-gate
- brainstorming
- implementation-spec-writer
- project-init
- project-indexer
- repo-phase-orchestrator
- nestjs-sdd-planner
- nestjs-tdd-builder
- nestjs-bug-fixer
- nestjs-code-reviewer
- nestjs-refactor-guardian

Add follow-up skills only when the workflow naturally chains into a later step, for example:

- `feature-intake-gate -> repo-phase-orchestrator -> project-indexer`
- `brainstorming -> implementation-spec-writer -> repo-phase-orchestrator`
- `implementation-spec-writer -> repo-phase-orchestrator`
- `brainstorming -> profile-specific spec skill -> repo-phase-orchestrator`
- `nestjs-sdd-planner -> repo-phase-orchestrator`
- `nestjs-bug-fixer -> project-indexer`
- `nestjs-refactor-guardian -> project-indexer`

## Pre-Implementation Sequence

For new features, changed behavior, or unclear requirements, prefer this sequence:

1. `feature-intake-gate`
2. `repo-phase-orchestrator`
3. external execution skill

Inside `feature-intake-gate`, the default internal sequence is:

1. `brainstorming`
2. `implementation-spec-writer`
3. `repo-phase-orchestrator`

Use `feature-intake-gate` as the default for feature intake.
Use the underlying stage skills directly only when the user explicitly wants a specific stage or a previous stage is already approved.
Use external execution after the phase plan and tracker exist.
Treat internal execution-oriented skills as optional legacy profiles, not the default cross-stack path.
Treat `nestjs-*` skills as optional profile skills. Use them only when the active stack profile is `nestjs` or the user explicitly selects them.
Prefer `implementation-spec-writer` as the generic default spec stage.

## Repeat-Feedback Policy

If `docs/codexminimal/feedback-ledger.json` exists:

- read it before routing non-trivial work
- treat `status: promoted` entries as durable non-regression rules
- treat `status: watch` entries as repeat-risk warnings that deserve extra scrutiny
- do not reintroduce promoted issues unless the user explicitly changes the rule

## Model Routing

Use:

- `gpt-5.5 medium` for planning, architecture, normal coding, debugging, review, and orchestration.
- `gpt-5.5 high` for multi-module changes, risky refactor, failing tests with unclear cause, database/env/deployment work, or protected boundaries.
- `gpt-5.4-mini low` for bounded scan, quick summarization, or simple risk analysis.
- `gpt-5.3-codex` only as an optional fast local coding fallback.

Do not recommend high effort unless risk justifies it.

## Response Mode

Recommend one response mode:

- `compact`: shortest useful answer, minimal explanation, best when speed matters
- `standard`: normal detail, default for most work

Use `compact` when:

- the user prioritizes speed
- the task is repetitive or operational
- the answer should minimize token usage

Use `standard` when:

- risk is higher
- the task spans multiple modules
- the user needs rationale or explicit tradeoffs

## Safety Gates

Require user confirmation before execution if the task:

- touches protected files
- changes folder structure
- changes architecture boundaries
- affects env/deployment/database
- modifies CI/CD
- changes public API contracts
- may break runtime behavior
- spans multiple modules
- requires long fix-test-loop
- requires expensive model/effort escalation

## Action Risk Matrix

Classify the highest-risk action implied by the task:

- `low`: read-only analysis, summaries, local search, non-destructive inspection
- `medium`: normal local code edits, focused tests, index or docs updates
- `high`: protected-file edits, networked actions, database or migration work, commits, wide refactors, long-running fix loops
- `critical`: destructive shell actions, irreversible data changes, force pushes, production-impacting runtime or deploy changes

Routing rule:

- `low` usually maps to `proceed`
- `medium` usually maps to `proceed` unless another safety gate triggers
- `high` usually maps to `ask-user`
- `critical` maps to `blocked` until explicit approval and scope confirmation exist

## Required Reads

If available, read:

1. `AGENTS.md`
2. `docs/ai/stack-profile.md`
3. `docs/ai/rule-registry.md`
4. `docs/ai/protected-files.md`
5. `docs/codexminimal/feedback-ledger.json`
6. `docs/ai/context-map.json`
7. `docs/ai/project-index.md`

Do not scan the whole repository.

## Context Budget

Set one context budget before broad exploration:

- `low`: index-first plus up to 5 files
- `medium`: index-first plus up to 12 files
- `high`: use only when justified by risk, ambiguity, or multi-module scope

Budget rules:

- start with the lowest budget that can answer the task
- if the budget is exhausted and confidence is still low, reroute or ask the user
- do not continue scanning by inertia
- do not broad-scan the repository under `low`

## Auto-Compact

For long sessions, compact by trigger and workflow state rather than by a fixed threshold alone.

Compact when:

- `low` or `medium` budget is close to exhaustion
- exploration is done and only execution context needs to remain
- repeated long turns do not open new technical surface

Compact rules:

- keep active task, constraints, touched files, unresolved risks, and next action
- drop stale branches and repeated recaps
- preserve unresolved user decisions and protected-file constraints
- a heuristic such as `60%` context usage may help, but it should not be the sole trigger

## Output Format

Return:

### Classification

### Primary skill

### Follow-up skills
Use `none` if no chain is needed.

### Recommended model/effort

### Response mode
One of:
- compact
- standard

### Context budget
One of:
- low
- medium
- high

### Safety gate
One of:
- proceed
- ask-user
- blocked

### Action risk level
One of:
- low
- medium
- high
- critical

### Action risk reasons

### Reason

### Next action

### Suggested prompt

If the caller requests machine-readable output, return JSON that conforms to `assets/router-output.schema.json`.
