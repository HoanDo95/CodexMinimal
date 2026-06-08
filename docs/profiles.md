# Profiles

CodexMinimal is designed as a generic harness core with optional stack profiles.

## Core

The default install and default runtime assumptions are `core` plus the `generic` profile.

Core owns:

- routing
- IDSD orchestration
- repository bootstrap
- indexing
- phase planning
- tracker maintenance
- runtime state
- safety and context-budget policy

## Active Profile

The active stack profile for a target repository should be recorded in:

- `docs/ai/stack-profile.md`

Default:

- `generic`

Promote to a stack profile only when repository evidence is clear or the user explicitly asks for it.

## NestJS Profile

When the active profile is `nestjs`, CodexMinimal may use:

- `nestjs-sdd-planner`
- `nestjs-tdd-builder`
- `nestjs-bug-fixer`
- `nestjs-code-reviewer`
- `nestjs-refactor-guardian`

These are optional profile skills, not part of the generic harness contract.

SDD planners are legacy compatibility tools. The default feature workflow remains `idsd-orchestrator`, even when a stack profile is active.

## Rust Profile

When the active profile is `rust`, CodexMinimal may use:

- `rust-sdd-planner`
- `rust-tdd-builder`
- `rust-bug-fixer`
- `rust-code-reviewer`
- `rust-refactor-guardian`

These are optional profile skills, not part of the generic harness contract.

SDD planners are legacy compatibility tools. The default feature workflow remains `idsd-orchestrator`, even when a stack profile is active.

## Install Modes

Default install:

```bash
bash install.sh
```

Core plus legacy SDD compatibility:

```bash
CODEXMINIMAL_INSTALL_PROFILES=legacy bash install.sh
```

Core plus NestJS profile:

```bash
CODEXMINIMAL_INSTALL_PROFILES=nestjs bash install.sh
```

Core plus Rust profile:

```bash
CODEXMINIMAL_INSTALL_PROFILES=rust bash install.sh
```

Core plus NestJS and Rust profiles:

```bash
CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust bash install.sh
```

## Design Rule

Keep stack-specific rules out of the generic AGENTS entrypoint unless the active profile needs them.
