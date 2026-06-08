# CodexMinimal

Minimal harness layer for Codex CLI.

CodexMinimal không cố trở thành một super-agent. Nó là lớp điều phối để giúp LLM làm việc có kiểm soát hơn:

- route request vào đúng workflow nhỏ nhất
- giữ durable rules, project memory và runtime state
- ép feature mới đi qua IDSD: intent contract, agent cards, decision ledger, acceptance evidence và phase plan
- tách stack-specific workflow như `nestjs` và `rust` khỏi core
- ưu tiên index-first lookup để giảm context scan thừa
- chạy readiness, install smoke test và eval để tránh skill/profile hỏng âm thầm

## System Overview

```mermaid
flowchart TB
    U[User Query] --> R[task-router]

    R -->|repo setup| PI[project-init]
    PI --> IDX[project-indexer]

    R -->|new or unclear feature| IDSD[idsd-orchestrator]
    IDSD --> PLAN[repo-phase-orchestrator]
    PLAN --> EXEC[external execution]
    EXEC --> IDX

    R -->|bug / review / refactor| PROFILE[optional profile skill]
    PROFILE --> IDX

    IDX --> STATE[docs/ai + docs/codexminimal state]
```

## Layer Model

```mermaid
flowchart LR
    Core[Core Harness] --> Generic[generic profile]
    Core --> Nest[NestJS profile optional]
    Core --> Rust[Rust profile optional]
    Core --> Checks[readiness + evals]
    Core --> CLI[Codex CLI opt-in tooling]

    Nest --> NS[nestjs-sdd / tdd / bug / review / refactor]
    Rust --> RS[rust-sdd / tdd / bug / review / refactor]
```

| Layer | Vai trò |
|---|---|
| `Core Harness` | route task, giữ rules, tạo intent evidence/plan/tracker, cập nhật index |
| `Profile Layer` | thêm rule và skill riêng cho stack như `nestjs` hoặc `rust` |
| `Execution Layer` | thực thi code thật bằng Codex agent, Superpowers skill hoặc flow riêng của team |

Core mặc định không assume repo là NestJS hay Rust. Active profile nên được ghi ở `docs/ai/stack-profile.md`.

## Core Skills

| Skill | Dùng để làm gì |
|---|---|
| `task-router` | phân loại request, chọn workflow, model/effort, context budget và safety gate |
| `idsd-orchestrator` | biến intent thành intent contract, agent cards, decision ledger và acceptance evidence |
| `project-init` | bootstrap hoặc sync `AGENTS.md`, `docs/ai`, `docs/codexminimal` |
| `project-indexer` | tạo/cập nhật index để LLM không scan repo rộng |
| `repo-phase-orchestrator` | tạo phase plan, tracker và runtime state |

Legacy compatibility skills như `feature-intake-gate` và `implementation-spec-writer` chỉ được cài khi dùng `CODEXMINIMAL_INSTALL_PROFILES=legacy`.

`check-codexminimal.sh` enforce skill entrypoint nhỏ: core skills tối đa 200 dòng, optional profile skills tối đa 120 dòng. Policy dài nên nằm trong `references/`.

## Main Flows

### Bootstrap Repo

```mermaid
flowchart LR
    A[task-router] --> B[project-init]
    B --> C[project-indexer]
```

Dùng khi repo chưa có `AGENTS.md`, `docs/ai`, `docs/codexminimal` hoặc các file này đã stale.

### New Feature

```mermaid
flowchart LR
    A[task-router] --> B[idsd-orchestrator]
    B --> C[repo-phase-orchestrator]
    C --> D[external execution]
    D --> E[verification]
    E --> F[project-indexer]
```

Dùng khi requirement mới, chưa rõ, hoặc thay đổi behavior. Mục tiêu là không để LLM code khi chưa có intent contract, agent cards, decision ledger, acceptance evidence và phase boundary.

### Bug Fix

```mermaid
flowchart LR
    A[task-router] --> B{active profile?}
    B -->|nestjs| C[nestjs-bug-fixer]
    B -->|rust| D[rust-bug-fixer]
    B -->|generic| E[normal debug / execution path]
    C --> F[project-indexer]
    D --> F
    E --> F
```

Dùng khi đã có failing test, runtime error, compiler error, panic, regression hoặc behavior sai rõ ràng.

### Code Review

```mermaid
flowchart LR
    A[task-router] --> B{review surface}
    B -->|profile-aware review| C[nestjs-code-reviewer or rust-code-reviewer]
    B -->|independent CLI pass| D[safe_codex_review.sh]
    D --> E[codex review]
```

Dùng khi cần findings-only hoặc muốn thêm một lượt review độc lập trước khi merge/push.

### Refactor

```mermaid
flowchart LR
    A[task-router] --> B{active profile?}
    B -->|nestjs| C[nestjs-refactor-guardian]
    B -->|rust| D[rust-refactor-guardian]
    C --> E[project-indexer]
    D --> E
```

Dùng khi move/rename/split module, đổi folder structure hoặc chạm vào boundary dễ gây regression.

## Profiles

| Profile | Khi nào dùng | Skills |
|---|---|---|
| `generic` | default, không áp framework assumption | core skills |
| `nestjs` | repo NestJS hoặc user chọn NestJS | `nestjs-sdd-planner`, `nestjs-tdd-builder`, `nestjs-bug-fixer`, `nestjs-code-reviewer`, `nestjs-refactor-guardian` |
| `rust` | repo Rust hoặc user chọn Rust | `rust-sdd-planner`, `rust-tdd-builder`, `rust-bug-fixer`, `rust-code-reviewer`, `rust-refactor-guardian` |

Design rule:

- profile chỉ bật từ repo evidence rõ hoặc user chỉ định
- stack-specific rules không nhồi vào generic `AGENTS.md`
- `nestjs` và `rust` có thể cài riêng hoặc cùng lúc

## Install

```bash
git clone <your-repo-url>
cd CodexMinimal
bash check-codexminimal.sh
bash evals/run-sample-evals.sh
bash install.sh
```

Cài thêm profile:

```bash
CODEXMINIMAL_INSTALL_PROFILES=nestjs bash install.sh
CODEXMINIMAL_INSTALL_PROFILES=rust bash install.sh
CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust bash install.sh
CODEXMINIMAL_INSTALL_PROFILES=legacy bash install.sh
```

`install.sh`:

- mặc định chỉ cài core
- cài profile chỉ khi có `CODEXMINIMAL_INSTALL_PROFILES`
- không overwrite unmanaged skills nếu không có `CODEXMINIMAL_FORCE=1`
- chạy readiness check gọn trước khi install, trừ khi `CODEXMINIMAL_SKIP_READINESS=1`

## Quick Start In Target Repo

Trong repo đích:

```bash
cd /path/to/your-target-repo
```

Prompt bootstrap:

```text
Use task-router for this repository bootstrap request, then continue the standard bootstrap flow.
```

Sau bootstrap, repo đích sẽ có:

- `AGENTS.md`
- `docs/ai/`
- `docs/ai/stack-profile.md`
- `docs/codexminimal/`

Prompt mẫu hằng ngày nằm ở [docs/cheat-sheet.md](docs/cheat-sheet.md).

Hướng dẫn dùng IDSD trace trong repo đích nằm ở [docs/idsd-usage-guide.md](docs/idsd-usage-guide.md).

## Runtime State

```mermaid
flowchart LR
    A[current-work.json] --- B[artifact-registry.json]
    B --- C[telemetry.json]
    C --- D[phase tracker]
```

Các file runtime giúp harness:

- biết artifact nào đang active
- phát hiện plan/tracker stale
- ghi lại phase handoff và verification outcome
- tạo nền để đo workflow có giảm exploration waste hay không

## Verification

```bash
bash check-codexminimal.sh
bash evals/run-sample-evals.sh
```

Readiness hiện kiểm tra:

- root files, scripts, JSON/schema
- skill frontmatter và required sections
- line budget cho core/profile skills
- helper scripts và template sync
- install smoke test cho `core`, `nestjs`, `rust`, `nestjs,rust`

## Codex CLI Usage

Codex CLI được dùng như optional automation, không thay thế skill routing mặc định.

| Surface | Dùng để làm gì | Policy |
|---|---|---|
| `codex exec --json` | LLM eval có schema, regression capture cho router/planner | opt-in bằng `CODEXMINIMAL_RUN_LLM_EVALS=1` |
| `codex review` | independent code-review pass cho diff/commit/branch | dùng `scripts/safe_codex_review.sh`, yêu cầu explicit approval |
| `codex doctor --json` | debug môi trường, auth, model, CLI behavior | không chạy trong default readiness |

Opt-in LLM eval:

```bash
CODEXMINIMAL_RUN_LLM_EVALS=1 python3 scripts/run_codex_exec_evals.py \
  --cases evals/task-router-golden-cases.json \
  --schema skills/task-router/assets/router-output.schema.json \
  --output evals/results/task-router-codex-exec-results.json
```

Guarded review:

```bash
CODEXMINIMAL_ALLOW_EXTERNAL_REVIEW=1 scripts/safe_codex_review.sh --commit <sha>
```

## Status

`Current state: local-ready beta`

- core harness: ready for local use
- NestJS profile: bundled optional profile
- Rust profile: bundled optional profile
- readiness + sample evals: available
- real-repo dogfood and deeper token/context metrics: intentionally pending

## Documentation

- [Setup](docs/setup.md)
- [Cheat Sheet](docs/cheat-sheet.md)
- [Architecture](docs/architecture.md)
- [Skills](docs/skills.md)
- [Profiles](docs/profiles.md)
- [Flows](docs/flows.md)
- [Artifacts](docs/artifacts.md)
- [Harness State](docs/harness-state.md)
- [Codex CLI Playbook](docs/codex-cli-playbook.md)
- [Review Policy](docs/review-policy.md)
- [Evals](docs/evals.md)
- [Benchmark](docs/benchmark.md)
- [Model Routing](docs/model-routing.md)
- [Model Compatibility](docs/model-compatibility.md)
- [Release Readiness](docs/release-readiness-plan.md)
