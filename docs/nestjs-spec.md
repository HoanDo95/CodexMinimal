# NestJS Specification

This file describes the optional `nestjs` profile.

Apply these rules only when:

- the active stack profile is `nestjs`
- or the user explicitly chooses the NestJS profile

NestJS profile defaults:

- keep controllers thin
- keep business logic in services
- return DTOs from controllers, not persistence entities
- validate request contracts with DTO decorators and validation pipes
- keep feature modules domain-based
- keep persistence details inside the feature directory
- keep scheduled jobs out of the web runtime
- keep TypeORM `synchronize` disabled
- place unit tests under `test/unit`
- place e2e tests under `test/e2e`

The planning and build skills use these defaults when writing specs, tests, or review findings.
