# Context Budget

Context budget limits how much the agent should read before answering or rerouting.

## Levels

### Low

- read `docs/ai` indexes first
- then inspect at most 5 files
- do not broad-scan the repository

Use for:

- simple repo questions
- review of a narrow change
- speed-priority tasks

### Medium

- read indexes first
- then inspect at most 12 files

Use for:

- normal implementation or bug-fix work
- moderately ambiguous tasks

### High

- use only when justified by risk, ambiguity, or multi-module scope

Use for:

- large refactor
- unclear failing behavior across modules
- architecture or deploy-sensitive work

## Budget Rule

If budget is exhausted and confidence is still low:

1. reroute
2. ask the user
3. or explicitly justify raising the budget
