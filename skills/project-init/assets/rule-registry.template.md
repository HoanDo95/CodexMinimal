# Rule Registry

Source of persisted durable rules for CodexMinimal.

AGENTS.md is the operational rendered view.
This file is the durable rule source.

## Protected Paths

## Generic Workflow Rules

- Use the smallest suitable skill.
- Route new features through intake before execution.
- Read indexes before broad repository search.
- Keep runtime state aligned with the active plan and tracker.

## Generic Testing Rules

- Run targeted verification before broader checks.
- Keep generated build artifacts out of commits unless explicitly required.

## Active Profile

- See `docs/ai/stack-profile.md` for the current stack profile and allowed profile-specific skills.

## Profile-Specific Rules

- Persist stack-specific rules only when the active profile justifies them.

## Safety Rules

- Do not commit `.env` or secrets.

## User Overrides

Record user-specified durable rules here.
