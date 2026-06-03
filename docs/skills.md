# Skills

CodexMinimal keeps skills small and explicit.

## Routing

- `task-router`: classify the request, select a primary skill, recommend model and effort, decide whether a follow-up skill chain is needed, trigger safety gates, and assign response mode plus context budget before broader exploration

## Core Harness

- `feature-intake-gate`: default orchestration for feature intake before implementation
- `project-init`: create or sync `AGENTS.md`, `docs/ai`, `docs/codexminimal`, durable rules, and protected-file guidance
- `project-indexer`: build or repair compact repository indexes and `context-map.json`
- `repo-phase-orchestrator`: write phase plans, maintain trackers, refresh harness runtime state, and hand off execution

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
- `brainstorming -> nestjs-sdd-planner -> repo-phase-orchestrator`
- `nestjs-sdd-planner -> repo-phase-orchestrator`
- `nestjs-bug-fixer -> project-indexer`
- `nestjs-refactor-guardian -> project-indexer`

## Deterministic Helpers

- `scripts/sync_agents_blocks.py`: sync managed AGENTS blocks from the template
- `scripts/bootstrap_docs_ai.py`: create missing `docs/ai` files from templates
- `scripts/bootstrap_harness_runtime.py`: create missing `docs/codexminimal` runtime files from templates
- `scripts/validate_context_map.py`: validate `context-map.json` structure
- `scripts/validate_harness_runtime.py`: validate `current-work.json`, `artifact-registry.json`, and `telemetry.json`
- `scripts/render_index_stubs.py`: render missing docs/ai index stubs from templates
