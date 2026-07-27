# Phase Flow

1. Read approved spec and intent contract.
2. Confirm selected quality gates from the IDSD agent cards: `solution_challenger`, `system_designer`, `senior_qa`, reviewer, or verifier.
3. Fold selected gate evidence into planning:
   - solution challenge informs chosen approach, rejected options, and residual risk
   - system design informs API, data, auth, integration, async, migration, compatibility, and architecture boundaries
   - senior QA informs edge cases, regression targets, permissions, concurrency, idempotency, and acceptance evidence
4. Draft the full detailed phase plan first so phase order and dependencies stay continuous.
5. If the full plan exceeds 200 lines, split only then:
   - root plan stays an index with intent summary, gate summary, phase map, dependencies, and links
   - per-phase plan files contain detailed executable steps and stay under 200 lines each
   - each phase file includes enough previous/next handoff context to avoid a broken sequence
6. Write or refresh tracker.
7. Refresh artifact registry and current-work state.
8. Determine current phase.
9. Handoff the current phase to Codex CLI native execution by default, or to another selected adapter when policy requires it.
10. Collect verification and QA gate status from execution.
11. Update tracker and telemetry with phase outcome, intent alignment, delivered work, remaining gaps, and next-phase handoff.
12. Stop before the next phase until status is clean.
