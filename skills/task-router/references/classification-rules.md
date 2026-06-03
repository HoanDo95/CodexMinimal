# Classification Rules

- simple: direct answer, no repo edits
- scan: bounded code search or summary
- planner/sdd: requirement needs brainstorming, spec, or implementation plan before code
- tdd/coding: clear behavior can be implemented
- bug-fix/debug: error, failing test, regression, stack trace
- review: inspect diff/code without modifying
- refactor: move/rename/split/restructure
- orchestrator: multi-phase work with tracker/commits

Pick one primary skill for the current step.
Recommend follow-up skills only when the workflow naturally chains into a later step.
For new feature work, prefer `feature-intake-gate` before code.
Use `brainstorming -> nestjs-sdd-planner -> repo-phase-orchestrator` only as the expanded internal sequence or when the user explicitly wants a single stage.
