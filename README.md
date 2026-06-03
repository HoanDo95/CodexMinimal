# CodexMinimal

Minimal harness layer for Codex CLI.

CodexMinimal không cố trở thành một super-agent. Nó đóng vai trò `harness / orchestrator layer` để:

- route task
- giữ rule và project memory
- ép feature đi qua `brainstorm -> spec -> phase plan`
- quản phase plan, tracker, runtime state
- refresh index sau khi work hoàn tất

## Overview

```mermaid
flowchart LR
    U[User Request] --> R[task-router]
    R --> I[feature-intake-gate]
    R --> B[project-init]
    R --> X[project-indexer]
    I --> S[nestjs-sdd-planner]
    S --> P[repo-phase-orchestrator]
    P --> E[External Execution]
    E --> X
```

## Modes

| Mode | What you get | Best for |
|---|---|---|
| `Core` | CodexMinimal harness only | user muốn control layer chung, dễ custom |
| `Full` | `Core` + companion skills như `brainstorming`, `subagent-driven-development`, `executing-plans` | user muốn flow đầy đủ ngay |
| `Custom` | `Core` + stage/execution skills riêng | team chuyên sâu, multi-stack |

`install.sh` chỉ cài `Core`.

## Core Skills

| Skill | Vai trò |
|---|---|
| `task-router` | route request, mode, budget, safety gate |
| `feature-intake-gate` | ép feature intake qua đúng stage |
| `project-init` | sync `AGENTS.md`, `docs/ai`, `docs/codexminimal` |
| `project-indexer` | build / repair `docs/ai` indexes |
| `repo-phase-orchestrator` | viết phase plan, tracker, runtime state |

## Companion Skills

| Skill | Vai trò |
|---|---|
| `brainstorming` | clarify intent, constraints, direction |
| `subagent-driven-development` | execution path mặc định sau phase plan |
| `executing-plans` | fallback execution path |

Các skill này là `recommended`, không được cài bởi `install.sh`.

## Flow

### Bootstrap

```mermaid
flowchart LR
    A[task-router] --> B[project-init]
    B --> C[project-indexer]
```

### Feature: Core Mode

```mermaid
flowchart LR
    A[task-router] --> B[feature-intake-gate]
    B --> C[repo-phase-orchestrator]
```

### Feature: Full Mode

```mermaid
flowchart LR
    A[task-router] --> B[feature-intake-gate]
    B --> C[brainstorming]
    C --> D[nestjs-sdd-planner]
    D --> E[repo-phase-orchestrator]
    E --> F[external execution]
    F --> G[project-indexer]
```

### Optional NestJS Profiles

```mermaid
flowchart LR
    A[task-router] --> B[nestjs-bug-fixer]
    B --> C[project-indexer]
```

```mermaid
flowchart LR
    A[task-router] --> B[nestjs-code-reviewer]
```

```mermaid
flowchart LR
    A[task-router] --> B[nestjs-refactor-guardian]
    B --> C[project-indexer]
```

## Artifacts

```mermaid
flowchart TD
    A[brainstorming] --> B[docs/superpowers/specs/...-design.md]
    C[nestjs-sdd-planner] --> D[docs/codexminimal/specs/...-spec.md]
    E[repo-phase-orchestrator] --> F[docs/codexminimal/plans/...-phase-plan.md]
    E --> G[docs/codexminimal/trackers/...-tracker.md]
    E --> H[docs/codexminimal/current-work.json]
    E --> I[docs/codexminimal/artifact-registry.json]
    E --> J[docs/codexminimal/telemetry.json]
```

## Helper Layer

Bundled helper path hiện tại:

- `project-init/scripts/sync_agents_blocks.py`
- `project-init/scripts/bootstrap_docs_ai.py`
- `project-init/scripts/bootstrap_harness_runtime.py`
- `project-indexer/scripts/validate_context_map.py`
- `project-indexer/scripts/render_index_stubs.py`

Root-level `scripts/` vẫn có trong source repo để local verification và maintainer workflows.

## Install

```bash
git clone <your-repo-url>
cd CodexMinimal
bash check-codexminimal.sh
bash evals/run-sample-evals.sh
bash install.sh
```

`install.sh`:

- chạy readiness check ở chế độ gọn; chỉ in full log nếu check fail
- chỉ cài `Core mode`
- không overwrite unmanaged skills nếu không có `CODEXMINIMAL_FORCE=1`
- sẽ báo `Full mode available/unavailable` dựa trên companion skills trong `~/.codex/skills` hoặc plugin cache

## Quick Start

Trong repo đích:

```bash
cd /path/to/your-target-repo
```

Prompt đầu tiên:

```text
Use project-init in bootstrap mode for this repository, then run project-indexer in full mode.
```

Sau bootstrap, bạn sẽ có:

- `AGENTS.md`
- `docs/ai/`
- `docs/codexminimal/`

## Runtime State

```mermaid
flowchart LR
    A[current-work.json] --- B[artifact-registry.json]
    B --- C[telemetry.json]
    C --- D[phase tracker]
```

Ba file này giúp harness:

- biết artifact nào đang active
- chặn flow khi plan/tracker stale
- ghi lại phase handoff và verification

## Status

`Current state: local-ready beta`

- local checks: pass
- sample evals: pass
- real-repo trials: chưa phải phần bundle mặc định

## Docs

- [Setup](docs/setup.md)
- [Architecture](docs/architecture.md)
- [Skills](docs/skills.md)
- [Flows](docs/flows.md)
- [Artifacts](docs/artifacts.md)
- [Harness State](docs/harness-state.md)
- [Benchmark](docs/benchmark.md)
- [Evals](docs/evals.md)
- [Release Readiness](docs/release-readiness-plan.md)
