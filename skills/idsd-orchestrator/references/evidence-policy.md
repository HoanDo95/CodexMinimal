# Evidence Policy

IDSD uses evidence to keep agent autonomy observable.

## Required Evidence

- intent contract: goal, rules, non-goals, constraints, acceptance criteria
- agent cards: selected responsibilities and stop conditions
- decision ledger: assumptions, rejected options, chosen path, risk
- acceptance evidence: how the work will be proven complete
- solution challenge: alternatives, rejected paths, counterarguments, and residual risk when the solution is non-obvious
- system design gate: boundary, data-flow, failure-mode, compatibility, and operational notes when public contracts or architecture are touched
- senior QA gate (pre): edge-case matrix mapped from ticket AC, regression targets before execution
- senior QA gate (post): AC-coverage table from ticket AC vs PR diff code, affected flows, error-prone edge cases, test gaps, and verdict PASS / FAIL / BLOCKED after execution

## Optional Evidence

- external spec summary: when a team supplies a large standalone spec, keep only the IDSD-relevant decisions and acceptance evidence
- TDD: when behavior can be captured in focused tests before implementation
- security review: when user input, auth, secrets, permissions, or data exposure are involved
- refactor impact map: when files move, public APIs change, or module boundaries shift

## Gate Selection

- Use `solution_challenger` for ambiguous solution shape, multiple viable approaches, high-cost implementation, or user-requested critique.
- Use `system_designer` for API contracts, persistence, auth, async processing, integrations, migrations, scaling, compatibility, or multi-module boundaries.
- `senior_qa` pre-execution is required for every feature: map ticket AC to edge cases and regression targets before coding; happy-path green alone never passes.
- `senior_qa` post-execution verdict is required after execution returns: read ticket AC plus PR diff, map each AC to code, list affected flows and error-prone edge cases, record covered vs missing with explicit warnings.
- `verifier` is required for every feature: missing negative, permission, concurrency, idempotency, contract, or migration/env paths must be warned explicitly.
- Failing-test loop: max 3 targeted reruns, then stop, record blocker, hand off to bug-fix/debug, escalate effort or ask-user.

## Completion Rule

Do not claim done until evidence matches the acceptance criteria or the gap is stated as a blocker. Do not tick a phase done without a post-execution QA verdict of PASS; on FAIL or BLOCKED, fix and re-verify. Gate the tracker with `scripts/validate_qa_verdict.py --require-pass` instead of trusting prose. Do not claim done when coverage gaps or server-parity risks remain unwarned.
