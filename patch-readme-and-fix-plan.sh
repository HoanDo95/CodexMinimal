#!/usr/bin/env bash
set -euo pipefail

mkdir -p docs

cat > README.md <<'EOF'
# CodexMinimal

Minimal operating layer for Codex CLI.

CodexMinimal là một bộ skill giúp Codex làm việc với repository theo workflow rõ ràng hơn, đặc biệt khi repo có nhiều rule, nhiều module, hoặc cần giữ nhịp làm việc ổn định qua nhiều session.

Thay vì để Codex scan rộng và xử lý theo kiểu ad-hoc, CodexMinimal thêm các lớp:

- task routing
- project indexing
- durable rule persistence
- protected-file safety
- NestJS planning and delivery workflows
- local readiness validation

## 1. Tổng Quan Về Bộ Skill

CodexMinimal không phải một super-agent duy nhất.

Nó là một bộ skill nhỏ, mỗi skill giữ một trách nhiệm hẹp:

- `task-router`: phân loại request, chọn primary skill, gợi ý follow-up chain, model, effort, và safety gate
- `project-init`: tạo hoặc sync `AGENTS.md` và `docs/ai`
- `project-indexer`: build hoặc repair bộ index cho repository
- `nestjs-sdd-planner`: biến requirement thành spec sẵn sàng để implement
- `nestjs-tdd-builder`: implement behavior rõ ràng theo Red-Green-Refactor
- `nestjs-bug-fixer`: fix bug cụ thể với regression mindset
- `nestjs-code-reviewer`: review code hoặc diff mà không sửa file
- `nestjs-refactor-guardian`: làm refactor cấu trúc an toàn hơn
- `repo-phase-orchestrator`: chạy các task lớn theo phase

Mục tiêu chính là làm cho Codex:

- tìm đúng file sớm hơn
- bớt scan thừa
- nhớ rule của repo tốt hơn
- tránh sửa nhầm file nhạy cảm
- dùng workflow nhất quán hơn

## 2. Nó Có Thể Làm Được Gì

CodexMinimal phù hợp nhất khi user muốn Codex làm việc như một engineer có quy trình, không chỉ là một chatbot biết code.

### Ưu Điểm

- ép Codex phân loại task trước khi lao vào sửa
- ưu tiên index-first lookup thay vì broad search ngay từ đầu
- giữ được rule lâu dài qua `AGENTS.md` và `docs/ai`
- hỗ trợ workflow rõ cho plan, build, bug fix, review, refactor
- có guardrail cho protected files, env, deploy, database, multi-module work
- có self-check local để bắt các lỗi cấu trúc của chính bộ skill

### Nhược Điểm

- tối ưu nhất cho workflow kiểu repository engineering, không phải cho các câu hỏi quá nhỏ
- hiện tại bias mạnh về NestJS/TypeScript backend workflow
- vẫn cần user hoặc repo đích có convention đủ rõ để index và rule có giá trị
- readiness local pass không thay thế hoàn toàn validation trên repo thật
- nếu user thích workflow cực linh hoạt, bộ skill này sẽ thấy chặt hơn mặc định của Codex

### Khi Nào Nó Hợp

- repo có nhiều module
- repo có rule cần giữ lâu dài
- task dễ lan sang env/deploy/protected boundaries
- team muốn Codex làm việc theo flow lặp lại được

### Khi Nào Nó Không Hợp Lắm

- repo rất nhỏ, thay đổi đơn giản, ít rule
- task chỉ là vài câu hỏi một lần
- codebase không theo NestJS nhưng lại muốn dùng toàn bộ workflow như-is

## 3. Nó Có Dùng Chung Với Skill Khác Được Không

Có.

CodexMinimal có thể dùng chung với skill khác, nhưng nên hiểu vai trò của nó:

- CodexMinimal lo phần workflow repository
- skill khác có thể lo phần domain hoặc capability chuyên biệt

Ví dụ:

- dùng `task-router` để phân loại task trước
- sau đó dùng một skill khác cho domain cụ thể nếu repo hoặc môi trường yêu cầu
- khi xong thay đổi cấu trúc hoặc logic lớn, quay lại `project-indexer` để cập nhật index

Nguyên tắc thực tế:

- nếu skill khác giúp giải bài toán domain tốt hơn, cứ dùng
- nếu task chạm vào rule, protected files, index, refactor boundary, hoặc flow implementation, CodexMinimal vẫn nên là lớp điều phối

Nói ngắn gọn:

- CodexMinimal không thay thế toàn bộ skill khác
- nó phù hợp làm lớp workflow chung ở trên các skill khác

## 4. Hướng Dẫn Tải Và Cài Đặt

### Bước 1: tải repo

```bash
git clone <your-repo-url>
cd CodexMinimal
```

### Bước 2: chạy local readiness check

```bash
bash check-codexminimal.sh
```

### Bước 3: cài skill vào Codex home

```bash
bash install.sh
```

Mặc định, install và uninstall là conservative:

- install không overwrite một skill cùng tên nếu skill đó không được CodexMinimal quản lý
- uninstall chỉ xóa skill có marker của CodexMinimal

Nếu thật sự muốn force overwrite:

```bash
CODEXMINIMAL_FORCE=1 bash install.sh
```

## 5. Hướng Dẫn Khởi Đầu

Sau khi cài xong, user không làm việc trong repo `CodexMinimal` nữa, mà chuyển sang repo đích cần Codex hỗ trợ.

Flow khởi đầu nên là:

### Bước 1: mở repo đích

Ví dụ:

```bash
cd /path/to/your-target-repo
```

### Bước 2: bootstrap repository

Prompt đầu tiên nên là:

```text
Use project-init in bootstrap mode for this repository, then run project-indexer in full mode.
```

Mục tiêu của bước này:

- tạo hoặc sync `AGENTS.md`
- tạo `docs/ai`
- build bộ index ban đầu

### Bước 3: bắt đầu dùng theo task type

Feature mới:

```text
task-router -> nestjs-sdd-planner -> nestjs-tdd-builder -> project-indexer
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
task-router -> repo-phase-orchestrator
```

## Quick Start

Nếu chỉ cần bản ngắn nhất:

```bash
git clone <your-repo-url>
cd CodexMinimal
bash check-codexminimal.sh
bash install.sh
```

Sau đó vào repo đích và dùng prompt:

```text
Use project-init in bootstrap mode for this repository, then run project-indexer in full mode.
```

## Tài Liệu Tham Chiếu

- [docs/setup.md](docs/setup.md)
- [docs/architecture.md](docs/architecture.md)
- [docs/skills.md](docs/skills.md)
- [docs/flows.md](docs/flows.md)
- [docs/indexing.md](docs/indexing.md)
- [docs/model-routing.md](docs/model-routing.md)
- [docs/nestjs-spec.md](docs/nestjs-spec.md)
- [docs/rule-registry.md](docs/rule-registry.md)
- [docs/release-readiness-plan.md](docs/release-readiness-plan.md)

## Trạng Thái

Current state: `beta`.

Repo hiện đã ổn hơn về cấu trúc và guardrail nội bộ, nhưng vẫn nên được thử trên repo NestJS thật để tiếp tục harden workflow, index quality, và default prompt behavior.
EOF
