# Stack Profile

Source of truth for stack-specific assumptions used by CodexMinimal.

## Active Profile

- `generic`

## Generic-First Rule

- Detection evidence is not profile activation.
- Keep `generic` active until the user explicitly selects a supported profile or a bundled profile can be justified from repo evidence.
- If the framework is detected but unsupported, record it below and keep generic routing.

## Detection Evidence

- Add the files, dependencies, or conventions that justify the active profile.

## Detected But Generic

- Record frameworks or runtimes seen in the repo that do not have an active profile yet.
- Example: `fastify` detected in `package.json`, active profile remains `generic`.

## Allowed Profile Skills

- List the profile-specific skills that are safe to use for this repository.

## Profile-Specific Rules

- Persist only the rules that belong to the active profile.
- Keep generic harness rules in `AGENTS.md` and `rule-registry.md`.

## Overrides

- Record explicit user instructions that override automatic profile detection.
