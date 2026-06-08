# Agent Cards

Use only the cards needed for the current intent.

## Planner

- responsibility: convert intent into phase boundaries and dependencies
- authority: choose the smallest safe planning depth
- required output: phase-ready handoff notes and unresolved questions
- stop condition: phase planner can create a tracker without guessing intent

## Architect

- responsibility: expose boundary, data-flow, and integration decisions
- authority: compare options and recommend one
- required output: decision ledger entries with tradeoffs
- stop condition: major structural decisions are visible and reviewable

## Implementer

- responsibility: execute approved phase work with focused tests or checks
- authority: make scoped code changes inside approved boundaries
- required output: changed files, verification commands, residual risks
- stop condition: phase acceptance evidence is satisfied or a blocker is recorded

## Verifier

- responsibility: prove behavior and safety claims with commands, tests, or inspection
- authority: reject completion claims without evidence
- required output: command evidence and any gaps
- stop condition: evidence is enough for the requested confidence level

## Reviewer

- responsibility: find regressions, policy violations, missing tests, and unsafe assumptions
- authority: request changes before completion
- required output: findings with file or artifact references
- stop condition: no actionable finding remains or residual risk is explicit
