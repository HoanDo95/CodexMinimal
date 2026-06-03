# CodexMinimal Cheat Sheet

5 prompt ngắn để dùng hằng ngày trong repo đích.

## 1. Bootstrap repo

```text
Use project-init in bootstrap mode for this repository, then run project-indexer in full mode to build docs/ai and runtime state.
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
  `project-init -> project-indexer`
- Generic feature:
  `task-router -> feature-intake-gate -> implementation-spec-writer -> repo-phase-orchestrator -> external execution -> project-indexer`
- NestJS feature:
  `task-router -> feature-intake-gate -> nestjs-sdd-planner -> repo-phase-orchestrator -> external execution -> project-indexer`
