# CodexMinimal Architecture

## Design Goals

CodexMinimal is designed around four principles:

1. Small skills
2. Persistent rules
3. Project memory
4. Safe orchestration

The system intentionally avoids a monolithic super-agent.

## System Overview

```text
User
 │
 ▼
AGENTS.md
 │
 ▼
Task Classification
 │
 ▼
Primary Harness Skill Selection
 │
 ▼
Optional Follow-up Chain
 │
 ▼
Project Index Lookup
 │
 ▼
Phase Plan / Tracker
 │
 ▼
External Execution
 │
 ▼
Index / Rule Update
```

## Routing Shape

CodexMinimal routes each step through one primary skill.

When the work naturally spans multiple steps, the router may recommend a follow-up chain, such as:

- `feature-intake-gate -> repo-phase-orchestrator -> external execution -> project-indexer`
- `implementation-spec-writer -> repo-phase-orchestrator`
- `nestjs-bug-fixer -> project-indexer`
- `rust-bug-fixer -> project-indexer`

This keeps individual skills narrow without losing end-to-end workflow support.

The router also assigns:

- a response mode: `compact` or `standard`
- a context budget: `low`, `medium`, or `high`

## Execution Boundary

CodexMinimal is intended to remain a harness layer:

- it routes
- it persists durable repo rules
- it prepares specs, phase plans, and trackers
- it keeps runtime state for the active work item
- it refreshes indexes after work

Execution itself can be handed to external skills such as `subagent-driven-development` or `executing-plans`.
This boundary keeps the core reusable across stacks such as NestJS, Rust, React, and Next.js.

## Stack Profiles

CodexMinimal should not treat every repository as NestJS by default.

The active stack profile should be recorded in:

- `docs/ai/stack-profile.md`

Rules:

- default to `generic`
- activate a profile only from explicit repository evidence or direct user instruction
- keep stack-specific skills behind the active profile boundary
- keep generic harness rules in `AGENTS.md`, not in profile overlays

## Runtime State

The harness now relies on three lightweight runtime files inside target repositories:

- `docs/codexminimal/current-work.json`
- `docs/codexminimal/artifact-registry.json`
- `docs/codexminimal/telemetry.json`

These files let the harness:

- know which artifact is active
- detect stale plan or tracker pointers
- record phase handoffs and verification outcomes
- measure whether the workflow is actually reducing exploration waste
