---
name: nestjs-tdd-builder
description: "Implement clear NestJS behavior with TDD. Use when behavior is known and tests-first development is required: write failing unit test, implement minimal code, rerun tests, refactor, and update indexes."
---

# NestJS TDD Builder

## Goal

Implement NestJS behavior using strict Red-Green-Refactor.

## Use When

Use when:
- behavior is clear
- feature phase is ready
- user asks for TDD
- tests should be written before production code
- adding or changing service/controller behavior

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
4. relevant module/test/entity indexes
5. `docs/ai/protected-files.md`
6. existing related source and tests

## Workflow

### Locate

Use index-first lookup:
1. context-map.json
2. relevant indexed files
3. same folder
4. feature folder
5. parent/shared folders
6. whole repo last

### Red

- Add or update the smallest relevant unit test under `test/unit/`.
- Mirror source feature path where practical.
- Use explicit relative imports to `src/`.
- Run targeted test.
- Confirm failure is expected.

### Green

- Implement the smallest production change.
- Keep controllers thin.
- Keep business logic in services.
- Return DTOs, not entities.
- Use validation pipes for request contracts.
- Keep persistence inside feature directory.
- Rerun targeted tests until green.

### Refactor

- Improve type safety, naming, duplication, and structure.
- Do not change behavior.
- Rerun targeted tests.

### Verify

Run required checks if available:
- targeted unit test
- broader affected test
- lint
- build

### Update

If files/routes/entities/tests changed:
- update relevant `docs/ai` index
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
