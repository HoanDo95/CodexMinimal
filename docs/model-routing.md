# Model Routing

Default to the cheapest capable model and effort. Never hardcode concrete model names into routing guidance; the tool selects the model.

Escalate the tier only for:

- complex architecture
- non-trivial orchestration
- multi-module changes
- risky refactor
- failing tests with unclear cause
- database, migration, env, or deploy work
- protected boundary changes

Use the default tier for:

- everyday coding
- focused implementation in a known part of the repository
- ordinary bug fixes with clear reproduction
- short fix-test loops when frontier-level reasoning is not needed
- bounded scan, summarization, and quick repository search

Do not escalate effort without a concrete risk or verification reason.
