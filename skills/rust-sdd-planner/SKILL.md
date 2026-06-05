---
name: rust-sdd-planner
description: Plan Rust work using spec-driven development. Use for requirements, crate boundaries, API contracts, error design, concurrency assumptions, workspace impact, acceptance criteria, test plans, and implementation handoff notes before detailed planning. Do not implement code.
---

# Rust SDD Planner

## Goal

Turn a product or technical request into a concise implementation-ready Rust specification.

Save the approved spec to:

`docs/codexminimal/specs/YYYY-MM-DD-<topic>-spec.md`

## Use When

Use when:

- requirement is unclear
- new feature needs design
- crate or module boundaries must be specified
- public API or error contracts must be specified
- workspace impact must be explained
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
3. Read relevant module, dependency, entity, and test indexes.
4. Check `docs/ai/protected-files.md`.

## Workflow

1. Classify task as `planner/sdd`.
2. Identify affected packages, crates, and modules.
3. Identify protected-file impact.
4. Define scope and non-goals.
5. Define public and internal API contracts.
6. Define error behavior and failure contracts.
7. Define concurrency or async assumptions when relevant.
8. Define workspace impact.
9. Define acceptance criteria using Given/When/Then.
10. Define unit and integration test plans.
11. Define implementation handoff notes for the later phase-planning stage.

## Rust Specification Rules

- reason at package, crate, and module boundaries
- keep public API surface intentional
- prefer `Result` for recoverable failures
- reserve `panic!` for invariant violations or unrecoverable states
- use service-specific guidance only when repository evidence supports it

## Output Format

Return:

### Classification

planner / sdd

### Scope

### Non-goals

### Affected modules

### Protected-file impact

### API contract

### Error and concurrency design

### Workspace impact

### Acceptance criteria

### Test plan

### Implementation handoff notes

### Open questions or assumptions

If the caller requests machine-readable output, return JSON that conforms to `assets/spec-output.schema.json`.
