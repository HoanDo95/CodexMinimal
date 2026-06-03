# Rule Registry

Source of persisted durable rules for CodexMinimal.

AGENTS.md is the operational rendered view.
This file is the durable rule source.

## Protected Paths

## Folder Structure Rules

## NestJS Rules

- Controllers stay thin.
- Business logic belongs in services.
- Controllers return DTOs, not TypeORM entities.
- Use DTO validation pipes.
- Feature modules are domain-based.
- Persistence details stay under feature directories.

## Testing Rules

- Unit tests under `test/unit/`.
- E2E tests under `test/e2e/`.

## Safety Rules

- Do not commit `.env` or secrets.
- Keep TypeORM `synchronize: false`.

## User Overrides

Record user-specified durable rules here.
