# AGENTS.md

Use this file as the Codex entrypoint for the repository. Keep it short; push detailed or frequently changing context into `docs/ai/` and `docs/codexminimal/`.

<!-- CODEXMINIMAL:ROUTING START -->
## Always-On Task Router Protocol

Before any non-trivial task, internally classify the request, choose the smallest suitable skill, select model/effort, rate the highest-risk action, then decide whether to proceed, ask first, or block.

Use `task-router` for ambiguous, risky, multi-step, protected, refactor, review, scan, or orchestration work. For trivial requests, answer directly.

Default feature intake:
1. `feature-intake-gate`
2. `repo-phase-orchestrator`
3. external execution

Do not jump from a rough feature prompt straight into coding. Ask first if the task touches protected files, architecture boundaries, env/deploy/database, CI/CD, public API contracts, or wide multi-module changes.
<!-- CODEXMINIMAL:ROUTING END -->

<!-- CODEXMINIMAL:MODEL_ROUTING START -->
## Model Routing

- `gpt-5.5`: default for planning, architecture, non-trivial coding, refactor, and orchestration
- `gpt-5.5 high`: high-risk multi-module, failing-test, env/deploy/database, or protected-boundary work
- `gpt-5.4-mini`: bounded scan, quick repository search, and summarization
- `gpt-5.3-codex`: quick local coding iteration

Do not escalate model/effort without a concrete reason.
<!-- CODEXMINIMAL:MODEL_ROUTING END -->

<!-- CODEXMINIMAL:RESPONSE_MODE START -->
## Response Mode

Default to `compact` when speed matters. Use `standard` only when risk is higher or the user needs rationale, tradeoffs, or review-quality detail.
<!-- CODEXMINIMAL:RESPONSE_MODE END -->

<!-- CODEXMINIMAL:CONTEXT_BUDGET START -->
## Context Budget

Start with the smallest budget that can answer the task:
- `low`: indexes plus up to 5 files
- `medium`: indexes plus up to 12 files
- `high`: only for risky, ambiguous, or multi-module work

Do not broad-scan the repository under `low`. If confidence stays low after budget is exhausted, reroute or ask the user.
<!-- CODEXMINIMAL:CONTEXT_BUDGET END -->

<!-- CODEXMINIMAL:AUTO_COMPACT START -->
## Auto-Compact Policy

Compact long sessions when budget is getting tight, exploration is done, or repeated turns stop adding new technical surface. Keep only the active task, constraints, touched files, pending risks, next action, and unresolved user decisions.
<!-- CODEXMINIMAL:AUTO_COMPACT END -->

<!-- CODEXMINIMAL:SEARCH_POLICY START -->
## Search Policy

Always go index-first:
1. `docs/ai/context-map.json`
2. `docs/ai/project-index.md`
3. relevant `docs/ai/*-index.md`
4. indexed files
5. local folders
6. repository-wide search only as last resort

If indexes are missing or stale, use `project-indexer`.
<!-- CODEXMINIMAL:SEARCH_POLICY END -->

<!-- CODEXMINIMAL:PROJECT_INDEX START -->
## Project Index Usage

Treat `docs/ai/` as the primary navigation layer. If source code conflicts with an index, trust source code and update the index afterward.
<!-- CODEXMINIMAL:PROJECT_INDEX END -->

<!-- CODEXMINIMAL:HELPER_POLICY START -->
## Helper Execution Policy

Prefer deterministic local helpers for repetitive repository operations such as syncing `AGENTS.md`, bootstrapping docs, validating runtime state, or rendering index stubs. Use prompt-only fallback only when helpers are missing, blocked, or insufficient.
<!-- CODEXMINIMAL:HELPER_POLICY END -->

<!-- CODEXMINIMAL:SKILL_POLICY START -->
## Skill Selection Policy

Use the smallest suitable skill:
- `project-init`: sync `AGENTS.md`, `docs/ai`, `docs/codexminimal`, durable rules, and protected-file guidance
- `project-indexer`: build or repair repository indexes and `context-map.json`
- `feature-intake-gate`: default gate for `brainstorm -> spec -> phase plan`
- `repo-phase-orchestrator`: write the phase plan and tracker, then hand off execution
- `nestjs-sdd-planner`: write specs only
- `nestjs-bug-fixer`, `nestjs-code-reviewer`, `nestjs-refactor-guardian`, `nestjs-tdd-builder`: optional narrower profiles when they fit better than the generic harness flow

Do not use a broader skill when a narrower one is sufficient.
<!-- CODEXMINIMAL:SKILL_POLICY END -->

<!-- CODEXMINIMAL:NESTJS_SPEC START -->
## NestJS Specification

- Keep standard NestJS TypeScript structure under `src/`
- Keep controllers thin and business logic in services
- Return DTOs, not raw TypeORM entities
- Use DTO validation pipes for request contracts
- Keep feature modules by domain
- Keep persistence details inside the feature directory
- Keep scheduled jobs out of the web app runtime
- Do not bootstrap helper-side schema from NestJS startup hooks
- Prefer explicit repository update semantics over `find -> merge -> save`
<!-- CODEXMINIMAL:NESTJS_SPEC END -->

<!-- CODEXMINIMAL:TESTING_SPEC START -->
## Testing Specification

- Unit tests go under `test/unit/`
- E2E tests go under `test/e2e/`
- Mirror source paths where practical
- Import source code from tests via explicit relative paths to `src/`
- Keep Jest unit config at repo root
- Run targeted tests first, then broader lint/build checks only as needed
<!-- CODEXMINIMAL:TESTING_SPEC END -->

<!-- CODEXMINIMAL:PROTECTED_FILES START -->
## Protected Files Policy

Before editing, read `docs/ai/protected-files.md`. If a required change touches a protected file, stop, explain why, and ask for explicit approval first.
<!-- CODEXMINIMAL:PROTECTED_FILES END -->

<!-- CODEXMINIMAL:USER_RULE_MUTATION START -->
## User Rule Mutation Policy

When the user changes a durable rule, persist it immediately in the relevant generated docs such as `docs/ai/rule-registry.md`, `docs/ai/protected-files.md`, `docs/ai/architecture-notes.md`, or the managed AGENTS blocks.
<!-- CODEXMINIMAL:USER_RULE_MUTATION END -->
