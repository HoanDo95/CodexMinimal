---
name: rust-code-reviewer
description: Review Rust code, diffs, or PRs for correctness, API stability, ownership and borrowing assumptions, error propagation, concurrency safety, unsafe usage, tests, maintainability, and production readiness. Do not modify files.
---

# Rust Code Reviewer

## Goal

Review code without modifying files.

## Use When

Use when:

- user asks to review
- checking PR or diff
- checking production readiness
- checking architecture or tests
- checking API or safety boundaries

## Do Not Use When

Do not use when:

- user asks to implement directly
- bug needs fixing directly
- refactor is requested directly

## Required Reads

1. `AGENTS.md`
2. `docs/ai/context-map.json`
3. `docs/ai/project-index.md`
4. relevant indexes
5. `docs/ai/protected-files.md`
6. diff or changed files

## Review Priority

1. correctness
2. public API stability
3. ownership and borrowing assumptions
4. error propagation
5. concurrency safety
6. unsafe usage
7. test coverage
8. maintainability

## Rust Review Checks

- public API changes are intentional
- visibility boundaries remain coherent
- error types remain meaningful
- async and concurrency assumptions are explicit
- unsafe usage is justified and bounded
- crate boundaries still make sense

## Output Format

Return:

### Verdict
APPROVE / REQUEST CHANGES / BLOCKED

### Critical issues
### Required changes
### Suggested improvements
### Test gaps
### Protected-file concerns
### Commands recommended
