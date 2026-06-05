---
name: rust-tdd-builder
description: "Implement clear Rust behavior with TDD. Use when behavior is known and tests-first development is required: write a failing unit or integration test, implement the minimal code, rerun tests, refactor, and update indexes."
---

# Rust TDD Builder

## Goal

Implement Rust behavior using strict Red-Green-Refactor.

## Use When

Use when:

- behavior is clear
- feature phase is ready
- user asks for TDD
- tests should be written before production code
- adding or changing crate, module, or API behavior

## Do Not Use When

Do not use when:

- requirement is vague
- broad architecture planning is needed
- task is only review
- task is risky structural refactor

## Required Reads

1. `AGENTS.md`
2. `docs/ai/context-map.json`
3. `docs/ai/project-index.md`
4. relevant dependency and test indexes
5. `docs/ai/protected-files.md`
6. existing related source and tests

## Workflow

### Locate

Use index-first lookup:
1. context-map.json
2. relevant indexed files
3. same folder
4. crate folder
5. parent or shared crates
6. whole repo last

### Red

- Add or update the smallest relevant unit or integration test.
- Keep tests aligned with crate or public API boundaries.
- Run the targeted test.
- Confirm the failure is expected.

### Green

- Implement the smallest production change.
- Avoid widening the public API outside the approved scope.
- Prefer existing repository patterns over new abstractions.
- Rerun targeted tests until green.

### Refactor

- Improve naming, duplication, and type clarity.
- Do not change behavior.
- Rerun targeted tests.

### Verify

Run required checks if available:
- targeted test
- broader affected test
- fmt, lint, or build as appropriate

### Update

If files or tests changed:
- update relevant `docs/ai` indexes
- record durable rules via `project-init` if needed

## Output Format

Return:

### Classification
tdd / coding

### Behavior implemented
### Tests added or changed
### Files changed
### Commands run
### RED result
### GREEN result
### REFACTOR result
### Index/rule updates
### Remaining risks
