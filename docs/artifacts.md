# Artifacts

CodexMinimal currently separates artifacts by stage.

## IDSD Intent Package

Written by `idsd-orchestrator` by default:

- `docs/codexminimal/idsd/YYYY-MM-DD-<topic>-intent.md`

The package contains intent contract, solution challenge, system design gate, ADR-style decisions, bounded specification, task breakdown, QA evidence, test contract, selected agent cards, acceptance evidence, implementation handoff, verification, and report outline.

Scaffold with:

```bash
python3 scripts/scaffold_idsd_intent.py --topic "<topic>" --intent "<intent>"
```

For evidence collection, create a full trace folder with:

```bash
python3 scripts/start_idsd_trace.py \
  --topic "<topic>" \
  --intent "<intent>" \
  --stack nestjs
```

Trace folders are written to:

- `docs/codexminimal/idsd-traces/<topic>/`

See [IDSD Usage Guide](idsd-usage-guide.md) for target-project usage.

## Phase Plan

Written by `repo-phase-orchestrator`:

- `docs/codexminimal/plans/YYYY-MM-DD-<topic>-phase-plan.md`

Each individual plan file should stay concise: maximum 200 lines.
Draft the full detailed plan first so the phase sequence and dependencies are clear.
If the full plan would exceed 200 lines, split only then:

- keep the root plan as an index with intent summary, selected gate summary, phase map, dependencies, and links
- keep each per-phase plan file under 200 lines
- include previous/next handoff context in every phase file so execution does not become disconnected

## Tracker

Written by `repo-phase-orchestrator`:

- `docs/codexminimal/trackers/YYYY-MM-DD-<topic>-tracker.md`

The tracker records status plus handoff evidence: what the completed phase delivered, how it maps back to the original intent, selected gate status, remaining gaps, and what the next phase must do based on the completed phase.

## Harness Runtime State

Maintained by `project-init` and `repo-phase-orchestrator`:

- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`
- `docs/codexminimal/feedback-ledger.json`

`feedback-ledger.json` is the repeat-feedback memory surface. It records issue keys, strike counts, and promoted rule text. It should be updated only from explicit user-confirmed feedback or another explicitly approved review authority. Once an issue reaches the configured threshold, it should be treated as a durable rule and synchronized into `docs/ai/rule-registry.md`.

## Execution

Execution itself is expected to be handed to a tool adapter, agent runtime, CI workflow, or team-specific executor after IDSD and phase planning have bounded the work.
