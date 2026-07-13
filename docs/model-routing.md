# Model Routing

Default:

- use `gpt-5.6-terra` for everyday CodexMinimal routing, planning, normal coding, and review
- `gpt-5.6` is the current Sol alias in official OpenAI model docs

Use `gpt-5.6-sol high` for:

- complex architecture
- non-trivial orchestration
- multi-module changes
- risky refactor
- failing tests with unclear cause
- database, migration, env, or deploy work
- protected boundary changes

Use `gpt-5.6-terra` for:

- everyday coding
- focused implementation in a known part of the repository
- ordinary bug fixes with clear reproduction
- short fix-test loops when frontier-level reasoning is not needed

Use `gpt-5.6-luna` for:

- bounded scan
- summarization
- quick repository search
- small risk analysis
- cost-sensitive high-volume helper work

Use `gpt-5.6-sol medium` only when Terra is not enough and the task is still not high risk.

Do not route to stale legacy model aliases as current default paths.

If `gpt-5.5`, `gpt-5.4`, or `gpt-5.4-mini` appears in older prompts, configs, or notes, treat it as a stale migration alias and move to `gpt-5.6-sol`, `gpt-5.6-terra`, or `gpt-5.6-luna` instead.

Do not escalate effort without a concrete risk or verification reason.
