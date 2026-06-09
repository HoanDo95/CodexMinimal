# Evidence Policy

IDSD uses evidence to keep agent autonomy observable.

## Required Evidence

- intent contract: goal, rules, non-goals, constraints, acceptance criteria
- agent cards: selected responsibilities and stop conditions
- decision ledger: assumptions, rejected options, chosen path, risk
- acceptance evidence: how the work will be proven complete

## Optional Evidence

- external spec summary: when a team supplies a large standalone spec, keep only the IDSD-relevant decisions and acceptance evidence
- TDD: when behavior can be captured in focused tests before implementation
- security review: when user input, auth, secrets, permissions, or data exposure are involved
- refactor impact map: when files move, public APIs change, or module boundaries shift

## Completion Rule

Do not claim done until evidence matches the acceptance criteria or the gap is stated as a blocker.
