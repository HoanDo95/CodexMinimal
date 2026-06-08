# Evidence Policy

IDSD uses evidence to keep agent autonomy observable.

## Required Evidence

- intent contract: goal, rules, non-goals, constraints, acceptance criteria
- agent cards: selected responsibilities and stop conditions
- decision ledger: assumptions, rejected options, chosen path, risk
- acceptance evidence: how the work will be proven complete

## Optional Evidence

- legacy spec: only when explicitly requested or needed for an external contract
- TDD: when behavior can be captured in focused tests before implementation
- security review: when user input, auth, secrets, permissions, or data exposure are involved
- refactor impact map: when files move, public APIs change, or module boundaries shift

## Completion Rule

Do not claim done until evidence matches the acceptance criteria or the gap is stated as a blocker.
