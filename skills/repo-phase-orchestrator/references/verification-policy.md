# Verification Policy

Run:
1. targeted tests first
2. affected broader tests
3. lint if available
4. build if available
5. invariant/safety checks if relevant

These commands may be executed by Codex CLI native execution or another selected adapter, but the tracker must record whether they passed.
Telemetry should also record whether required checks passed before the next phase opens.

Do not move to next phase with failing required checks.
