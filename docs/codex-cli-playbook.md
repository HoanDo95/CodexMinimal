# Codex CLI Playbook

Use Codex CLI surfaces when they add deterministic evidence or an independent review pass. Do not replace skill routing with CLI calls by default.

## Use Skill Workflow First

Use CodexMinimal skills for normal interactive work:

- `task-router` for routing, safety gates, model and effort selection
- `idsd-orchestrator` for new or unclear feature requests
- `project-init` for repository bootstrap or rule/profile sync
- `project-indexer` after code, structure, or index changes
- profile skills only when the active stack profile allows them

## Use `codex review`

Use `codex review` when a diff needs an independent code-review pass:

```bash
codex review --uncommitted
codex review --base main
codex review --commit <sha>
```

Best fit:

- before pushing a non-trivial local diff
- after broad refactors
- before merging profile or router changes
- when user explicitly asks for Codex review

Do not use it as the only verification. Run deterministic checks first.
For private or unpublished diffs, treat `codex review` as a possible external data export and require explicit approval or an approved local policy before running it.
See `docs/review-policy.md` and prefer `scripts/safe_codex_review.sh` for guarded usage.

## Use `codex doctor --json`

Use environment diagnostics when setup, auth, model, or local CLI behavior is unclear:

```bash
codex doctor --json
```

Keep the output redacted when sharing logs.

## Use `codex exec --json`

Use non-interactive execution only when the workflow has a stable schema:

```bash
codex exec --json --output-schema skills/task-router/assets/router-output.schema.json <prompt>
```

Best fit:

- future eval automation
- router or planner regression capture
- machine-readable workflow experiments

Do not wire skills to `codex exec` until the exact runtime contract has been verified in a separate integration pass.
For opt-in LLM evals, use `scripts/run_codex_exec_evals.py` with `CODEXMINIMAL_RUN_LLM_EVALS=1`.
