# Classification Rules

- simple: direct answer, no repo edits
- scan: bounded code search or summary
- idsd: intent-led feature or behavior work where agents should form context, evidence, and phase boundaries before code
- planner/sdd: legacy compatibility path for explicit spec-first requests
- tdd/coding: clear behavior can be implemented
- bug-fix/debug: error, failing test, regression, stack trace
- review: inspect diff/code without modifying
- refactor: move/rename/split/restructure
- orchestrator: multi-phase work with tracker/commits

Pick one primary skill for the current step.
Recommend follow-up skills only when the workflow naturally chains into a later step.
For new feature work, prefer `idsd-orchestrator` before code.
Use `idsd-orchestrator -> repo-phase-orchestrator -> project-indexer` as the generic expanded sequence.
Use `brainstorming -> implementation-spec-writer -> repo-phase-orchestrator` only for legacy or explicit spec-first requests.
Use `brainstorming -> nestjs-sdd-planner -> repo-phase-orchestrator` only when the active stack profile is `nestjs` or when the user explicitly wants the NestJS stage.
Use `brainstorming -> rust-sdd-planner -> repo-phase-orchestrator` only when the active stack profile is `rust` or when the user explicitly wants the Rust stage.
