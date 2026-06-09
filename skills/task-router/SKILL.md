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
- idsd
- tdd
- coding
- bug-fix
- debug
- review
- refactor
- orchestrator

See `references/classification-rules.md` for detailed classification and follow-up-chain rules.

## Skill Routing

Choose exactly one primary skill for the current step:

- none
- idsd-orchestrator
- brainstorming
- project-init
- project-indexer
- repo-phase-orchestrator
- nestjs-tdd-builder
- nestjs-bug-fixer
- nestjs-code-reviewer
- nestjs-refactor-guardian
- rust-tdd-builder
- rust-bug-fixer
- rust-code-reviewer
- rust-refactor-guardian

Add follow-up skills only when the workflow naturally chains into a later step, for example:

- `idsd-orchestrator -> repo-phase-orchestrator -> project-indexer`
- `nestjs-bug-fixer -> project-indexer`
- `nestjs-refactor-guardian -> project-indexer`
- `rust-bug-fixer -> project-indexer`
- `rust-refactor-guardian -> project-indexer`

## Pre-Implementation Sequence

For new features, changed behavior, or unclear requirements, prefer IDSD as the default sequence:

1. `idsd-orchestrator`
2. `repo-phase-orchestrator`
3. tool adapter execution

Use `idsd-orchestrator` to turn intent into a bounded intent contract, agent cards, decision ledger, and acceptance evidence before phase planning.
Use tool adapter execution after the phase plan and tracker exist.
Treat `nestjs-*` skills as optional profile skills. Use them only when the active stack profile is `nestjs` or the user explicitly selects them.
Treat `rust-*` skills as optional profile skills. Use them only when the active stack profile is `rust` or the user explicitly selects them.

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

## Reference Policies

Use these references when the corresponding output field is needed:

- `references/model-routing.md`
- `references/response-mode.md`
- `references/safety-gates.md`
- `references/context-budget.md`
- `references/auto-compact.md`
- `references/repeat-feedback-policy.md`

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
