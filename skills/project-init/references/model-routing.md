# Model Routing

Default:
- Use `gpt-5.5` for most Codex work.

Use `gpt-5.5 medium` for:
- planning
- architecture
- non-trivial coding
- repository analysis
- orchestration

Use `gpt-5.5 high` for:
- multi-module changes
- failing tests with unclear cause
- risky refactor
- database/migration/env/deploy work
- protected boundary changes

Use `gpt-5.4` for:
- everyday coding
- focused implementation in a known part of the repo
- ordinary bug fixes with clear reproduction
- short fix-test loops when frontier-level reasoning is not needed

Use `gpt-5.4-mini` for:
- bounded scan
- summarization
- quick code search
- small risk analysis

Do not route to stale legacy model aliases as current default paths.
If it appears in older notes or configs, treat it as a stale migration alias and move to `gpt-5.5`, `gpt-5.4`, or `gpt-5.4-mini` instead.

Do not escalate effort unless quality, risk, or test evidence justifies it.
