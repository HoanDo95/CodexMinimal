# Rule Registry

Source of persisted durable rules for CodexMinimal.

## Protected Paths

## NestJS Rules

- Controllers stay thin.
- Business logic belongs in services.
- Controllers return DTOs, not TypeORM entities.
- Use DTO validation pipes.

## Testing Rules

- Unit tests under `test/unit/`.
- E2E tests under `test/e2e/`.

## Safety Rules

- Do not commit `.env` or secrets.
- Keep TypeORM `synchronize: false`.

## User Overrides
