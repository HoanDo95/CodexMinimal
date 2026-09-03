# Verification Policy

Run:
1. targeted tests first
2. affected broader tests
3. lint if available
4. build if available
5. invariant/safety checks if relevant
6. senior QA edge-case and regression evidence when selected

These commands may be executed by Codex CLI native execution or another selected adapter, but the tracker must record whether they passed.
Telemetry should also record whether required checks passed before the next phase opens.

Do not move to next phase with failing required checks.
Do not move to next phase with unresolved QA evidence gaps unless they are explicitly accepted as residual risk in the tracker.

Before a phase is considered complete, commit only clean scoped work: check changed files, drop generated artifacts, ensure no `.env` or secrets, ensure the tracker is updated and required checks passed. Do not accept unrelated changes into the phase summary.
