---
name: nestjs-sdd-planner
description: Plan NestJS work using spec-driven development. Use for requirements, API contracts, DTO design, service behavior, persistence behavior, acceptance criteria, test plans, and implementation handoff notes before detailed planning. Do not implement code.
---

# NestJS SDD Planner

## Goal

Turn a product or technical request into a concise implementation-ready NestJS specification.

Save the approved spec to:

`docs/codexminimal/specs/YYYY-MM-DD-<topic>-spec.md`

## Use When

Use when:

- requirement is unclear
- new feature needs design
- API contract is needed
- DTO/service/persistence behavior must be specified
- user asks for SDD or spec

## Do Not Use When

Do not use for:

- direct bug fix
- small obvious edit
- code review only
- direct implementation

## Required Reads

Before planning:

1. Read `AGENTS.md`.
2. Read `docs/ai/project-index.md`.
3. Read relevant module/route/entity/test indexes.
4. Check `docs/ai/protected-files.md`.

## Workflow

1. Classify task as `planner/sdd`.
2. Identify affected modules.
3. Identify protected-file impact.
4. Define scope and non-goals.
5. Define API contracts.
6. Define request/response DTOs.
7. Define service behavior.
8. Define persistence behavior.
9. Define validation and error cases.
10. Define acceptance criteria using Given/When/Then.
11. Define unit/e2e test plan.
12. Define implementation handoff notes for the later phase-planning stage.

## NestJS Specification Rules

- Controllers stay thin.
- Services own business behavior.
- Controllers return DTOs, not TypeORM entities.
- Use validation pipes and DTO decorators.
- Keep feature modules domain-based.
- Keep persistence under the feature directory.
- Keep scheduled jobs out of web runtime.

## Output Format

Return:

### Classification

planner / sdd

### Scope

### Non-goals

### Affected modules

### Protected-file impact

### API contract

### DTO design

### Service behavior

### Persistence behavior

### Validation and errors

### Acceptance criteria

### Test plan

### Implementation handoff notes

### Open questions or assumptions

If the caller requests machine-readable output, return JSON that conforms to `assets/spec-output.schema.json`.
