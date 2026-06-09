# Model Routing

Default:

- use `gpt-5.5` for planning, architecture, non-trivial coding, review, refactor, and orchestration

Use `gpt-5.5 high` for:

- multi-module changes
- risky refactor
- failing tests with unclear cause
- database, migration, env, or deploy work
- protected boundary changes

Use `gpt-5.4` for:

- everyday coding
- focused implementation in a known part of the repository
- ordinary bug fixes with clear reproduction
- short fix-test loops when frontier-level reasoning is not needed

Use `gpt-5.4-mini` for:

- bounded scan
- summarization
- quick repository search
- small risk analysis

Do not route to stale legacy model aliases as current default paths.

If it appears in older prompts, configs, or notes, treat it as a stale migration alias and move to `gpt-5.5`, `gpt-5.4`, or `gpt-5.4-mini` instead.

Do not escalate effort without a concrete risk or verification reason.
