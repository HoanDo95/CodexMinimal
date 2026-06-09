# Review Adapter Policy

A review adapter is useful as an independent review pass, but it may send repository diffs to an external service. Treat it as an explicit data-export action unless the adapter is proven local-only.

## Allowed Use

Run a review adapter only after deterministic checks pass and one of these is true:

- the repository or diff is approved for external review
- the user explicitly approves the current review scope
- organization policy allows external review for this repository

## Review Scope

Prefer the smallest useful scope:

- one committed change
- one branch-level diff
- local uncommitted work only when explicitly approved for external review

## Required Guardrails

- Do not run on secrets, credentials, private keys, `.env` files, or production-only config.
- Do not use it as the only verification.
- Run deterministic checks first.
- Keep findings separate from test results.
- Record when review was skipped because external review was not approved.

## Adapter Wrapper

If a concrete adapter is added later, its wrapper should enforce:

- explicit opt-in for external review
- sensitive-path refusal before upload or execution
- clear scope arguments
- captured review evidence location
