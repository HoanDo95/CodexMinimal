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

Use `gpt-5.4-mini` for:
- bounded scan
- summarization
- quick code search
- small risk analysis

Use `gpt-5.3-codex` for:
- optional fast local coding fallback
- low/medium risk edits when latency matters more than breadth
- fast feedback loops in a known local environment

Do not escalate effort unless quality, risk, or test evidence justifies it.
