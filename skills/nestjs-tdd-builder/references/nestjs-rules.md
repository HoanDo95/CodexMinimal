# NestJS Rules

- Use standard NestJS TypeScript structure under `src/`.
- Keep controllers thin.
- Place business behavior in services.
- Return DTOs from API controllers instead of raw TypeORM entities.
- Keep feature modules by domain.
- Keep persistence details under the feature directory.
- Use DTO validation via Nest pipes.
- Keep scheduled jobs out of the web app runtime.
