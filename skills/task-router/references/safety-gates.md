# Safety Gates

Ask before execution when task:
- touches protected files
- modifies deploy/CI/env/database
- changes architecture/folder structure
- spans multiple modules
- changes public API contracts
- requires high effort/model escalation
- may break runtime behavior

Also rate the highest-risk action:

- low: read-only or advisory work
- medium: normal local edits and focused verification
- high: protected edits, commits, migrations, network actions, broad refactors
- critical: destructive or production-impacting actions
