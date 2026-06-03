# CodexMinimal

Minimal operating layer for Codex CLI.

CodexMinimal là bộ skill và helper giúp Codex bám task hơn, ít lan man hơn, và làm việc với repository theo workflow ổn định hơn. Nó phù hợp nhất khi repo có nhiều module, có rule cần giữ lâu dài, hoặc có các vùng nhạy cảm như deploy, env, migration, hay multi-module refactor.

Về vai trò, CodexMinimal nên được hiểu là một `harness / orchestrator layer`:

- nó route task
- nó giữ rule và project memory
- nó viết spec theo profile khi cần
- nó viết phase plan và tracker trước execution
- nó refresh index sau work

Phần execution nên mặc định được handoff ra workflow ngoài như `Superpowers`, thay vì để core của CodexMinimal bị khóa chặt vào một stack duy nhất.

Thay vì để model scan rộng và xử lý ad-hoc, CodexMinimal thêm các lớp điều phối nhỏ nhưng rõ:

- task routing
- index-first lookup
- durable rule persistence
- protected-file safety
- action-risk guardrails
- compact response mode
- context budget control
- local readiness checks
- local golden evals

## 1. Tổng Quan Về Bộ Skill

CodexMinimal không phải một super-agent duy nhất. Nó là một bộ skill hẹp vai trò, chia thành 3 lớp:

### Core Harness

- `task-router`: phân loại request, chọn primary skill, follow-up chain, model, effort, response mode, context budget, và safety gate
- `feature-intake-gate`: gate mặc định cho feature mới để ép đi qua `brainstorm -> spec -> phase plan`
- `repo-phase-orchestrator`: viết phase plan, tạo tracker, rồi handoff execution
- `project-init`: tạo hoặc sync `AGENTS.md`, `docs/ai`, `docs/codexminimal`, rule registry, protected files
- `project-indexer`: build hoặc repair bộ index cho repository

### External Stage And Execution Skills

- `brainstorming`: khóa requirement, constraints, và hướng thiết kế trước khi viết spec
- `subagent-driven-development`: execution mặc định sau khi current phase đã sẵn sàng
- `executing-plans`: fallback execution path khi không muốn dùng subagent-driven execution

### Profile-Specific Skills

- `nestjs-sdd-planner`: biến requirement thành spec sẵn sàng để implement
- `nestjs-tdd-builder`: optional NestJS execution profile
- `nestjs-bug-fixer`: optional NestJS bug-fix profile
- `nestjs-code-reviewer`: optional NestJS review profile
- `nestjs-refactor-guardian`: optional NestJS refactor profile

Ngoài prompt skills, repo còn có deterministic helpers để giảm phần model phải tự soạn format lặp lại:

- sync managed blocks trong `AGENTS.md`
- bootstrap `docs/ai`
- bootstrap `docs/codexminimal`
- validate `context-map.json`
- validate harness runtime state
- render các index stub còn thiếu

### Tóm Tắt Luồng Hiện Tại

Các luồng chính hiện tại là:

- bootstrap repo:
  `task-router -> project-init -> project-indexer`
- feature mới, theo core harness path:
  `task-router -> feature-intake-gate -> repo-phase-orchestrator -> external execution -> project-indexer`
- bên trong `feature-intake-gate`:
  `brainstorming -> nestjs-sdd-planner -> repo-phase-orchestrator`
- bug fix, nếu repo vẫn muốn dùng NestJS bundled profile:
  `task-router -> nestjs-bug-fixer -> project-indexer`
- code review, nếu repo vẫn muốn dùng NestJS bundled profile:
  `task-router -> nestjs-code-reviewer`
- refactor, nếu repo vẫn muốn dùng NestJS bundled profile:
  `task-router -> nestjs-refactor-guardian -> project-indexer`
- phased work:
  `task-router -> repo-phase-orchestrator -> external execution`

Nói ngắn gọn:

- core path đi qua `brainstorm -> spec -> phase plan -> external execution`
- bug fix/review/refactor hiện vẫn có NestJS profiles đi kèm, nhưng chúng không còn là boundary mặc định của core harness

### Skill Nào Viết Spec Và Plan

Hiện tại có 3 skill liên quan trực tiếp tới phần này:

- `feature-intake-gate`: không tự viết code hay plan chi tiết; nó chỉ orchestrate đúng stage cần chạy tiếp
- `nestjs-sdd-planner`: viết `spec`
- `repo-phase-orchestrator`: viết `phase plan` và `tracker`

Vai trò được tách như sau:

- `brainstorming` khóa requirement, constraints, options, và design direction
- `nestjs-sdd-planner` biến design direction đó thành spec sẵn sàng để implement
- `repo-phase-orchestrator` biến spec đã approved thành phase plan và tracker để chuẩn bị execution

### Plan Đang Được Viết Như Thế Nào

`repo-phase-orchestrator` hiện chịu trách nhiệm viết phase plan và tracker theo kiểu harness:

- plan được chia thành phase
- mỗi phase có goal, scope, files/modules, verification, stop condition, handoff notes
- tracker được tách riêng khỏi plan
- với work không nhỏ, phase plan được kỳ vọng đủ chi tiết để làm tài liệu handoff cho execution workflow và tối thiểu khoảng `200` dòng

Trong khi đó `nestjs-sdd-planner` không còn ôm luôn phase plan chi tiết nữa. Nó chỉ viết:

- scope
- non-goals
- affected modules
- API contract
- DTO/service/persistence behavior
- validation/errors
- acceptance criteria
- test plan
- implementation handoff notes

Tức là:

- `spec` và `phase plan` hiện đã tách trách nhiệm rõ
- `spec` mô tả cái cần build
- `phase plan` mô tả build theo phase nào và handoff như thế nào

### Skill Nào Sẽ Execute

Sau khi phase plan đã có, execution mặc định nên được handoff cho skill ngoài của `Superpowers`, chủ yếu là:

- `subagent-driven-development`
- `executing-plans`

Trong khi đó các skill execute nội bộ hiện tại như:

- `nestjs-tdd-builder`
- `nestjs-bug-fixer`
- `nestjs-code-reviewer`
- `nestjs-refactor-guardian`

Vai trò thực tế:

- được xem là optional hoặc legacy execution profiles
- không phải lớp harness lõi
- `project-indexer` thường là bước follow-up sau execution để cập nhật lại index

### Artifacts Được Lưu Ở Đâu

Hiện tại artifact path được chốt theo stage như sau:

- brainstorm design:
  `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
- implementation spec:
  `docs/codexminimal/specs/YYYY-MM-DD-<topic>-spec.md`
- phase plan:
  `docs/codexminimal/plans/YYYY-MM-DD-<topic>-phase-plan.md`
- tracker:
  `docs/codexminimal/trackers/YYYY-MM-DD-<topic>-tracker.md`
- current runtime state:
  `docs/codexminimal/current-work.json`
- artifact registry:
  `docs/codexminimal/artifact-registry.json`
- telemetry:
  `docs/codexminimal/telemetry.json`

Điều này giữ rõ boundary:

- design discovery và execution workflow có thể ở ngoài
- spec, phase plan, tracker vẫn là artifact lõi của CodexMinimal
- current-work, artifact-registry, và telemetry giúp harness giữ state giữa các stage

## 2. Nó Có Thể Làm Được Gì

CodexMinimal phù hợp khi user muốn Codex làm việc như một engineer có quy trình, không chỉ là chatbot biết code.

### Đánh Giá Tổng Quát Hiện Tại

Ở trạng thái hiện tại, tôi đánh giá CodexMinimal đã đạt mức `local-ready beta` khá chắc cho mục tiêu ban đầu:

- bám task tốt hơn Codex mặc định nhờ router, index-first lookup, và rule persistence
- ít lan man hơn nhờ `compact` response mode, context budget, và auto-compact policy
- đỡ phụ thuộc vào prompt wording hơn nhờ deterministic helper scripts
- dễ tự kiểm hơn nhờ readiness check và sample evals

Điểm chưa chốt hoàn toàn:

- chưa có benchmark trên repo NestJS thật
- chưa có số đo thực chiến về số file đọc, số broad scan, và thời gian hoàn thành task
- chưa có bằng chứng dài phiên về lợi ích token ngoài lớp policy hiện tại

### Ưu Điểm

- ép Codex phân loại task trước khi sửa file
- ưu tiên index-first lookup thay vì broad search ngay từ đầu
- giữ rule lâu dài qua `AGENTS.md` và `docs/ai`
- có compact mode và context budget để ưu tiên tốc độ
- có guardrail cho protected files, env, deploy, database, và refactor rủi ro cao
- có helper deterministic để giảm retry và giảm lỗi format
- có local readiness check và sample evals để tự kiểm nhanh bộ skill

### Nhược Điểm

- tối ưu nhất cho workflow kiểu repository engineering, không phải cho các câu hỏi quá nhỏ
- hiện tại bias mạnh về NestJS và TypeScript backend workflow
- local checks pass không thay thế validation trên repo thật
- nếu user thích workflow rất tự do, bộ này sẽ chặt hơn mặc định của Codex

### Khi Nào Hợp

- repo có nhiều module hoặc nhiều rule
- task dễ chạm vào deploy, env, database, protected boundaries
- team muốn workflow có thể lặp lại qua nhiều session
- user ưu tiên tốc độ nhưng vẫn muốn model bám task

### Khi Nào Không Hợp Lắm

- repo rất nhỏ, thay đổi đơn giản, ít rule
- task chỉ là vài câu hỏi một lần
- codebase không theo NestJS nhưng lại muốn dùng toàn bộ workflow như-is

## 3. Có Dùng Chung Với Skill Khác Được Không

Có.

CodexMinimal nên được hiểu là lớp workflow ở trên, không phải lớp domain duy nhất.

- CodexMinimal lo routing, guardrails, rule persistence, indexing, và execution discipline
- skill khác có thể lo domain chuyên biệt như security, frontend design, hay payment

Nguyên tắc thực tế:

- nếu skill khác giải bài toán domain tốt hơn, cứ dùng
- nếu task chạm vào rule, protected files, index, refactor boundary, hoặc flow implementation, CodexMinimal vẫn nên làm lớp điều phối
- khi đổi cấu trúc repo hoặc logic lớn, nên quay lại `project-indexer` để refresh index

## 4. Hướng Dẫn Tải Và Cài Đặt

### Bước 1: tải repo

```bash
git clone <your-repo-url>
cd CodexMinimal
```

### Bước 2: kiểm tra local readiness

```bash
bash check-codexminimal.sh
```

### Bước 3: chạy sample evals

```bash
bash evals/run-sample-evals.sh
```

### Bước 4: cài skill vào Codex home

```bash
bash install.sh
```

Install hiện tại là conservative:

- không overwrite skill cùng tên nếu skill đó không do CodexMinimal quản lý
- uninstall chỉ xóa skill có marker của CodexMinimal

Nếu thật sự muốn force overwrite:

```bash
CODEXMINIMAL_FORCE=1 bash install.sh
```

## 5. Hướng Dẫn Khởi Đầu

Sau khi cài xong, user chuyển sang repo đích cần Codex hỗ trợ.

### Bước 1: mở repo đích

```bash
cd /path/to/your-target-repo
```

### Bước 2: bootstrap repository

Prompt đầu tiên nên là:

```text
Use project-init in bootstrap mode for this repository, then run project-indexer in full mode.
```

Mục tiêu:

- tạo hoặc sync `AGENTS.md`
- tạo `docs/ai`
- tạo `docs/codexminimal`
- build bộ index ban đầu

### Bước 3: dùng theo task type

Feature mới:

```text
task-router -> feature-intake-gate -> repo-phase-orchestrator -> external execution -> project-indexer
```

Trong `feature-intake-gate`, stage mặc định là:

```text
brainstorming -> nestjs-sdd-planner -> repo-phase-orchestrator
```

Nếu design direction đã rõ nhưng vẫn chưa nên code ngay:

```text
task-router -> nestjs-sdd-planner -> repo-phase-orchestrator
```

Bug fix:

```text
task-router -> nestjs-bug-fixer -> project-indexer
```

Code review:

```text
task-router -> nestjs-code-reviewer
```

Refactor:

```text
task-router -> nestjs-refactor-guardian -> project-indexer
```

Task lớn nhiều phase:

```text
task-router -> repo-phase-orchestrator -> external execution
```

Nếu user ưu tiên tốc độ:

- dùng `compact` response mode
- ưu tiên `low` hoặc `medium` context budget
- chỉ nâng lên `high` khi task thật sự mơ hồ, nhiều module, hoặc có rủi ro cao

Với feature hoặc behavior change mới:

- không nên nhảy thẳng từ prompt sang code
- flow mặc định nên là `feature-intake-gate -> phase plan -> external execution`
- còn bên trong gate là `brainstorm -> spec -> phase plan`
- điều này giúp model khóa đúng intent sớm hơn và giảm trôi hướng khi session dài

Về helper scripts trong `scripts/`:

- mục tiêu chính là để agent tự ưu tiên dùng cho các bước lặp, không phải bắt user chạy tay
- user vẫn có thể chạy trực tiếp để kiểm tra hoặc bootstrap thủ công khi cần
- khi workflow đã ổn, `project-init` và `project-indexer` nên coi các helper này là đường mặc định cho phần việc deterministic

- `sync_agents_blocks.py`
- `bootstrap_docs_ai.py`
- `bootstrap_harness_runtime.py`
- `validate_context_map.py`
- `validate_harness_runtime.py`
- `render_index_stubs.py`

## Quick Start

Nếu chỉ cần bản ngắn nhất:

```bash
git clone <your-repo-url>
cd CodexMinimal
bash check-codexminimal.sh
bash evals/run-sample-evals.sh
bash install.sh
```

Sau đó vào repo đích và dùng prompt:

```text
Use project-init in bootstrap mode for this repository, then run project-indexer in full mode.
```

## Benchmark Hiện Tại

Benchmark hiện có là `local benchmark`, chưa phải `real-repo benchmark`.

Các số đo local mới nhất:

- `bash check-codexminimal.sh`: khoảng `0.87s`
- `bash evals/run-sample-evals.sh`: khoảng `0.20s`
- `bootstrap_docs_ai.py` trên repo tạm rỗng: khoảng `0.03s`
- `bootstrap_harness_runtime.py` trên repo tạm rỗng: khoảng `0.02s`
- `render_index_stubs.py` trên `docs/ai` tạm: khoảng `0.02s`
- `validate_context_map.py`: khoảng `0.02s`
- `validate_harness_runtime.py`: khoảng `0.02s`
- `sync_agents_blocks.py --check`: khoảng `0.02s`

Ý nghĩa thực tế:

- chi phí local của harness hiện khá thấp
- helper scripts đủ nhanh để làm default path cho phần deterministic
- nút thắt còn lại nằm ở real-repo trials, không còn ở lớp local scaffolding

## Trạng Thái Hiện Tại

Current state: `local-ready beta`.

Điều này có nghĩa là:

- các file skill/docs không còn bị cắt cụt
- bundled checks và sample evals đã có thể chạy local
- guardrails, compact mode, context budget, và helper scripts đã có mặt

Lưu ý về compact:

- hiện tại đã có `compact mode` ở lớp routing và policy
- đã có thêm rule `auto-compact` theo budget và trạng thái workflow cho session dài
- đây vẫn là compaction ở lớp workflow/instruction, không phải một centralized compression engine độc lập cho mọi cuộc hội thoại

Về harness:

- hiện tại repo này đúng là một `local workflow harness`
- nó chưa cố biến mình thành execution framework đa stack
- phần harness được thể hiện rõ nhất ở `task-router`, `feature-intake-gate`, `repo-phase-orchestrator`, `project-init`, `project-indexer`, `current-work.json`, `artifact-registry.json`, `telemetry.json`, readiness checks, sample evals, và helper scripts

`spawn agent` có liên quan ở lớp execution strategy, nhưng không phải thứ định nghĩa harness. Harness ở đây là:

- route đúng stage
- tạo đúng artifact
- giữ đúng guardrail
- handoff đúng executor

Phần còn lại chưa chốt xong là benchmark trên repo NestJS thật. Nói ngắn gọn: lớp scaffolding nội bộ đã đủ chặt để cài và dùng local; phần hardening tiếp theo nên dựa trên real-repo trials khi có repo mục tiêu.

## Tài Liệu Tham Chiếu

- [docs/setup.md](docs/setup.md)
- [docs/architecture.md](docs/architecture.md)
- [docs/skills.md](docs/skills.md)
- [docs/flows.md](docs/flows.md)
- [docs/indexing.md](docs/indexing.md)
- [docs/model-routing.md](docs/model-routing.md)
- [docs/model-compatibility.md](docs/model-compatibility.md)
- [docs/action-risk.md](docs/action-risk.md)
- [docs/compact-mode.md](docs/compact-mode.md)
- [docs/context-budget.md](docs/context-budget.md)
- [docs/nestjs-spec.md](docs/nestjs-spec.md)
- [docs/rule-registry.md](docs/rule-registry.md)
- [docs/evals.md](docs/evals.md)
- [docs/benchmark.md](docs/benchmark.md)
- [docs/artifacts.md](docs/artifacts.md)
- [docs/harness-state.md](docs/harness-state.md)
- [docs/release-readiness-plan.md](docs/release-readiness-plan.md)
