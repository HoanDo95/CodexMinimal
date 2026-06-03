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

The harness should not advance phase state without this feedback.

If scope drift appears during execution:

- stop
- record the drift in the tracker
- update `current-work.json` blockers
- reroute before continuing
