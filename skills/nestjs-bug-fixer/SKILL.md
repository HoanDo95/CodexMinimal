---
name: nestjs-bug-fixer
description: Fix a specific NestJS bug, failing test, runtime error, stack trace, regression, or incorrect behavior. Use for reproduction, root cause analysis, smallest safe fix, regression test, and verification.
---

# NestJS Bug Fixer

## Goal

Fix a specific bug with the smallest safe change and targeted verification.

## Use When

Use when:
- user provides error message
- test is failing
- runtime behavior is wrong
- regression exists
- stack trace is available
- API returns wrong status/body

## Do Not Use When

Do not use for:
- vague feature requests
- broad refactor
- planning-only work
- code review only

## Required Reads

1. `AGENTS.md`
2. `docs/ai/context-map.json`
3. `docs/ai/project-index.md`
4. relevant indexes
5. `docs/ai/protected-files.md`
6. failing test/error/stack trace
7. related source and tests

## Workflow

1. Classify as `bug-fix` or `debug`.
2. Locate likely files via index-first lookup.
3. Reproduce or isolate the failure.
4. Identify root cause.
5. Add regression test if missing.
6. Apply smallest safe fix.
7. Run targeted verification.
8. Run broader checks only if necessary.
9. Update index or rule registry if durable lesson is discovered.

## Rules

- Do not refactor broadly while fixing.
- Do not touch protected files without approval.
- Prefer explicit repository update semantics for important state transitions.
- Preserve API contracts unless the bug is the contract.
- If source contradicts index, trust source and update index.

## Output Format

Return:

### Classification
bug-fix / debug

### Reproduction
### Root cause
### Fix
### Regression test
### Files changed
### Commands run
### Index/rule updates
### Remaining risks
