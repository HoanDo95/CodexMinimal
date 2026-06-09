# IDSD

IDSD is CodexMinimal's default workflow for new features and changed behavior.

IDSD means Intent-Driven Spec Development in this repository. The goal is to reduce traditional SDD overhead while preserving evidence, reviewability, and safety.

## Core Idea

The user supplies intent, business rules, constraints, and acceptance criteria. The agent then creates the minimum operating package needed to proceed:

- intent contract
- architecture decisions
- bounded specification
- task breakdown
- test contract
- agent cards
- decision ledger
- acceptance evidence
- implementation handoff
- verification evidence
- report outline

## Default Pipeline

`Intent (IDSD) -> Architecture Decision (ADR) -> Specification (bounded SDD) -> Task Breakdown -> Tests (TDD) -> Implementation -> Verification -> Report`

IDSD owns the pipeline. SDD and TDD are bounded evidence stages inside IDSD, not separate default workflows.

The deterministic scaffold helper can create the initial package:

```bash
python3 scripts/scaffold_idsd_intent.py \
  --topic "billing rollout" \
  --intent "Charge teams fairly while admins understand every charge."
```

For a full evidence trace folder, use:

```bash
python3 scripts/start_idsd_trace.py \
  --topic "billing rollout" \
  --intent "Charge teams fairly while admins understand every charge." \
  --stack nestjs
```

See [IDSD Usage Guide](idsd-usage-guide.md) for how traces appear inside a target project and what to send back for review.

## Relationship To SDD

Traditional document-heavy SDD is no longer the default feature workflow.

CodexMinimal keeps the useful part of SDD as a bounded specification stage inside IDSD. It does not ship separate spec-first planners in the core or profile install path.

If a team needs a large standalone spec, treat it as an external artifact and summarize the parts needed for IDSD: scope, decisions, constraints, acceptance criteria, risks, and verification evidence.

## Relationship To TDD

TDD remains useful as executable evidence for behavior, but it does not replace intent, ADR, bounded specification, risk decisions, or acceptance evidence.

IDSD may select TDD for a phase when tests are the right evidence mechanism.

## Default Flow

`task-router -> idsd-orchestrator -> repo-phase-orchestrator -> tool adapter execution -> verification -> project-indexer`

## Evidence Rule

Do not claim completion until the acceptance evidence matches the intent contract or the remaining gap is stated as a blocker.
