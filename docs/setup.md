# Setup

## Install

```bash
bash install.sh
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

## Validate

```bash
bash check-codexminimal.sh
```

Validate the local Codex CLI environment when setup or auth behavior is unclear:

```bash
codex doctor --json
```

Use Codex's non-interactive review before push or release when a local diff should get an independent pass:

```bash
codex review --uncommitted
codex review --base main
codex review --commit <sha>
```

When bootstrapping a target repository, `project-init` should create:

- `AGENTS.md`
- `docs/ai/`
- `docs/ai/stack-profile.md`
- `docs/codexminimal/`

## Uninstall

```bash
bash uninstall.sh
```
