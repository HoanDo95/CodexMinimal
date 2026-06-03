---
name: nestjs-code-reviewer
description: Review NestJS TypeScript code, diffs, or PRs for correctness, DTO boundaries, TypeORM safety, tests, protected-file violations, security, maintainability, and production readiness. Do not modify files.
---

# NestJS Code Reviewer

## Goal

Review code without modifying files.

## Use When

Use when:
- user asks to review
- checking PR/diff
- checking production readiness
- checking architecture or tests
- checking TypeORM safety
- checking protected-file violations

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

1. Correctness
2. Data integrity
3. Security
4. TypeORM safety
5. API contract stability
6. DTO/entity boundary
7. Test coverage
8. NestJS structure
9. Protected-file violations
10. Maintainability

## NestJS Review Checks

- Controllers are thin.
- Services contain business logic.
- Controllers return DTOs, not entities.
- DTO validation uses pipes/decorators.
- Feature modules are domain-based.
- Persistence is inside feature directory.
- Scheduled jobs are not wired into web runtime.
- TypeORM `synchronize` remains `false`.

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
