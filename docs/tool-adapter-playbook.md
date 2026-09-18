# Tool Adapter Playbook

Use native tool execution (Codex CLI or OpenCode build agent) by default after CodexMinimal has selected the route and bounded the phase. Use other tool adapters when they add deterministic evidence, independent review, diagnostics, or a repository-selected execution runtime.

Do not replace skill routing with adapter calls by default.

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

## Native Execution And Execution Adapters

Use native tool execution after IDSD and phase planning have created bounded work:

```text
Intent -> ADR -> bounded spec -> tasks -> tests -> phase plan -> native tool execution -> verification evidence -> report
```

Another execution adapter can replace native execution only when the user, repository policy, CI environment, or security boundary requires it.

The execution step must report what it changed, how it verified the change, and where evidence was stored.

## OpenCode Execution Adapter

OpenCode is a supported execution adapter. Skills install into OpenCode via:

```bash
bash install.sh --target opencode   # ~/.config/opencode/skills
bash install.sh --target all        # both Codex and OpenCode
```

Mapping:

- skill discovery: OpenCode loads the same `SKILL.md` files through its native `skill` tool; no format conversion needed
- native execution: OpenCode `build` agent (primary) instead of Codex CLI; `@general` / `@explore` subagents for multi-step work and read-only exploration
- repo rules: `AGENTS.md` is shared; OpenCode reads the same file
- `.codex-plugin/plugin.json` is Codex-only and ignored by OpenCode

See [OpenCode Adapter](opencode-adapter.md) for the full mapping.
