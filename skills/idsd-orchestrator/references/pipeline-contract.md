# IDSD Pipeline Contract

Default pipeline:

1. Intent: capture user goal, business rules, constraints, non-goals, and acceptance criteria.
2. Architecture Decision: record ADR-style decisions with selected path, rejected options, risk, and evidence.
3. Specification: write a bounded specification, not a full document set.
4. Task Breakdown: split implementation into ordered, reviewable tasks.
5. Tests: define TDD expectations, failing tests, or justified verification alternatives.
6. Implementation: hand off only after the previous stages are bounded.
7. Verification: record commands, outcomes, and evidence gaps.
8. Report: summarize outcome, residual risks, and follow-up work.

Keep each stage concise. Expand only when risk, protected files, public contracts, data migrations, or security boundaries require it.

The SDD stage in this pipeline is bounded specification. It is not a separate spec-first workflow.
