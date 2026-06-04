# Rule Registry

`docs/ai/rule-registry.md` is the durable source of repository-specific rules.

`AGENTS.md` is the operational rendering of those rules.

Persist durable rules here when the user defines or changes:

- protected paths
- testing layout
- architecture constraints
- deployment or env boundaries
- repository-specific coding conventions
- repeated feedback that has crossed the configured promotion threshold

When a rule changes:

1. update `docs/ai/rule-registry.md`
2. update `docs/ai/protected-files.md` if path protection changed
3. update `docs/ai/architecture-notes.md` if architecture changed
4. sync the generated CodexMinimal blocks in `AGENTS.md`
5. if the same issue has been confirmed repeatedly by explicit user feedback, update `docs/codexminimal/feedback-ledger.json` and promote it into `docs/ai/rule-registry.md` once it hits the configured strike threshold
