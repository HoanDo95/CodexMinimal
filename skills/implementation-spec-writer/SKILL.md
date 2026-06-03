---
name: implementation-spec-writer
description: Write a stack-agnostic implementation-ready specification from an approved direction or clarified request. Use for scope, interfaces, data impacts, acceptance criteria, verification, and implementation handoff before phase planning. Do not implement code.
---

# Implementation Spec Writer

## Goal

Turn an approved direction into a concise implementation-ready specification without assuming a specific application stack.

Save the approved spec to:

`docs/codexminimal/specs/YYYY-MM-DD-<topic>-spec.md`

## Use When

Use when:

- feature direction is approved
- requirements need a concrete spec before planning
- the active stack profile is `generic`
- no deeper profile-specific spec skill is required
- user wants a stack-agnostic specification

## Do Not Use When

Do not use for:

- direct implementation
- small obvious edits
- bug fixes that already have a narrow reproduction
- code review only
- stack-specific design when a profile skill is clearly better

## Required Reads

1. `AGENTS.md`
2. `docs/ai/stack-profile.md`
3. `docs/ai/project-index.md`
4. relevant `docs/ai/*-index.md`
5. `docs/ai/protected-files.md`

## Workflow

1. Confirm that feature direction or requirements are approved enough for a spec.
2. Define scope and non-goals.
3. Identify affected modules, surfaces, or integrations.
4. Define input and output contracts at the boundary level.
5. Define data or state impacts.
6. Define validation, failure modes, and rollback assumptions.
7. Define acceptance criteria.
8. Define verification plan.
9. Define implementation handoff notes for the later phase-planning stage.

## Specification Rules

- Keep the spec concise and implementation-oriented.
- Avoid framework assumptions unless they are already explicit in the repo or user request.
- Prefer clear boundaries, constraints, and acceptance criteria over long prose.
- Record protected-file or integration concerns explicitly.

## Output Format

Return:

### Scope

### Non-goals

### Affected surfaces

### Boundary contracts

### Data and state impacts

### Validation and failure modes

### Acceptance criteria

### Verification plan

### Implementation handoff notes

### Open questions or assumptions

If the caller requests machine-readable output, return JSON that conforms to `assets/spec-output.schema.json`.
