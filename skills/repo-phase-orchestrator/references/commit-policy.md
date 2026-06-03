# Commit Policy

If the execution workflow commits, commit only clean scoped work.

Before a phase is considered complete:
- check changed files
- remove generated artifacts
- remove `dist/`
- remove `*.tsbuildinfo`
- ensure no `.env` or secrets
- ensure tracker is updated
- ensure required checks passed

Do not accept unrelated changes into the phase summary.
