# Model Routing

Use:

- `gpt-5.5 medium` for planning, architecture, normal coding, debugging, review, and orchestration.
- `gpt-5.5 high` for multi-module changes, risky refactor, failing tests with unclear cause, database/env/deployment work, or protected boundaries.
- `gpt-5.4 medium` for everyday coding, focused implementation, and normal fix-test loops when the task is clear and does not need frontier-level reasoning.
- `gpt-5.4-mini low` for bounded scan, quick summarization, or simple risk analysis.

Do not recommend stale legacy model aliases as active routing targets.

Do not recommend high effort unless risk justifies it.
