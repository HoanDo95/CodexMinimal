# Changelog

All notable changes to this repository should be tracked here.

## Unreleased

### Added

- `skill-assets.manifest`: single-source mapping for shared skill-local templates and helper scripts, materialized by `install.sh`
- deterministic helper scripts for AGENTS sync, docs bootstrap, context-map validation, and index stub rendering
- local golden eval harness and bundled sample result sets
- docs for compact mode, context budget, model compatibility, action risk, and eval practice

### Changed

- removed the 200-line cap from project implementation plans and trackers: write them as detailed as possible and split by phase boundary instead of line count; the 200/120-line budgets now apply only to `SKILL.md` entrypoints and generated guidance files
- slimmed `AGENTS.md` from 13 blocks to 8 (merged search/index, merged token-policy trio, cut platitudes and hardcoded skill/model lists)
- slimmed `task-router`: route from request plus `AGENTS.md`, read deeper files only when needed; output cut from 12 sections to 6 with a merged safety-gate reason
- removed hardcoded model names from all routing guidance; route by tier (default/escalated/scan) and let the tool resolve the model
- removed the feedback-ledger system (ledger JSON, strike/threshold scripts, policy); repeated user-confirmed feedback goes directly into `rule-registry.md`
- removed obvious framework-convention references and merged the commit policy into the verification policy
- deleted committed `skills/` asset/script duplicates; `install.sh` materializes them from `templates/` and `scripts/`

- rewrote `README.md` into a user-first guide focused on workflow, installation, startup, and current readiness state
- hardened `check-codexminimal.sh` to fail on empty docs, invalid JSON, broken shell syntax, and incomplete skill assets
- aligned task routing and templates around primary skill plus follow-up chain
- made install and uninstall conservative by default

### Pending

- benchmark and workflow hardening on real NestJS repositories
