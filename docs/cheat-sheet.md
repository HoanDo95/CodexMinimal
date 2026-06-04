# CodexMinimal Cheat Sheet

7 prompt ngắn để dùng hằng ngày trong repo đích.

## 1. Bootstrap repo

```text
Use task-router for repository bootstrap, then continue with project-init in bootstrap mode and project-indexer in full mode to build docs/ai and runtime state.
```

## 2. Thêm feature mới

```text
Use CodexMinimal flow for this feature request. Start with task-router, route through feature-intake-gate, write the spec with implementation-spec-writer unless the active profile says otherwise, then continue to repo-phase-orchestrator.
```

## 3. Sửa bug

```text
Use task-router for this bug and continue with the smallest suitable bug-fix flow. If the active profile is nestjs and the bug is already well-bounded, you may use nestjs-bug-fixer directly.
```

## 4. Review code hoặc diff

```text
Use task-router for this review request and continue with the smallest suitable review flow. If the active profile is nestjs and the request is code-review only, you may use nestjs-code-reviewer.
```

## 5. Refactor an toàn

```text
Use task-router for this refactor request, check protected-file and risk boundaries first, then continue with the safest refactor flow. If the active profile is nestjs and the refactor is structure-heavy, you may use nestjs-refactor-guardian.
```

## 6. Ghi nhận feedback từ user

```text
Record this as explicit user feedback in CodexMinimal. Add or update the issue in docs/codexminimal/feedback-ledger.json, then keep the ledger consistent without promoting any new durable rule unless the strike threshold is reached.
```

## 7. Promote feedback thành durable rule

```text
Promote user-confirmed repeated feedback from docs/codexminimal/feedback-ledger.json into docs/ai/rule-registry.md if the configured strike threshold is reached, then confirm which durable rule was added.
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
  `task-router -> feature-intake-gate -> implementation-spec-writer -> repo-phase-orchestrator -> external execution -> project-indexer`
- NestJS feature:
  `task-router -> feature-intake-gate -> nestjs-sdd-planner -> repo-phase-orchestrator -> external execution -> project-indexer`
- User-mediated learning:
  `explicit user feedback -> record_feedback_issue.py -> feedback-ledger.json -> promote_feedback_rules.py -> rule-registry.md`
