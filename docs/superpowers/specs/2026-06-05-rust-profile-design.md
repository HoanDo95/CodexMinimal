# Rust Profile Design

## Summary

Add a new optional `rust` profile to `CodexMinimal` that mirrors the install surface and stage coverage of the existing `nestjs` profile while remaining independent from it.

The `rust` profile is intended for company Rust templates and general Rust repositories. It should support both backend services and library/crate repositories, but it must remain `convention-first`: use Rust and Cargo conventions by default, and only apply stack-specific patterns such as `axum`, `tokio`, `tracing`, `thiserror`, or `sea-orm` when the repository already uses them.

## Goals

- add a standalone optional `rust` profile that can be installed independently or alongside `nestjs`
- mirror the `nestjs` profile shape with a full stage-specific Rust skill set
- anchor Rust rules in official Rust and Cargo guidance first
- use the `error-tracing` repository as a reference implementation, not as a mandatory default stack
- support both Rust services and Rust libraries within one profile
- extend readiness checks and eval coverage so the profile ships with basic guardrails

## Non-Goals

- replacing the generic core flow
- merging Rust rules into the generic AGENTS entrypoint
- forcing all Rust repositories onto a single backend stack
- solving multi-profile monorepo orchestration in this design pass
- implementing the profile in this document

## Current State

`CodexMinimal` currently ships:

- a generic core harness
- one optional `nestjs` profile
- install-time profile selection via `CODEXMINIMAL_INSTALL_PROFILES`
- readiness checks that know how to validate optional profile skills if present

There is no equivalent `rust` profile yet in:

- `install.sh`
- `check-codexminimal.sh`
- `docs/profiles.md`
- `docs/skills.md`
- `docs/flows.md`
- `README.md`
- skill directories
- eval coverage

## Approved Product Decisions

### Profile Model

- `rust` is a separate optional profile, not part of `nestjs`
- users may install `core` only, `core + nestjs`, `core + rust`, or `core + nestjs + rust`
- the profile should mirror `nestjs` naming and install ergonomics

### Scope Inside Rust

- the `rust` profile covers both backend services and library/crate repositories
- the profile remains `convention-first`
- framework-specific behavior activates only when repository evidence supports it

### Standards Priority

Priority order:

1. official Rust Book and Cargo conventions
2. established conventions already present in the target repository
3. company reference patterns from `error-tracing` where they do not conflict with the first two

### Activation Policy

`project-init` should support `Template-default + evidence fallback`:

- company Rust templates may default the active profile to `rust`
- non-template repositories should promote to `rust` only when repository evidence clearly supports it

### Eval Policy

- ship the `rust` profile with at least minimal eval coverage
- include coverage for router/profile activation and Rust planner behavior

## Rust Profile Surface

The new optional profile will add these skills:

- `rust-sdd-planner`
- `rust-tdd-builder`
- `rust-bug-fixer`
- `rust-code-reviewer`
- `rust-refactor-guardian`

These names intentionally mirror the current `nestjs` profile structure so install, routing, docs, and verification remain predictable.

## Skill Contracts

### `rust-sdd-planner`

Purpose:
- convert a Rust feature or technical request into an implementation-ready spec

Required design concerns:
- package, crate, and module boundaries
- public/private API surface
- error contracts using `Result` and domain-specific error types
- async and concurrency assumptions when relevant
- workspace impact
- unit vs integration test strategy

Default guidance:
- prefer clear crate boundaries over oversized modules
- preserve encapsulation and visibility discipline
- do not assume web-service concerns for library-only repositories

### `rust-tdd-builder`

Purpose:
- implement approved Rust behavior using Red-Green-Refactor

Required build concerns:
- add the smallest failing test first
- keep public API changes within approved scope
- use targeted verification before broad verification
- follow existing crate/test layout before introducing a new one

Default guidance:
- prefer unit tests close to the implementation boundary
- use integration tests when behavior crosses crate or public API boundaries
- avoid speculative refactors during the green step

### `rust-bug-fixer`

Purpose:
- isolate and fix a concrete Rust bug with the smallest safe change

Required debug concerns:
- reproduce or isolate the failing behavior
- identify the root cause
- add or update a regression test
- preserve stable public contracts unless the bug is the contract

Default guidance:
- trust source over stale indexes
- treat ownership, lifetime, error propagation, and async boundaries as first-class root-cause candidates

### `rust-code-reviewer`

Purpose:
- review Rust code or diffs without editing files

Review priorities:
- correctness
- public API stability
- ownership and borrowing assumptions
- error propagation
- concurrency safety
- unsafe usage
- tests and regression risk
- maintainability

Default guidance:
- distinguish library API concerns from service/runtime concerns
- evaluate whether abstractions align with crate and module boundaries

### `rust-refactor-guardian`

Purpose:
- perform or guide risky Rust refactors safely

Required refactor concerns:
- file, module, or crate moves
- visibility changes
- export renames
- public API changes
- dependency-direction changes
- workspace-wide impact
- rollback boundary

Default guidance:
- use the smallest coherent refactor unit
- update indexes and refactor logs after structural changes
- ask for approval when protected files or architecture boundaries are affected

## Rust Profile Rules

These rules apply only when the active profile is `rust` or the user explicitly requests the Rust profile.

### General Rules

- prefer idiomatic Cargo package and crate organization
- keep module visibility explicit and narrow
- preserve clear separation between binary entrypoints and library logic
- prefer returning `Result` for recoverable failures
- reserve `panic!` for unrecoverable invariants or explicit contract violations
- avoid framework assumptions that are not justified by the repository

### Service-Oriented Rust Rules

Apply only when the repository already shows service/backend evidence:

- keep transport-layer handlers thin
- keep domain logic outside the HTTP entrypoint
- isolate persistence details from transport concerns
- make async boundaries explicit
- keep observability patterns consistent with repository conventions

### Library-Oriented Rust Rules

Apply only when the repository is a library/crate:

- protect public API stability
- keep error types intentional and composable
- prefer narrow exports
- consider semver and feature-flag impact before widening the API surface
- favor doc-test or integration-test coverage where public usage matters

### Workspace Rules

Apply when the repository is a Cargo workspace:

- reason at package, crate, and module level
- avoid hiding cross-crate coupling inside vague “shared” buckets
- make dependency direction explicit
- evaluate whether a change belongs in a crate boundary change or a module-only change

## Detection Design

`project-init` should keep `generic` as the fallback profile and promote to `rust` when evidence is clear.

Evidence may include:

- `Cargo.toml`
- `Cargo.lock`
- `src/lib.rs`
- `src/main.rs`
- `src/bin/*`
- `crates/*`
- `rust-toolchain.toml`
- `.cargo/config.toml`
- workspace manifests under the repository root

Detection behavior:

- if the repository is a known company Rust template, default active profile to `rust`
- otherwise, use evidence-based promotion
- record the evidence and allowed Rust profile skills in `docs/ai/stack-profile.md`

## Install and Packaging Design

`install.sh` should be extended with:

- `RUST_PROFILE_SKILLS=( rust-sdd-planner rust-tdd-builder rust-bug-fixer rust-code-reviewer rust-refactor-guardian )`

Supported install examples:

```bash
bash install.sh
CODEXMINIMAL_INSTALL_PROFILES=rust bash install.sh
CODEXMINIMAL_INSTALL_PROFILES=nestjs bash install.sh
CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust bash install.sh
```

Installer behavior should remain unchanged except for:

- adding Rust profile skills when requested
- reporting `rust` in the installed profile list
- preserving the unmanaged-skill overwrite protection that already exists

## Routing and Flow Design

### Generic Feature Flow

No change:

`task-router -> feature-intake-gate -> implementation-spec-writer -> repo-phase-orchestrator`

### Rust Feature Flow

When the active profile is `rust`:

`task-router -> feature-intake-gate -> rust-sdd-planner -> repo-phase-orchestrator`

### Rust Direct Specialized Flows

- `task-router -> rust-bug-fixer -> project-indexer`
- `task-router -> rust-code-reviewer`
- `task-router -> rust-refactor-guardian -> project-indexer`

Router policy:

- treat `rust-*` as optional profile skills, parallel to `nestjs-*`
- use them only when the active profile is `rust` or the user explicitly selects them
- keep the generic expanded sequence as the fallback

## Documentation Changes

The implementation should add or update:

- `docs/rust-spec.md`
- `docs/profiles.md`
- `docs/skills.md`
- `docs/flows.md`
- `docs/setup.md`
- `README.md`
- any template or rule-registry references that enumerate optional profiles

`docs/rust-spec.md` should be the Rust counterpart to `docs/nestjs-spec.md`, but grounded in Rust-specific rules rather than framework-specific assumptions.

## Readiness and Eval Changes

### Readiness

`check-codexminimal.sh` should:

- validate `skills/rust-*` as optional profile skills when present
- enforce the same structural checks used for optional `nestjs-*` skills
- require Rust planner eval artifacts when `skills/rust-sdd-planner` exists

### Evals

Minimum required additions:

- task-router coverage that routes Rust requests to `rust-*` when the profile is active
- feature-intake coverage that advances approved Rust work to `rust-sdd-planner`
- a Rust planner golden case and sample result

Possible file additions:

- `evals/rust-sdd-planner-golden-cases.json`
- `evals/samples/rust-sdd-planner-results.sample.json`

Existing sample-eval scripts and readiness scripts should be extended rather than forked.

## Verification Plan For Implementation

At implementation time, validate at minimum with:

```bash
rtk bash check-codexminimal.sh
rtk bash evals/run-sample-evals.sh
```

If the profile introduces new generated artifacts or template changes, verification should also include targeted checks for:

- install behavior with `CODEXMINIMAL_INSTALL_PROFILES=rust`
- combined install behavior with `CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust`
- router and planner eval results that mention Rust

## Risks and Tradeoffs

### Risks

- a “mixed” Rust profile can become too generic and lose value if the rules are not sharp enough
- overfitting to `error-tracing` would make the profile brittle for library-first repositories
- under-specifying service vs library differences would make review and planning output inconsistent

### Mitigations

- keep the profile `convention-first`
- separate general Rust rules from service-only and library-only rules
- treat repository evidence as the gate for framework-specific guidance
- mirror the existing profile architecture to minimize install and routing drift

## References

- Rust Book, “Packages, Crates, and Modules”: https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html
- Rust Book, “Error Handling”: https://doc.rust-lang.org/book/ch09-00-error-handling.html
- Rust Book, “Writing Automated Tests”: https://doc.rust-lang.org/nightly/book/ch11-00-testing.html
- Cargo Book, “Workspaces”: https://doc.rust-lang.org/cargo/reference/workspaces.html
- Reference implementation repository: `/home/jason/Downloads/twendee/error-tracing`
