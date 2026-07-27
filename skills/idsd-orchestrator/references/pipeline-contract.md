# IDSD Pipeline Contract

Default pipeline:

1. Intent: capture user goal, business rules, constraints, non-goals, and acceptance criteria.
2. Solution Challenge: compare viable options, reject weak alternatives, and record why the selected path survives counterarguments.
3. System Design Gate: record architecture, API, data, integration, failure-mode, compatibility, and operational boundaries when risk requires it.
4. Architecture Decision: record ADR-style decisions with selected path, rejected options, risk, and evidence.
5. Specification: write a bounded specification, not a full document set.
6. Task Breakdown: split implementation into ordered, reviewable tasks.
7. QA Evidence: define edge cases, regression targets, and acceptance evidence before execution.
8. Tests: define TDD expectations, failing tests, or justified verification alternatives.
9. Implementation: hand off only after the previous stages are bounded.
10. Verification: record commands, outcomes, QA verdict, and evidence gaps.
11. Report: summarize outcome, residual risks, and follow-up work.

Keep each stage concise. Expand only when risk, protected files, public contracts, data migrations, or security boundaries require it.

The SDD stage in this pipeline is bounded specification. It is not a separate spec-first workflow.

Use `solution_challenger`, `system_designer`, and `senior_qa` only when they add real confidence. When selected, all three gate outputs must be considered before phase planning, and the phase tracker must record their evidence status. They are quality gates inside IDSD and phase planning, not replacement executors for Codex CLI native execution.
