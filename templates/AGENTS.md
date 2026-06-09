# AGENTS.md

Use this file as the Codex entrypoint for the repository. Keep it short; push detailed or frequently changing context into `docs/ai/` and `docs/codexminimal/`.

<!-- CODEXMINIMAL:ROUTING START -->
## Always-On Task Router Protocol

Before any non-trivial task, internally classify the request, choose the smallest suitable skill, select model/effort, rate the highest-risk action, then decide whether to proceed, ask first, or block.

Use `task-router` for ambiguous, risky, multi-step, protected, refactor, review, scan, or orchestration work. For trivial requests, answer directly.

Default feature intake:
1. `idsd-orchestrator`
2. `repo-phase-orchestrator`
3. tool adapter execution

Do not jump from a rough feature prompt straight into coding. Capture intent, agent cards, decision evidence, acceptance evidence, and phase boundaries first. Ask first if the task touches protected files, architecture boundaries, env/deploy/database, CI/CD, public API contracts, or wide multi-module changes.
<!-- CODEXMINIMAL:ROUTING END -->

<!-- CODEXMINIMAL:MODEL_ROUTING START -->
## Model Routing

- `gpt-5.5`: default for planning, architecture, non-trivial coding, refactor, and orchestration
- `gpt-5.5 high`: high-risk multi-module, failing-test, env/deploy/database, or protected-boundary work
- `gpt-5.4`: balanced fallback for clear everyday coding and focused fix-test loops
- `gpt-5.4-mini`: bounded scan, quick repository search, and summarization
- Do not route to stale legacy model aliases as current default paths

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
4. `docs/codexminimal/feedback-ledger.json`
5. indexed files
6. local folders
7. repository-wide search only as last resort

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
- `idsd-orchestrator`: default gate for intent contract, agent cards, decision ledger, acceptance evidence, and phase-plan handoff
- `feature-intake-gate`: legacy compatibility gate for `brainstorm -> spec -> phase plan`
- `repo-phase-orchestrator`: write the phase plan and tracker, then hand off execution
- profile-specific skills only after the active stack profile is clear
- `nestjs-sdd-planner`, `nestjs-bug-fixer`, `nestjs-code-reviewer`, `nestjs-refactor-guardian`, `nestjs-tdd-builder`: optional NestJS profile skills
- `rust-sdd-planner`, `rust-bug-fixer`, `rust-code-reviewer`, `rust-refactor-guardian`, `rust-tdd-builder`: optional Rust profile skills

Do not use a broader skill when a narrower one is sufficient.
<!-- CODEXMINIMAL:SKILL_POLICY END -->

<!-- CODEXMINIMAL:STACK_PROFILE START -->
## Stack Profile

- Read `docs/ai/stack-profile.md` before applying stack-specific assumptions
- Default to `generic` until the repository structure or explicit user instruction activates a profile
- Use profile-specific skills only when the active profile supports them
- Keep stack-specific rules in the profile manifest or rule registry, not in this entrypoint
<!-- CODEXMINIMAL:STACK_PROFILE END -->

<!-- CODEXMINIMAL:TESTING_SPEC START -->
## Testing Specification

- Keep tests outside production source folders when the repo convention supports it
- Mirror source paths where practical
- Use the repository's native test entrypoints and config files
- Keep test imports and structure consistent with the active stack profile
- Run targeted tests first, then broader lint/build checks only as needed
<!-- CODEXMINIMAL:TESTING_SPEC END -->

<!-- CODEXMINIMAL:PROTECTED_FILES START -->
## Protected Files Policy

Before editing, read `docs/ai/protected-files.md`. If a required change touches a protected file, stop, explain why, and ask for explicit approval first.
<!-- CODEXMINIMAL:PROTECTED_FILES END -->

<!-- CODEXMINIMAL:USER_RULE_MUTATION START -->
## User Rule Mutation Policy

When the user changes a durable rule, persist it immediately in the relevant generated docs such as `docs/ai/rule-registry.md`, `docs/ai/protected-files.md`, `docs/ai/architecture-notes.md`, or the managed AGENTS blocks. If explicit user-confirmed repeat feedback reaches the promotion threshold in `docs/codexminimal/feedback-ledger.json`, treat the promoted rule as durable and sync it into `docs/ai/rule-registry.md`.
<!-- CODEXMINIMAL:USER_RULE_MUTATION END -->
