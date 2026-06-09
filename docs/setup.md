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
