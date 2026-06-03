# Artifacts

CodexMinimal currently separates artifacts by stage.

## Brainstorm Design

Written by external `brainstorming`:

- `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`

## Implementation Spec

Written by `implementation-spec-writer` by default, or by a profile-specific spec skill such as `nestjs-sdd-planner`:

- `docs/codexminimal/specs/YYYY-MM-DD-<topic>-spec.md`

## Phase Plan

Written by `repo-phase-orchestrator`:

- `docs/codexminimal/plans/YYYY-MM-DD-<topic>-phase-plan.md`

Each individual plan file should stay concise: maximum 200 lines.
If planning would exceed that limit, split it into phase files and keep the root plan as an index.

## Tracker

Written by `repo-phase-orchestrator`:

- `docs/codexminimal/trackers/YYYY-MM-DD-<topic>-tracker.md`

## Harness Runtime State

Maintained by `project-init` and `repo-phase-orchestrator`:

- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`
- `docs/codexminimal/feedback-ledger.json`

`feedback-ledger.json` is the repeat-feedback memory surface. It records issue keys, strike counts, and promoted rule text. Once an issue reaches the configured threshold, it should be treated as a durable rule and synchronized into `docs/ai/rule-registry.md`.

## Execution

Execution itself is expected to be handed to external Superpowers skills such as:

- `subagent-driven-development`
- `executing-plans`
