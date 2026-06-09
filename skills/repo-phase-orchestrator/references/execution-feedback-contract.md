# Execution Feedback Contract

Execution should return a minimal structured update that the harness can fold back into the tracker, current-work state, and telemetry.

At minimum, execution feedback should include:

- current phase
- changed files
- verification commands actually run
- pass/fail result per command
- failures and fixes
- commit reference if one exists
- blockers
- next phase recommendation
- execution workflow used
- repeated mistakes or repeated review feedback that should be surfaced for explicit user confirmation before the feedback ledger is updated

The harness should not advance phase state without this feedback.

For compact phase execution, keep feedback terse:

- one line for phase outcome
- one list of changed files
- one list of verification commands and exit codes
- one blocker list if blocked
- one next action

Do not paste long command output unless it is the only useful evidence.

If scope drift appears during execution:

- stop
- record the drift in the tracker
- update `current-work.json` blockers
- reroute before continuing
