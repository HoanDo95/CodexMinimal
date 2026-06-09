# Evals

CodexMinimal should be evaluated at the workflow level, not only the file-structure level.

In practice, evals in this repository serve two roles:

- maintainers use them as regression checks when prompts, templates, routing, or helper scripts change
- advanced users can extend them to improve the skill pack for their own repositories and workflows

## What To Evaluate

- router classification and safety-gate decisions
- IDSD pipeline completeness: intent, ADR, bounded spec, task breakdown, tests, implementation handoff, verification, and report
- planner output completeness
- phase-plan and tracker handoff completeness
- indexer output consistency
- protected-file handling
- compact-mode and context-budget routing decisions
- model-routing regressions after prompt or model changes

## Suggested Evaluation Layers

1. local structural checks
2. golden prompt cases
3. workflow traces from real repositories
4. graders or dataset-based evals when behavior stabilizes

## Adapter Automation

For future automation, prefer adapter output with JSON and a schema file over freeform text capture.
Use adapter evals only after validating the exact input/output contract for the selected runtime.
The current bundled evals remain deterministic sample fixtures and do not require any external LLM tool.

Minimum eval-adapter contract:

- input: case file, schema file, repo root, and explicit runtime selection
- output: machine-readable result file plus captured evidence
- failure modes: runtime unavailable, schema mismatch, unsafe export policy, or grader failure
- policy: opt-in only; never part of default readiness

## Starter Assets

See the `evals/` folder for golden cases that can be used as a starting point for manual or automated checks.

To grade a results file against the task-router golden cases:

```bash
python3 evals/run-golden-evals.py \
  --cases evals/task-router-golden-cases.json \
  --results evals/samples/task-router-results.sample.json
```

To grade IDSD orchestrator sample cases:

```bash
python3 evals/run-golden-evals.py \
  --cases evals/idsd-orchestrator-golden-cases.json \
  --results evals/samples/idsd-orchestrator-results.sample.json
```

To run all bundled sample evals:

```bash
bash evals/run-sample-evals.sh
```

Legacy evals are opt-in so the default sample run stays focused on the IDSD core:

```bash
CODEXMINIMAL_RUN_LEGACY_EVALS=1 bash evals/run-sample-evals.sh
```

The readiness check also runs install smoke tests for `core`, `nestjs`, `rust`, and `nestjs,rust` in temporary `CODEX_HOME` directories.

## Recommended Practice

- run golden cases after changing prompts or templates
- test against at least one real target repository
- if you ship the NestJS profile, test against at least one real NestJS repository
- if you ship the Rust profile, test against at least one real Rust repository or template
- review failures by category: routing, safety, indexing, planning, or output format
- keep starter cases small and deterministic so they stay useful as smoke tests

## What Evals Are Not

The bundled evals are not a substitute for real-repository trials.

They are best treated as:

- smoke tests for expected skill behavior
- regression checks for future prompt or workflow edits
- a starter harness that users or maintainers can expand when real cases appear
