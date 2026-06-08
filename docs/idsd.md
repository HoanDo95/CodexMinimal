# IDSD

IDSD is CodexMinimal's default workflow for new features and changed behavior.

IDSD means Intent-Driven Spec Development in this repository. The goal is to reduce traditional SDD overhead while preserving evidence, reviewability, and safety.

## Core Idea

The user supplies intent, business rules, constraints, and acceptance criteria. The agent then creates the minimum operating package needed to proceed:

- intent contract
- agent cards
- decision ledger
- acceptance evidence
- optional compatibility gates

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

Traditional SDD is no longer the default feature workflow.

Use SDD only when:

- the user explicitly asks for it
- a team contract requires a traditional spec
- an approved existing plan already depends on a profile SDD planner

When used, SDD is an evidence artifact inside IDSD, not the controlling workflow.

## Relationship To TDD

TDD remains useful as executable evidence for behavior, but it does not replace intent, agent boundaries, risk decisions, or acceptance evidence.

IDSD may select TDD for a phase when tests are the right evidence mechanism.

## Default Flow

`task-router -> idsd-orchestrator -> repo-phase-orchestrator -> external execution -> verification -> project-indexer`

## Evidence Rule

Do not claim completion until the acceptance evidence matches the intent contract or the remaining gap is stated as a blocker.
