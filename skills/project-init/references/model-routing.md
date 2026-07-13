# Model Routing

Default:
- Use `gpt-5.6-terra` for most Codex work.
- `gpt-5.6` is the current Sol alias in official OpenAI model docs.

Use `gpt-5.6-terra medium` for:
- planning
- normal coding
- repository analysis
- review
- focused implementation

Use `gpt-5.6-sol high` for:
- complex architecture
- non-trivial orchestration
- multi-module changes
- failing tests with unclear cause
- risky refactor
- database/migration/env/deploy work
- protected boundary changes

Use `gpt-5.6-sol medium` only when Terra is insufficient and high effort is not justified.

Use `gpt-5.6-terra` for:
- everyday coding
- focused implementation in a known part of the repo
- ordinary bug fixes with clear reproduction
- short fix-test loops when frontier-level reasoning is not needed

Use `gpt-5.6-luna` for:
- bounded scan
- summarization
- quick code search
- small risk analysis
- cost-sensitive high-volume helper work

Do not route to stale legacy model aliases as current default paths.
If `gpt-5.5`, `gpt-5.4`, or `gpt-5.4-mini` appears in older notes or configs, treat it as a stale migration alias and move to `gpt-5.6-sol`, `gpt-5.6-terra`, or `gpt-5.6-luna` instead.

Do not escalate effort unless quality, risk, or test evidence justifies it.
