# Rust Specification

This file describes the optional `rust` profile.

Apply these rules only when:

- the active stack profile is `rust`
- or the user explicitly chooses the Rust profile

Rust profile defaults:

- prefer idiomatic Cargo package and crate organization
- keep module visibility explicit and narrow
- separate binary entrypoints from reusable library logic
- prefer `Result` for recoverable failures
- reserve `panic!` for unrecoverable invariants or explicit contract violations
- prefer unit tests near implementation and integration tests at crate or public API boundaries
- reason at package, crate, and module level for workspaces
- follow framework-specific patterns only when the repository already uses them

The planning, build, review, and refactor skills use these defaults when writing specs, tests, fixes, or review findings.
