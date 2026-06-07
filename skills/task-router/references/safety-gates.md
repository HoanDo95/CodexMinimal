# Safety Gates

Require user confirmation before execution if the task:

- touches protected files
- changes folder structure
- changes architecture boundaries
- affects env/deployment/database
- modifies CI/CD
- changes public API contracts
- may break runtime behavior
- spans multiple modules
- requires long fix-test-loop
- requires expensive model/effort escalation

# Action Risk Matrix

Classify the highest-risk action implied by the task:

- `low`: read-only analysis, summaries, local search, non-destructive inspection
- `medium`: normal local code edits, focused tests, index or docs updates
- `high`: protected-file edits, networked actions, database or migration work, commits, wide refactors, long-running fix loops
- `critical`: destructive shell actions, irreversible data changes, force pushes, production-impacting runtime or deploy changes

Routing rule:

- `low` usually maps to `proceed`
- `medium` usually maps to `proceed` unless another safety gate triggers
- `high` usually maps to `ask-user`
- `critical` maps to `blocked` until explicit approval and scope confirmation exist
