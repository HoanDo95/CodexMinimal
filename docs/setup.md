# Setup

## Install

Skill-pack install (default target is the current Codex skills directory):

```bash
bash install.sh
```

Install into OpenCode skills (`~/.config/opencode/skills`):

```bash
bash install.sh --target opencode
```

Install into both Codex and OpenCode:

```bash
bash install.sh --target all
```

Install the optional NestJS profile:

```bash
CODEXMINIMAL_INSTALL_PROFILES=nestjs bash install.sh
```

Install the optional Rust profile:

```bash
CODEXMINIMAL_INSTALL_PROFILES=rust bash install.sh
```

Install both optional profiles:

```bash
CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust bash install.sh
```

If you keep this repository in another local path, run the same command from that checkout.

`OPENCODE_HOME` overrides the OpenCode config home (default `$HOME/.config/opencode`). `CODEXMINIMAL_TARGET` accepts `codex`, `opencode`, or `all` as an alternative to `--target`.

See [OpenCode Adapter](opencode-adapter.md) for the Codex-to-OpenCode concept mapping.

## Plugin Packaging

CodexMinimal can also be tested as a local Codex plugin. The plugin manifest lives at:

- `.codex-plugin/plugin.json`

The plugin manifest is Codex-only and ignored by OpenCode; OpenCode discovers the same `skills/` surface through its native `skill` tool with no manifest needed.

This mode exposes the same `skills/` surface through plugin loading instead of relying only on direct skill-pack installation. It is intended for testing automatic prompt-to-skill discovery without adding an always-call entrypoint.

The plugin package remains tool-agnostic:

- no Superpowers dependency
- no mandatory `using-codexminimal` skill
- no hardcoded execution engine
- optional `nestjs` and `rust` profiles remain normal skills under `skills/`

## Validate

```bash
bash check-codexminimal.sh
```

Validate only the deterministic harness by default. Tool runtime diagnostics belong to the selected adapter and should not be part of core readiness.

See `docs/tool-adapter-playbook.md` for how to wire optional review, eval, or diagnostic adapters.
See `docs/review-policy.md` before running external review on private or unpublished diffs.

When bootstrapping a target repository, `project-init` should create:

- `AGENTS.md`
- `docs/ai/`
- `docs/ai/stack-profile.md`
- `docs/codexminimal/`

## Uninstall

```bash
bash uninstall.sh
```
