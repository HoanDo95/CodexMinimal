# OpenCode Adapter

CodexMinimal skills are tool-agnostic `SKILL.md` files. OpenCode discovers the same files through its native `skill` tool, so no format conversion is needed. This page maps Codex concepts to OpenCode concepts.

## Install

```bash
bash install.sh --target opencode   # ~/.config/opencode/skills
bash install.sh --target all        # both Codex and OpenCode
bash uninstall.sh --target opencode # remove from OpenCode only
```

`OPENCODE_HOME` overrides the OpenCode config home (default `$HOME/.config/opencode`).

Project-level install is also possible by copying `skills/<name>/` into `<repo>/.opencode/skills/<name>/`, but the global install above is the recommended default.

## Concept Mapping

| CodexMinimal / Codex | OpenCode equivalent |
|---|---|
| `~/.codex/skills/<name>/SKILL.md` | `~/.config/opencode/skills/<name>/SKILL.md` (global) or `.opencode/skills/<name>/SKILL.md` (project) |
| Codex CLI native execution | `build` agent (primary, full tools) |
| Read-only exploration step | `@explore` subagent |
| Multi-step delegated work | `@general` subagent |
| Planning without edits | `plan` agent (primary, restricted) |
| `AGENTS.md` repo rules | shared; OpenCode reads the same file |
| `.codex-plugin/plugin.json` | Codex-only; ignored by OpenCode, no replacement needed |

## Workflow Notes

- `task-router` output stays the same. "Native tool execution" means Codex CLI in a Codex session and the OpenCode `build` agent in an OpenCode session.
- `project-init` bootstrap output (`AGENTS.md`, `docs/ai/`, `docs/codexminimal/`) is identical for both tools.
- `repo-phase-orchestrator` handoff targets the selected tool's native execution; do not mix executors inside one phase unless the tracker records the switch.
- Skill frontmatter follows the OpenCode skill contract: `name` matches the directory, lowercase alphanumeric with single hyphens, `description` between 1 and 1024 characters. `check-codexminimal.sh` enforces this.

## Not Supported

- Codex plugin packaging (`.codex-plugin/`) has no OpenCode equivalent. OpenCode plugins are JS/TS hook modules and are out of scope for this adapter.
- OpenCode `/` slash commands wrapping CodexMinimal flows are intentionally not shipped; invoke skills through the `skill` tool or plain prompts (see [Cheat Sheet](cheat-sheet.md)).
