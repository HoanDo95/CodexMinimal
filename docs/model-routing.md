# Model Routing

Default:

- use `gpt-5.5` for planning, architecture, non-trivial coding, review, refactor, and orchestration

Use `gpt-5.5 high` for:

- multi-module changes
- risky refactor
- failing tests with unclear cause
- database, migration, env, or deploy work
- protected boundary changes

Use `gpt-5.4-mini` for:

- bounded scan
- summarization
- quick repository search
- small risk analysis

Use `gpt-5.3-codex` for:

- quick local coding iteration
- low or medium risk edits
- short fix-test loops

Do not escalate effort without a concrete risk or verification reason.
