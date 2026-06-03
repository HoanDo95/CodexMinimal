# Setup

## Install

```bash
bash install.sh
```

Install the optional NestJS profile:

```bash
CODEXMINIMAL_INSTALL_PROFILES=nestjs bash install.sh
```

If you keep this repository in another local path, run the same command from that checkout.

## Validate

```bash
bash check-codexminimal.sh
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
