# Tool Adapter Playbook

Use tool adapters when they add deterministic evidence, independent review, diagnostics, or plan execution. Do not replace skill routing with adapter calls by default.

## Use Skill Workflow First

Use CodexMinimal skills for normal interactive work:

- `task-router` for routing, safety gates, model and effort selection
- `idsd-orchestrator` for new or unclear feature requests
- `project-init` for repository bootstrap or rule/profile sync
- `project-indexer` after code, structure, or index changes
- profile skills only when the active stack profile allows them

## Review Adapter

Use a review adapter when a diff needs an independent code-review pass.

The adapter may target unstaged changes, staged changes, a branch diff, a commit, or a pull request.

Best fit:

- before pushing a non-trivial local diff
- after broad refactors
- before merging profile or router changes
- when the user explicitly asks for an external review pass

Do not use it as the only verification. Run deterministic checks first.
For private or unpublished diffs, treat the adapter as a possible external data export and require explicit approval or an approved local policy before running it.
See `docs/review-policy.md` for guarded usage.

## Diagnostic Adapter

Use environment diagnostics when setup, auth, model, or local runtime behavior is unclear.

Keep diagnostic output redacted when sharing logs.

## Eval Adapter

Use non-interactive eval execution only when the workflow has a stable schema.

Minimum contract:

- input: cases, repo root, runtime selector, optional output schema
- output: machine-readable results and captured evidence
- failure: unavailable runtime, policy denial, schema mismatch, or grader failure
- policy: opt-in only

Best fit:

- future eval automation
- router, IDSD, or planner regression capture
- machine-readable workflow experiments

Do not wire skills to a specific eval adapter until the exact runtime contract has been verified in a separate integration pass.

## Execution Adapter

Use execution adapters after IDSD and phase planning have created bounded work:

```text
Intent -> IDSD artifacts -> phase plan -> execution adapter -> verification evidence
```

The adapter must report what it changed, how it verified the change, and where evidence was stored.
