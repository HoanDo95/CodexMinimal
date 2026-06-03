# Release Readiness Plan

CodexMinimal is usable locally, but release quality depends on guarding against false confidence.

## Fixed Hardening Targets

- restore a complete `README.md`
- finish the truncated `project-indexer` skill
- align model routing with models that actually exist in the environment
- support a primary-skill-plus-follow-up-chain workflow
- make install and uninstall conservative by default
- make readiness checks fail on empty docs, broken shell scripts, and incomplete skills

## Remaining Validation Work

- run CodexMinimal against at least one real NestJS repository from bootstrap through feature delivery
- validate whether index quality is sufficient to reduce broad scans in practice
- tune safety-gate defaults based on real protected-file conflicts
- confirm the recommended model routing is cost-effective in long sessions
- validate whether runtime telemetry produces useful measurements without adding too much workflow overhead

## Current Interpretation

At the current stage, CodexMinimal should be treated as `local-ready beta`.

- internal scaffolding is now consistent
- helper scripts and sample evals are available for local smoke testing
- remaining uncertainty is no longer in the repo skeleton, but in real-repository behavior under practical workloads

Real-repository trials should be the next hardening phase when target repositories are available.
