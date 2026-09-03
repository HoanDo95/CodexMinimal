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
3. Codex CLI native execution

Use `idsd-orchestrator` to turn intent into a bounded intent contract, conditional quality-gate agent cards, decision ledger, and acceptance evidence before phase planning.
Use Codex CLI native execution after the phase plan and tracker exist. Use another tool adapter only when the user or repository policy selects one.
Treat `nestjs-*` skills as optional profile skills. Use them only when the active stack profile is `nestjs` or the user explicitly selects them.
Treat `rust-*` skills as optional profile skills. Use them only when the active stack profile is `rust` or the user explicitly selects them.

## Required Reads

Start from the user request plus `AGENTS.md` and route. Read more only when the task needs it:

1. `docs/ai/stack-profile.md` when stack-specific skills may apply
2. `docs/ai/rule-registry.md` and `docs/ai/protected-files.md` when the task may touch protected files, architecture boundaries, or env/deploy/database
3. `docs/ai/context-map.json` and `docs/ai/project-index.md` when the task spans multiple modules or needs navigation

Do not scan the whole repository. Do not preload every state file before routing.

## Reference Policies

Use these references when the corresponding output field is needed:

- `references/model-routing.md`
- `references/safety-gates.md`
- `references/context-budget.md`

## Output Format

Return:

### Classification

### Route
Primary skill plus follow-up skills. Use `none` for follow-ups if no chain is needed.

### Model and effort
Cheapest capable tier; escalate only on concrete risk. Never hardcode model names; describe the tier (default or escalated) and why.

### Context budget
One of:
- low
- medium
- high

### Safety gate and why
Gate, one of:
- proceed
- ask-user
- blocked

Plus one line naming the highest-risk action behind the decision.

### Next action
What to do next, including the suggested prompt for the primary skill.

If the caller requests machine-readable output, return JSON that conforms to `assets/router-output.schema.json`.
