# IDSD Usage Guide

This guide explains how to use CodexMinimal IDSD in a target project.

## What It Creates

IDSD trace helpers write files inside the target repository you pass with `--repo-root`.

If you run from the target repository root, `--repo-root` can be omitted:

```bash
python3 /home/jason/CodexMinimal/scripts/start_idsd_trace.py \
  --topic "checkout cleanup" \
  --intent "Make checkout easier to complete." \
  --stack nestjs \
  --task-type feature
```

If you run from `/home/jason/CodexMinimal` but want to create the trace inside another project, pass the target path:

```bash
python3 scripts/start_idsd_trace.py \
  --repo-root /path/to/your-project \
  --topic "checkout cleanup" \
  --intent "Make checkout easier to complete." \
  --stack nestjs \
  --task-type feature
```

The helper creates:

```text
/path/to/your-project/docs/codexminimal/idsd-traces/checkout-cleanup/
```

## Files In A Trace Folder

Each trace folder contains:

```text
README.md
trace.json
intent-package.md
original-prompt.md
repo-context.md
adr.md
specification.md
task-breakdown.md
tests.md
implementation.md
verification.md
results.md
```

Use them like this:

- `intent-package.md`: compact IDSD pipeline package.
- `original-prompt.md`: the original task prompt.
- `repo-context.md`: stack, task type, touched areas, protected or risky boundaries.
- `adr.md`: architecture decisions and tradeoffs.
- `specification.md`: bounded specification.
- `task-breakdown.md`: ordered implementation tasks.
- `tests.md`: TDD mode, test plan, and verification alternatives.
- `implementation.md`: tool adapter handoff and changed files.
- `verification.md`: commands run and important outputs.
- `results.md`: what worked, what failed, what felt too heavy or too light.
- `trace.json`: machine-readable metadata for later analysis.
- `README.md`: short checklist for what to send back.

## Recommended Workflow

1. Start a trace before working on the target project.

```bash
python3 /home/jason/CodexMinimal/scripts/start_idsd_trace.py \
  --repo-root /path/to/your-project \
  --topic "user invite flow" \
  --intent "Admins can invite teammates and see whether each invite was accepted." \
  --stack nestjs \
  --task-type feature
```

2. Work through the project using CodexMinimal IDSD.

Default flow:

```text
task-router -> idsd-orchestrator -> repo-phase-orchestrator -> Codex CLI native execution -> verification -> project-indexer
```

3. After execution, fill the trace files if they are not already complete:

- update `repo-context.md` with touched modules and risk boundaries
- update `adr.md`, `specification.md`, `task-breakdown.md`, and `tests.md` before implementation
- update `implementation.md` during execution
- update `verification.md` with test/lint/build commands and outputs
- update `results.md` with outcome and IDSD friction

4. Send the whole trace folder back for review.

Example:

```text
/path/to/your-project/docs/codexminimal/idsd-traces/user-invite-flow/
```

## Stack Values

Use one of:

- `generic`
- `nestjs`
- `rust`
- `nestjs-rust`
- `other`

Use `generic` for frameworks without an active bundled profile, such as Fastify, Express, Rails, Laravel, Django, or Go services.
Record detected framework evidence in `docs/ai/stack-profile.md`, but do not activate a profile that does not exist yet.

## Task Type Examples

Use short labels such as:

- `feature`
- `bugfix`
- `refactor`
- `review`
- `security`
- `migration`

## Does It Initialize The Project?

The trace helper does not run full project bootstrap. It only creates the IDSD trace folder under the target repository.

For a brand-new target repo, first bootstrap CodexMinimal:

```text
Use task-router for repository bootstrap, then continue with project-init and project-indexer.
```

After bootstrap, create traces with `start_idsd_trace.py`.

## What Should Be Committed?

For experimental evidence collection, keep trace folders in the working tree until you decide whether they are useful.

Commit them only when:

- the trace should become shared evidence
- the project accepts `docs/codexminimal/idsd-traces/` as a durable artifact location
- sensitive output has been removed

Do not commit secrets, tokens, customer data, or production logs.

## Minimal Command To Remember

From any directory:

```bash
python3 /home/jason/CodexMinimal/scripts/start_idsd_trace.py \
  --repo-root /path/to/your-project \
  --topic "short topic" \
  --intent "what you want to happen" \
  --stack nestjs
```
