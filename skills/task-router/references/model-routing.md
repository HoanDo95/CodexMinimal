# Model Routing

Default to the cheapest capable model and effort for the task. Escalate the tier only when risk justifies it:

- complex architecture or non-trivial orchestration
- multi-module changes or risky refactor
- failing tests with unclear cause
- database, migration, env, or deployment work
- protected boundaries

Never hardcode concrete model names into routing output; the tool selects the model. Describe the tier (default or escalated) and the reason.

Do not recommend high effort unless risk justifies it.
