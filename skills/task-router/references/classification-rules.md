# Classification Rules

- simple: direct answer, no repo edits
- scan: bounded code search or summary
- idsd: intent-led feature or behavior work where agents should form context, evidence, and phase boundaries before code
- planner: phase planning or task sequencing after intent and decisions are clear
- tdd/coding: clear behavior can be implemented
- bug-fix/debug: error, failing test, regression, stack trace
- review: inspect diff/code without modifying
- refactor: move/rename/split/restructure
- orchestrator: multi-phase work with tracker/commits

Pick one primary skill for the current step.
Recommend follow-up skills only when the workflow naturally chains into a later step.
For new feature work, prefer `idsd-orchestrator` before code.
Use `idsd-orchestrator -> repo-phase-orchestrator -> project-indexer` as the generic expanded sequence.
Treat standalone document-heavy specs as external input. Summarize their usable decisions into the IDSD bounded specification instead of routing to a separate spec planner.
