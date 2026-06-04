# Skills

CodexMinimal keeps skills small and explicit.

## Routing

- `task-router`: classify the request, select a primary skill, recommend model and effort, decide whether a follow-up skill chain is needed, trigger safety gates, assign response mode plus context budget, and read repeat-feedback constraints before broader exploration

## Core Harness

- `feature-intake-gate`: default orchestration for feature intake before implementation
- `implementation-spec-writer`: default stack-agnostic spec writer before phase planning
- `project-init`: create or sync `AGENTS.md`, `docs/ai`, `docs/codexminimal`, durable rules, protected-file guidance, and user-mediated repeat-feedback learning state
- `project-indexer`: build or repair compact repository indexes and `context-map.json`
- `repo-phase-orchestrator`: write phase plans, maintain trackers, refresh harness runtime state, and hand off execution

## Profile Boundary

- `docs/ai/stack-profile.md` is the source of truth for stack-specific assumptions
- default profile is `generic`
- profile-specific skills should be used only when the active profile allows them

## External Stage And Execution Skills

- `brainstorming`: explore intent, constraints, options, and tradeoffs before design is fixed
- `subagent-driven-development`: recommended external execution path after a current phase is ready
- `executing-plans`: external fallback for plan execution when subagent-driven execution is not desired

## Profile-Specific Skills

- `nestjs-sdd-planner`: write a concise implementation-ready specification for NestJS repos

## Optional Or Legacy Execution Profiles

- `nestjs-tdd-builder`: implement clear behavior with tests first
- `nestjs-bug-fixer`: reproduce, isolate, fix, and regression-test a specific bug
- `nestjs-code-reviewer`: inspect code or diffs without editing
- `nestjs-refactor-guardian`: manage risky structural changes with impact and rollback boundaries

## Selection Rule

Pick one primary skill for the current step.

Add follow-up skills only when the workflow naturally chains into a later step, such as:

- `feature-intake-gate -> repo-phase-orchestrator`
- `brainstorming -> implementation-spec-writer -> repo-phase-orchestrator`
- `brainstorming -> profile-specific spec writer -> repo-phase-orchestrator`
- `implementation-spec-writer -> repo-phase-orchestrator`
- `nestjs-sdd-planner -> repo-phase-orchestrator`
- `nestjs-bug-fixer -> project-indexer`
- `nestjs-refactor-guardian -> project-indexer`

## Deterministic Helpers

- `scripts/sync_agents_blocks.py`: sync managed AGENTS blocks from the template
- `scripts/bootstrap_docs_ai.py`: create missing `docs/ai` files from bundled templates or assets
- `scripts/bootstrap_harness_runtime.py`: create missing `docs/codexminimal` runtime files from bundled templates or assets
- `scripts/record_feedback_issue.py`: record explicit user-confirmed feedback into the ledger before promotion
- `scripts/promote_feedback_rules.py`: promote repeated feedback into durable rules after the configured strike threshold
- `scripts/validate_context_map.py`: validate `context-map.json` structure
- `scripts/validate_harness_runtime.py`: validate `current-work.json`, `artifact-registry.json`, `telemetry.json`, and `feedback-ledger.json`
- `scripts/render_index_stubs.py`: render missing docs/ai index stubs from templates
