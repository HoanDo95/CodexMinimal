# Skills

CodexMinimal keeps skills small and explicit.

## Size Budget

Keep `SKILL.md` files compact:

- core skills should stay under 200 lines
- profile skills should stay under 120 lines
- long policy, matrices, checklists, and heuristics belong in `references/*.md`
- schemas, templates, and sample artifacts belong in `assets/`

This is a hard readiness gate enforced by `check-codexminimal.sh`. Use `references/` first before adding more policy text to a skill entrypoint.

## Routing

- `task-router`: classify the request, select a primary skill, recommend model and effort, decide whether a follow-up skill chain is needed, trigger safety gates, assign response mode plus context budget, and read repeat-feedback constraints before broader exploration

## Core Harness

- `idsd-orchestrator`: default intent-driven workflow for new features and changed behavior; creates intent contracts, agent cards, decision ledgers, and acceptance evidence before phase planning
- `project-init`: create or sync `AGENTS.md`, `docs/ai`, `docs/codexminimal`, durable rules, protected-file guidance, and user-mediated repeat-feedback learning state
- `project-indexer`: build or repair compact repository indexes and `context-map.json`
- `repo-phase-orchestrator`: write phase plans, maintain trackers, refresh harness runtime state, and hand off execution

## Legacy Compatibility Profile

- `feature-intake-gate`: legacy compatibility orchestration for feature intake before implementation
- `implementation-spec-writer`: legacy compatibility stack-agnostic spec writer before phase planning
- `nestjs-sdd-planner`: legacy compatibility writer for explicit old NestJS spec-first requests
- `rust-sdd-planner`: legacy compatibility writer for explicit old Rust spec-first requests

Install only when old SDD-style workflows are still needed:

```bash
CODEXMINIMAL_INSTALL_PROFILES=legacy bash install.sh
```

## Profile Boundary

- `docs/ai/stack-profile.md` is the source of truth for stack-specific assumptions
- default profile is `generic`
- profile-specific skills should be used only when the active profile allows them

## External Stage And Execution Skills

- `brainstorming`: explore intent, constraints, options, and tradeoffs before design is fixed
- `subagent-driven-development`: optional execution adapter path after a current phase is ready
- `executing-plans`: external fallback for plan execution when subagent-driven execution is not desired

## Optional Execution Profiles

- `nestjs-tdd-builder`: implement clear behavior with tests first
- `nestjs-bug-fixer`: reproduce, isolate, fix, and regression-test a specific bug
- `nestjs-code-reviewer`: inspect code or diffs without editing
- `nestjs-refactor-guardian`: manage risky structural changes with impact and rollback boundaries
- `rust-tdd-builder`: implement clear Rust behavior with tests first
- `rust-bug-fixer`: reproduce, isolate, fix, and regression-test a specific Rust bug
- `rust-code-reviewer`: inspect Rust code or diffs without editing
- `rust-refactor-guardian`: manage risky Rust structural changes with impact and rollback boundaries

## Selection Rule

Pick one primary skill for the current step.

Add follow-up skills only when the workflow naturally chains into a later step, such as:

- `feature-intake-gate -> repo-phase-orchestrator` for legacy compatibility
- `idsd-orchestrator -> repo-phase-orchestrator -> project-indexer`
- `brainstorming -> profile-specific execution profile -> repo-phase-orchestrator`
- `implementation-spec-writer -> repo-phase-orchestrator` for legacy compatibility
- `nestjs-bug-fixer -> project-indexer`
- `nestjs-refactor-guardian -> project-indexer`
- `rust-bug-fixer -> project-indexer`
- `rust-refactor-guardian -> project-indexer`

## Deterministic Helpers

- `scripts/sync_agents_blocks.py`: sync managed AGENTS blocks from the template
- `scripts/bootstrap_docs_ai.py`: create missing `docs/ai` files from bundled templates or assets
- `scripts/bootstrap_harness_runtime.py`: create missing `docs/codexminimal` runtime files from bundled templates or assets
- `scripts/record_feedback_issue.py`: record explicit user-confirmed feedback into the ledger before promotion
- `scripts/promote_feedback_rules.py`: promote repeated feedback into durable rules after the configured strike threshold
- `scripts/validate_context_map.py`: validate `context-map.json` structure
- `scripts/validate_harness_runtime.py`: validate `current-work.json`, `artifact-registry.json`, `telemetry.json`, and `feedback-ledger.json`
- `scripts/render_index_stubs.py`: render missing docs/ai index stubs from templates

## Tool Adapter Surfaces

Use tool adapters when they provide stronger automation than prompt-only workflow:

- `review adapter`: review staged, unstaged, branch, commit, or PR changes
- `diagnostic adapter`: capture redacted machine-readable environment diagnostics
- `eval adapter`: run schema-shaped non-interactive workflows for future eval or router automation
- `execution adapter`: execute an approved phase plan and return evidence

These are documented as extension surfaces in this pilot. Do not make existing skills depend on one tool until a separate integration pass has verified the exact runtime contract.

See `docs/tool-adapter-playbook.md` for the operating playbook.
