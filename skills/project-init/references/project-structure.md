# Project Structure Detection

Detect:
- package manager: pnpm-lock.yaml, yarn.lock, package-lock.json
- NestJS: @nestjs/core, @nestjs/common, nest-cli.json
- TypeORM: typeorm package, DataSource, entities, migrations
- tests: jest config, test folder, npm scripts
- build/lint: package.json scripts
- env/deploy: .github/workflows, Dockerfile, docker-compose, deploy folders
- protected integrations: vendor integrations, OpenDAX, Barong, payment, infra, provisioning

CodexMinimal runtime scaffolding should also create:

- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`
