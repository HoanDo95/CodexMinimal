# Indexing

CodexMinimal prefers index-first lookup over broad repository scans.

## Core Files

Repository memory lives under `docs/ai/`:

- `project-index.md`
- `module-index.md`
- `route-index.md`
- `entity-index.md`
- `test-index.md`
- `dependency-index.md`
- `protected-files.md`
- `rule-registry.md`
- `architecture-notes.md`
- `refactor-log.md`
- `context-map.json`
- `stack-profile.md`

## Search Order

1. `docs/ai/context-map.json`
2. `docs/ai/project-index.md`
3. relevant `docs/ai/*-index.md`
4. files already referenced by those indexes
5. sibling files
6. feature folder
7. parent or shared folders
8. whole repository as the last resort

Under `low` context budget, stop before whole-repository search and reroute or ask the user instead.

## Context Map

`context-map.json` uses schema version 2 and keeps a stable top-level structure for modules, controllers, services, repositories, entities, DTOs, routes, surfaces, tests, scripts, and protected paths.

Indexes should stay compact and navigational. They are not meant to duplicate source code.
