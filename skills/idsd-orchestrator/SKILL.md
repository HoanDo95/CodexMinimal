---
name: idsd-orchestrator
description: Orchestrate Intent-Driven Spec Development for new features, changed behavior, and ambiguous work by turning user intent into agent cards, decision evidence, acceptance evidence, and phase-planning handoff. Use before implementation for CodexMinimal's default feature workflow.
---

# IDSD Orchestrator

## Goal

Turn a short user intent into an implementation-ready operating package without requiring a traditional SDD document.

Save approved runtime artifacts to:

`docs/codexminimal/idsd/YYYY-MM-DD-<topic>-intent.md`

## Use When

Use when:

- user asks for IDSD or intent-driven development
- a new feature or behavior change starts from rough intent
- the work needs agent planning, evidence, or verification boundaries
- the user wants AI to organize structure while keeping decisions visible
- traditional SDD would create too much documentation overhead

## Do Not Use When

Do not use for:

- direct one-line answers
- known bug fixes with a clear reproduction
- code review only
- explicit legacy SDD requests that must use a profile-specific SDD planner
- implementation that already has an approved phase plan and tracker

## Required Reads

Before orchestrating, read available context in this order:

1. `AGENTS.md`
2. `docs/ai/stack-profile.md`
3. `docs/ai/rule-registry.md`
4. `docs/ai/protected-files.md`
5. `docs/codexminimal/feedback-ledger.json`
6. `docs/codexminimal/current-work.json`
7. `docs/ai/context-map.json`
8. `docs/ai/project-index.md`

Skip missing files without broad repository scans.

## Workflow

1. Classify task as `idsd`.
2. Capture intent, business rules, non-goals, constraints, and acceptance criteria.
3. Select agent cards from `references/agent-cards.md`.
4. Create an intent contract using `assets/intent-contract.template.md`.
5. Start a decision ledger using `assets/decision-ledger.template.md`.
6. Define acceptance evidence using `references/evidence-policy.md`.
7. Decide whether legacy spec, TDD, review, security, or refactor gates are needed.
8. Record visible assumptions and tradeoffs before handoff.
9. Handoff to `repo-phase-orchestrator` once the intent package is bounded.
10. Handoff to `project-indexer` after implementation changes land.

## IDSD Rules

- Intent is the source of truth; specs are optional evidence, not the default workflow.
- Every architectural or workflow choice needs a short decision entry.
- Agent cards define responsibility, authority, required output, and stop condition.
- Acceptance criteria must be observable and verifiable.
- TDD may be selected as evidence for behavior, but it does not replace intent capture.
- SDD planners are legacy compatibility tools and run only on explicit user request.
- Do not start implementation until protected-file and risk gates are known.

## Output Format

Return:

### Classification

idsd

### Current stage

### Intent contract

### Agent cards

### Decision ledger entries

### Acceptance evidence

### Optional compatibility gates

### Protected-file or risk concerns

### Next skill

### Follow-up chain

### Stop condition

### Suggested prompt

If the caller requests machine-readable output, return JSON that conforms to `assets/idsd-output.schema.json`.
