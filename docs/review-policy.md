# Codex Review Policy

`codex review` is useful as an independent review pass, but it may send repository diffs to an external service. Treat it as an explicit data-export action.

## Allowed Use

Run `codex review` only after deterministic checks pass and one of these is true:

- the repository or diff is approved for external review
- the user explicitly approves the current review scope
- organization policy allows external review for this repository

## Review Scope

Prefer the smallest useful scope:

- `codex review --commit <sha>` for one committed change
- `codex review --base <branch>` for a branch-level review
- `codex review --uncommitted` only for local work explicitly approved for external review

## Required Guardrails

- Do not run on secrets, credentials, private keys, `.env` files, or production-only config.
- Do not use it as the only verification.
- Run deterministic checks first.
- Keep findings separate from test results.
- Record when review was skipped because external review was not approved.

## Safe Wrapper

Use the bundled wrapper when possible:

```bash
CODEXMINIMAL_ALLOW_EXTERNAL_REVIEW=1 scripts/safe_codex_review.sh --commit <sha>
```

Without `CODEXMINIMAL_ALLOW_EXTERNAL_REVIEW=1`, the wrapper refuses to run.
