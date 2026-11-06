# QA Gate Local Benchmark

Measures locally whether the two-stage Senior QA gate (pre-execution
evidence plus post-execution ticket-vs-diff verdict) is enforced by the
harness. Scope is deliberately local-only: no real-task tracking.

Machine referee: `scripts/validate_qa_verdict.py --tracker <path> --require-pass`.
A phase passes only when the validator exits 0. Prose claims do not count.

Bypass coverage is measured locally, not on real tasks: the 2 QA-bypass
golden cases (`phase_done_without_qa_verdict_blocks_advance`,
`qa_fail_verdict_blocks_advance`) grade whether the orchestrator blocks
advance without a PASS verdict.

## Commands (repo root)

```bash
bash check-codexminimal.sh
bash evals/run-sample-evals.sh
python3 scripts/validate_qa_verdict.py --tracker <phase-tracker>.md --require-pass
```

## Baseline

Recorded on `2026-11-06` (branch `feat/IDSD`, commit `8bbf89f`):

- `check-codexminimal.sh`: 0 FAIL (1 pre-existing WARN: `~/.codex/skills` absent)
- `run-sample-evals.sh`: 10/10, 3/3, 2/2, 2/2, 4/4 (repo-phase 4/4 includes both QA-bypass cases, `0.13s`)
- validator self-check on PASS fixture with `--require-pass`: exit 0 (`0.02s`)

## Interpretation

- Re-run after any prompt or model change; all three commands must stay green.
- A new bypass pattern found in real work belongs here as a new golden case plus a validator fixture, keeping measurement local.
- bypass-rate above 0 in real work means the verdict block is being skipped at the workflow call site, not that the validator is wrong; fix the call site, then add the regression case here.
