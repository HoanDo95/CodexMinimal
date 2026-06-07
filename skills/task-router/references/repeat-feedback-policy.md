# Repeat Feedback Policy

If `docs/codexminimal/feedback-ledger.json` exists:

- read it before routing non-trivial work
- treat `status: promoted` entries as user-confirmed durable non-regression rules
- treat `status: watch` entries as user-confirmed repeat-risk warnings that deserve extra scrutiny
- do not reintroduce promoted issues unless the user explicitly changes the rule
