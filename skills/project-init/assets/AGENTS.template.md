# AGENTS.md

<!-- CODEXMINIMAL:ROUTING START -->
## Always-On Task Router Protocol

Before starting any non-trivial user request, internally run the Task Router Protocol.

This protocol is mandatory for:

- planning
- coding
- debugging
- review
- refactor
- repository scan
- multi-step work
- protected-file work
- env/deployment/database work
- model/effort escalation

For trivial questions, answer directly.

### Router Steps

1. Classify the task as one of:

   - simple
   - scan
   - planner
   - sdd
   - tdd
   - coding
   - bug-fix
   - debug
   - review
   - refactor
   - orchestrator

2. Select the smallest suitable skill:

   - none
   - feature-intake-gate
   - brainstorming
   - project-init
   - project-indexer
   - nestjs-sdd-planner
   - nestjs-tdd-builder
   - nestjs-bug-fixer
   - nestjs-code-reviewer
   - nestjs-refactor-guardian
   - repo-phase-orchestrator

3. Select model/effort.

4. Check safety gates.
5. Rate the highest-risk action.

6. Decide:

   - proceed directly
   - ask user before execution
   - block because protected approval is required

### Pre-Implementation Gate

For new features, changed behavior, or unclear requirements:

1. route through `feature-intake-gate` first
2. complete brainstorm, spec, and phase-plan stages
3. hand execution to an external execution workflow only after that sequence is complete

Do not jump straight from a rough feature prompt into implementation.

### When To Ask User First

Ask before execution if the task:

- touches protected files
- changes folder structure
- changes architecture boundaries
- affects env/deployment/database
- modifies CI/CD
- changes public API contracts
- may break runtime behavior
- spans multiple modules
- requires long fix-test-loop
- requires expensive model/effort escalation

## Action Risk Matrix

Rate the highest-risk action implied by the task:

- `low`: read-only inspection, explanation, or bounded search
- `medium`: normal local code edits, focused tests, doc or index updates
- `high`: protected-file edits, network actions, migrations, commits, wide refactors, or long-running fix loops
- `critical`: destructive shell actions, irreversible data changes, force pushes, or production-impacting deploy/runtime changes

Decision rule:

- `low`: usually proceed
- `medium`: proceed unless another safety gate triggers
- `high`: ask before execution
- `critical`: block until explicit approval and scope confirmation exist

### When To Use `$task-router`

Use `$task-router` explicitly when:

- classification is ambiguous
- multiple skills could apply
- task is risky
- user asks which workflow/model/skill should be used
- user request is large or underspecified

Do not require the user to manually ask for `$task-router`.
The routing protocol must run automatically before non-trivial work.
<!-- CODEXMINIMAL:ROUTING END -->

<!-- CODEXMINIMAL:MODEL_ROUTING START -->
## Model Routing

Default:
- Use `gpt-5.5` for planning, architecture, complex coding, refactor, orchestration.

Use:
- `gpt-5.5 high` for high-risk multi-module work.
- `gpt-5.4-mini` for bounded scan and quick summarization.
- `gpt-5.3-codex` for quick local coding iteration.

Ask before expensive model/effort escalation unless already authorized.
<!-- CODEXMINIMAL:MODEL_ROUTING END -->

<!-- CODEXMINIMAL:RESPONSE_MODE START -->
## Response Mode

Default to `compact` when the user prioritizes speed or the task is straightforward.

Use `standard` when:
- the task is risky
- multiple modules are involved
- the user needs rationale, tradeoffs, or a review-quality explanation

`compact` means:
- shortest useful answer
- no unnecessary recap
- no extra taxonomy unless it helps execution
<!-- CODEXMINIMAL:RESPONSE_MODE END -->

<!-- CODEXMINIMAL:CONTEXT_BUDGET START -->
## Context Budget

Set a context budget before exploration:

- `low`: read indexes first, then at most 5 files
- `medium`: read indexes first, then at most 12 files
- `high`: only for risky, ambiguous, or multi-module work

Budget rules:
- start with the lowest budget that can answer the task
- if budget is exhausted and confidence is still low, reroute or ask the user
- do not broad-scan the repository under `low`
- broad search is a last resort, not a default
<!-- CODEXMINIMAL:CONTEXT_BUDGET END -->

<!-- CODEXMINIMAL:AUTO_COMPACT START -->
## Auto-Compact Policy

When a session becomes long, compact working context by trigger and workflow state, not by a fixed percentage alone.

Compact when:
- `low` or `medium` context budget is close to exhaustion
- exploration is complete and only execution context needs to remain
- several long turns repeat the same state without opening new technical surface

Compact rules:
- keep only active task, current constraints, files touched, pending risks, and next action
- drop repeated recaps and stale exploration branches
- do not compact away unresolved user decisions or protected-file constraints
- a heuristic such as `60%` context usage may support the decision, but should not be the sole trigger
<!-- CODEXMINIMAL:AUTO_COMPACT END -->

<!-- CODEXMINIMAL:SEARCH_POLICY START -->
## Search Policy

Before broad repository search, always use index-first lookup:

1. `docs/ai/context-map.json`
2. `docs/ai/project-index.md`
3. relevant `docs/ai/*-index.md`
4. exact indexed files
5. same folder
6. feature folder
7. parent/shared folders
8. whole repository only as last resort

Do not start with whole-repository search unless indexes are missing or stale.

If indexes are missing:
- use `project-indexer`
- or perform the minimum scan needed, then update indexes

If index conflicts with source code:
- trust source code
- update the index after the task
<!-- CODEXMINIMAL:SEARCH_POLICY END -->

<!-- CODEXMINIMAL:PROJECT_INDEX START -->
## Project Index Usage

Before broad repository search:

1. Read `docs/ai/context-map.json`.
2. Read `docs/ai/project-index.md`.
3. Read relevant `docs/ai/*-index.md`.
4. Search indexed files first.
5. Search sibling files next.
6. Search feature folder next.
7. Search parent/shared folders next.
8. Search whole repository only as last resort.

If index conflicts with source code:
- trust source code
- update the index after the task
<!-- CODEXMINIMAL:PROJECT_INDEX END -->

<!-- CODEXMINIMAL:HELPER_POLICY START -->
## Helper Execution Policy

Prefer deterministic local helpers over prompt-only reconstruction for repetitive repository operations.

Default behavior:
- run available local helper scripts first when they can safely perform the deterministic part of the task
- use prompt-only fallback only when a helper is missing, blocked, or insufficient for the current repository state
- do not push routine helper execution onto the user unless local execution is blocked or explicit manual review is needed
<!-- CODEXMINIMAL:HELPER_POLICY END -->

<!-- CODEXMINIMAL:SKILL_POLICY START -->
## Skill Selection Policy

Use the smallest suitable skill.

### Router

- `task-router`: classify request, select skill/model/effort, check safety gates. Do not modify files.

### Repository Setup

- `project-init`: initialize/sync rules, AGENTS.md, docs/ai, protected files, rule registry.
- `project-init`: also scaffold `docs/codexminimal/current-work.json`, `artifact-registry.json`, and `telemetry.json` for harness state.
- `project-indexer`: build/update project indexes and context-map.

### Pre-Implementation Design

- `feature-intake-gate`: default orchestration for `brainstorm -> spec -> phase plan` before coding.
- `repo-phase-orchestrator`: write phase plan and tracker, then hand off execution.
- `brainstorming`: explore intent, constraints, options, and design direction before specs.
- `nestjs-sdd-planner`: turn an approved direction into a concrete NestJS specification.

### Optional NestJS Profiles

- `nestjs-sdd-planner`: plan/spec only. Do not code.
- `nestjs-bug-fixer`: fix specific bug/failing test/runtime error.
- `nestjs-code-reviewer`: review without modifying files.
- `nestjs-refactor-guardian`: safe structural refactor with impact map.
- `nestjs-tdd-builder`: optional NestJS execution profile when an implementation step should stay in-repo instead of handing off externally.

### Multi-phase Work

- `repo-phase-orchestrator`: orchestrate large phased work with a tracker, verification gates, and external execution handoff.
- keep `docs/codexminimal/current-work.json` and `artifact-registry.json` aligned with the active phase.

### Rule

Do not use a broader skill when a narrower skill is sufficient.
Do not use refactor/orchestrator for simple coding or bug fixes.
Do not skip from rough feature prompt straight to implementation.
<!-- CODEXMINIMAL:SKILL_POLICY END -->

<!-- CODEXMINIMAL:NESTJS_SPEC START -->
## NestJS Specification

- Use standard NestJS TypeScript structure under `src/`.
- Keep controllers thin.
- Put business logic in services.
- Return DTOs from controllers, not TypeORM entities.
- Use DTO validation pipes for request contracts.
- Keep feature modules by domain.
- Keep persistence details inside the feature directory.
- Keep scheduled jobs out of the web app runtime.
- Add cron wiring only through the dedicated jobs app.
- Do not bootstrap helper-side schema from NestJS startup hooks.
- Use explicit runbooks/provisioning steps outside runtime.
- Prefer repository methods with explicit update semantics over `find -> merge -> save`.
<!-- CODEXMINIMAL:NESTJS_SPEC END -->

<!-- CODEXMINIMAL:TESTING_SPEC START -->
## Testing Specification

- Unit tests go under `test/unit/`.
- E2E tests go under `test/e2e/`.
- Mirror source feature path where practical.
- Import source code from tests using explicit relative paths to `src/`.
- `npm test` should exclude e2e specs.
- Run e2e with `npm run test:e2e`.
- Keep Jest unit config rooted at repo root.
- Collect coverage from `src/**/*.(t|j)s`.
<!-- CODEXMINIMAL:TESTING_SPEC END -->

<!-- CODEXMINIMAL:PROTECTED_FILES START -->
## Protected Files Policy

Before editing, read `docs/ai/protected-files.md`.

Never edit protected files unless explicitly allowed in the current task.

If a required change touches protected files:
1. stop
2. explain why it is needed
3. ask for explicit approval
<!-- CODEXMINIMAL:PROTECTED_FILES END -->

<!-- CODEXMINIMAL:USER_RULE_MUTATION START -->
## User Rule Mutation Policy

When the user changes a durable rule, immediately persist it.

Update:
- `docs/ai/rule-registry.md`
- `docs/ai/protected-files.md` if path protection changed
- `docs/ai/architecture-notes.md` if architecture changed
- `AGENTS.md` generated blocks if operational guidance changed

Do not wait until session end.
<!-- CODEXMINIMAL:USER_RULE_MUTATION END -->

<!-- USER CUSTOM RULES START -->
<!-- Add project-specific custom rules here. CodexMinimal must preserve this section. -->
<!-- USER CUSTOM RULES END -->
