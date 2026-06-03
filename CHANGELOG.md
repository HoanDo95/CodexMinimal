# Changelog

All notable changes to this repository should be tracked here.

## Unreleased

### Added

- structured routing fields for response mode, context budget, and action risk
- deterministic helper scripts for AGENTS sync, docs bootstrap, context-map validation, and index stub rendering
- local golden eval harness and bundled sample result sets
- docs for compact mode, context budget, model compatibility, action risk, and eval practice

### Changed

- rewrote `README.md` into a user-first guide focused on workflow, installation, startup, and current readiness state
- hardened `check-codexminimal.sh` to fail on empty docs, invalid JSON, broken shell syntax, and incomplete skill assets
- aligned task routing and templates around primary skill plus follow-up chain
- made install and uninstall conservative by default

### Pending

- benchmark and workflow hardening on real NestJS repositories
