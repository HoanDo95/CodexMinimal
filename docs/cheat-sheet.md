# CodexMinimal Cheat Sheet

7 prompt ngắn để dùng hằng ngày trong repo đích.

## 1. Bootstrap repo

```text
Use task-router for repository bootstrap, then continue with project-init in bootstrap mode and project-indexer in full mode to build docs/ai and runtime state.
```

## 2. Thêm feature mới

```text
Use CodexMinimal IDSD flow for this feature request. Start with task-router, route through idsd-orchestrator, capture intent, ADR, bounded spec, task breakdown, tests, implementation handoff, verification, and report outline, then continue to repo-phase-orchestrator.
```

## 3. Sửa bug

```text
Use task-router for this bug and continue with the smallest suitable bug-fix flow. If the active profile is nestjs and the bug is already well-bounded, you may use nestjs-bug-fixer directly.
```

```text
Use task-router for this bug and continue with the smallest suitable bug-fix flow. If the active profile is rust and the bug is already well-bounded, you may use rust-bug-fixer directly.
```

## 4. Review code hoặc diff

```text
Use task-router for this review request and continue with the smallest suitable review flow. If the active profile is nestjs and the request is code-review only, you may use nestjs-code-reviewer.
```

```text
Use task-router for this review request and continue with the smallest suitable review flow. If the active profile is rust and the request is code-review only, you may use rust-code-reviewer.
```

## 5. Refactor an toàn

```text
Use task-router for this refactor request, check protected-file and risk boundaries first, then continue with the safest refactor flow. If the active profile is nestjs and the refactor is structure-heavy, you may use nestjs-refactor-guardian.
```

```text
Use task-router for this refactor request, check protected-file and risk boundaries first, then continue with the safest refactor flow. If the active profile is rust and the refactor is structure-heavy, you may use rust-refactor-guardian.
```

## 6. Ghi nhận feedback từ user

```text
Record this as explicit user feedback in CodexMinimal. Add or update the issue in docs/codexminimal/feedback-ledger.json, then keep the ledger consistent without promoting any new durable rule unless the strike threshold is reached.
```

## 7. Promote feedback thành durable rule

```text
Promote user-confirmed repeated feedback from docs/codexminimal/feedback-ledger.json into docs/ai/rule-registry.md if the configured strike threshold is reached, then confirm which durable rule was added.
```

## 8. Tạo trace để cải thiện CodexMinimal

```text
Start an IDSD trace for this task, keep runtime measurements in docs/codexminimal/telemetry.json, record repeated user-confirmed issues in docs/codexminimal/feedback-ledger.json, and use the trace results to improve CodexMinimal after verification.
```

## Gợi ý dùng ngắn hơn

Nếu anh không muốn prompt dài, có thể dùng kiểu tự nhiên:

```text
Add feature X to this repository. Use CodexMinimal flow.
```

```text
Fix bug Y in this repository. Use CodexMinimal flow.
```

```text
Review this diff. Use CodexMinimal flow.
```

## Flow Nhớ Nhanh

- Bootstrap:
  `task-router -> project-init -> project-indexer`
- Generic feature:
  `task-router -> idsd-orchestrator -> repo-phase-orchestrator -> tool adapter execution -> verification -> project-indexer`
- NestJS feature:
  `task-router -> idsd-orchestrator -> repo-phase-orchestrator -> tool adapter execution -> verification -> project-indexer`
- Rust feature:
  `task-router -> idsd-orchestrator -> repo-phase-orchestrator -> tool adapter execution -> verification -> project-indexer`
- User-mediated learning:
  `explicit user feedback -> record_feedback_issue.py -> feedback-ledger.json -> promote_feedback_rules.py -> rule-registry.md`
- Improvement evidence:
  `idsd-traces/<topic> + telemetry.json + feedback-ledger.json -> policy/eval improvement`
