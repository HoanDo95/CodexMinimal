# Compact Mode

Compact mode exists for users who care more about speed and focus than explanation depth.

## Goal

Make the answer:

- shorter
- more direct
- less repetitive
- cheaper in context and output tokens

## When To Use

- operational tasks
- repeated workflows
- bounded code or repo questions
- continuing an already-approved phase tracker
- Phase 0 preflight, baseline checks, or current blocker triage
- when the user clearly prioritizes speed

## Rules

- answer with the shortest useful form
- avoid long recaps
- avoid optional side-notes unless they change the decision
- use lists only when the content is inherently list-shaped

## Current Scope

Compact is an answer style plus a phase-execution discipline, not a router output field. The router assigns a context budget; compactness follows from it:

- downstream skills stay shorter and more direct under tight budgets
- the workflow pairs compact answers with a lower context budget
- long-session compaction itself relies on the tool's built-in auto-compaction, not on hand-managed triggers

## Compact Phase Execution

Use this when planning artifacts already exist and the user says something like:

```text
Continue CodexMinimal next phase.
```

Expected behavior:

- route to `repo-phase-orchestrator`
- use `low` context budget and answer compactly
- read active tracker/runtime state first
- execute or triage only the next open phase
- update tracker/current-work/telemetry with short evidence
- stop after verification or blocker capture

Do not recreate IDSD intent, ADR, specification, or a full phase plan unless the existing artifacts are missing or stale.

## Session Compaction

Rely on the tool's built-in auto-compaction for long sessions instead of managing compaction by hand.

Budget-based heuristics that still help decide when a fresh phase pass is cheaper than continuing:

- repeated long turns with no new technical surface
- context budget exhaustion under `low` or `medium`
- broad exploration completed and only execution context needs to remain
- summary size is clearly smaller than the active working set
