# Benchmark

This benchmark reflects the current local harness only.

It does not measure real-repository feature delivery yet.

It also does not replace official model benchmarks from OpenAI.

## Scope

Measured on `2026-06-03` inside the local CodexMinimal workspace.

What is covered:

- local readiness validation
- bundled sample eval grading
- deterministic helper execution on temporary repositories

What is not covered:

- multi-turn work on a real target repository
- token usage over long feature delivery sessions
- model latency under remote API load
- end-to-end quality differences between Codex CLI models

## Commands

```bash
bash check-codexminimal.sh
bash evals/run-sample-evals.sh
python3 scripts/bootstrap_docs_ai.py --templates-dir templates/docs-ai --repo-root /tmp/example-repo
python3 scripts/bootstrap_harness_runtime.py --templates-dir templates/docs-codexminimal --repo-root /tmp/example-repo
python3 scripts/render_index_stubs.py --assets-dir skills/project-indexer/assets --docs-ai-dir /tmp/example-repo/docs/ai
python3 scripts/validate_context_map.py --file templates/docs-ai/context-map.json
python3 scripts/validate_harness_runtime.py --repo-root /tmp/example-repo
python3 scripts/sync_agents_blocks.py --template templates/AGENTS.md --target /tmp/example-AGENTS.md --check
```

## Results

- `check-codexminimal.sh`: `0.87s`
- `evals/run-sample-evals.sh`: `0.20s`
- `bootstrap_docs_ai.py` on empty temp repo: `0.03s`
- `bootstrap_harness_runtime.py` on empty temp repo: `0.02s`
- `render_index_stubs.py` on empty temp docs/ai: `0.02s`
- `validate_context_map.py`: `0.02s`
- `validate_harness_runtime.py`: `0.02s`
- `sync_agents_blocks.py --check`: `0.02s`

Observed memory footprint stayed around `11-12 MB RSS` for these local checks.

## Interpretation

Current local overhead is low.

That means:

- the bundled checks are cheap enough to run often
- the helper scripts are fast enough to be the default deterministic path
- the current bottleneck is no longer local scaffolding

The remaining unknown is real-repository behavior:

- how many files get read during actual feature work
- whether compact mode and context budgets reduce broad scans in practice
- whether the router chooses the right flow under real ambiguity
- whether optional profiles add enough value to justify their extra surface area

## Model Support Snapshot

Observed locally on `2026-06-04` from Codex CLI model cache:

- `gpt-5.5`
- `gpt-5.4`
- `gpt-5.4-mini`
- `codex-auto-review` as an internal approval-review model

That means the current router should prefer `gpt-5.5`, `gpt-5.4`, and `gpt-5.4-mini`.
Do not keep `gpt-5.3-codex` in active routing guidance.

## Official OpenAI Model Snapshot

As of the GPT-5.5 release notes and current model docs:

- GPT-5.5 is the strongest Codex-facing model for complex coding and agentic work
- GPT-5.5 matches GPT-5.4 per-token latency in real-world serving while delivering higher quality
- GPT-5.5 also uses fewer tokens than GPT-5.4 for many Codex tasks
- GPT-5.4 remains a valid balanced fallback for everyday coding
- GPT-5.4 mini is the recommended lower-latency, lower-cost small model for bounded coding, subagents, and scan-heavy work

Official benchmark snapshot worth tracking:

- `Terminal-Bench 2.0`: GPT-5.5 `82.7%`, GPT-5.4 `75.1%`
- `SWE-Bench Pro`: GPT-5.5 `58.6%`, GPT-5.4 `57.7%`

Interpret this as routing guidance, not as a guarantee for your repository.
