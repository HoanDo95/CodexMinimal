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

- optional fast local coding fallback
- low or medium risk edits when latency matters more than breadth
- short fix-test loops in a known local environment

Do not escalate effort without a concrete risk or verification reason.
