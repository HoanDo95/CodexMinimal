---
name: rust-bug-fixer
description: Fix a specific Rust bug, failing test, compiler error, runtime error, panic, regression, or incorrect behavior. Use for reproduction, root cause analysis, smallest safe fix, regression test, and verification.
---

# Rust Bug Fixer

## Goal

Fix a specific bug with the smallest safe change and targeted verification.

## Use When

Use when:

- user provides error message
- test is failing
- compiler behavior is wrong
- runtime behavior is wrong
- regression exists
- panic or stack trace is available

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
6. failing test, error, or stack trace
7. related source and tests

## Workflow

1. Classify as `bug-fix` or `debug`.
2. Locate likely files via index-first lookup.
3. Reproduce or isolate the failure.
4. Identify root cause.
5. Add regression test if missing.
6. Apply the smallest safe fix.
7. Run targeted verification.
8. Run broader checks only if necessary.
9. Update index or rule registry if a durable lesson is discovered.

## Rules

- do not refactor broadly while fixing
- do not touch protected files without approval
- preserve public API contracts unless the bug is the contract
- trust source over stale indexes
- treat ownership, lifetimes, error propagation, and async boundaries as first-class root-cause candidates

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
