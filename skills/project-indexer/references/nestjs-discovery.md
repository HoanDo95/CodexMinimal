# NestJS Discovery

When indexing a NestJS repository, discover structure in this order:

1. `package.json`
2. `nest-cli.json` if present
3. app bootstrap files under `src/`
4. feature modules
5. controllers, services, repositories, entities, DTOs
6. unit and e2e tests
7. config, env, deploy, and integration boundaries

Useful signals:

- `@Module()` for feature boundaries
- `@Controller()` and route decorators for HTTP surfaces
- service class names ending in `Service`
- repository providers or ORM repositories
- DTO classes ending in `Dto`
- entities decorated for TypeORM
