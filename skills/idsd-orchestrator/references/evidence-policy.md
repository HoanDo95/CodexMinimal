# Evidence Policy

IDSD uses evidence to keep agent autonomy observable.

## Required Evidence

- intent contract: goal, rules, non-goals, constraints, acceptance criteria
- agent cards: selected responsibilities and stop conditions
- decision ledger: assumptions, rejected options, chosen path, risk
- acceptance evidence: how the work will be proven complete
- solution challenge: alternatives, rejected paths, counterarguments, and residual risk when the solution is non-obvious
- system design gate: boundary, data-flow, failure-mode, compatibility, and operational notes when public contracts or architecture are touched
- senior QA gate: edge-case matrix, regression targets, and post-execution acceptance verdict when behavior can regress beyond the happy path

## Optional Evidence

- external spec summary: when a team supplies a large standalone spec, keep only the IDSD-relevant decisions and acceptance evidence
- TDD: when behavior can be captured in focused tests before implementation
- security review: when user input, auth, secrets, permissions, or data exposure are involved
- refactor impact map: when files move, public APIs change, or module boundaries shift

## Gate Selection

- Use `solution_challenger` for ambiguous solution shape, multiple viable approaches, high-cost implementation, or user-requested critique.
- Use `system_designer` for API contracts, persistence, auth, async processing, integrations, migrations, scaling, compatibility, or multi-module boundaries.
- Use `senior_qa` for user-facing workflows, public APIs, permission-sensitive behavior, state machines, concurrency, idempotency, edge cases, or repeated quality feedback.

## Completion Rule

Do not claim done until evidence matches the acceptance criteria or the gap is stated as a blocker.
