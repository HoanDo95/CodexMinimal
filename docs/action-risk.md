# Action Risk

CodexMinimal separates path protection from action risk.

Path protection answers:

- "Is this file or folder sensitive?"

Action risk answers:

- "What is the riskiest thing this task is asking the agent to do?"

## Levels

### Low

- read-only inspection
- summarization
- bounded repository search
- review with no edits

Default decision: `proceed`

### Medium

- normal local code edits
- focused unit tests
- local docs or index updates

Default decision: `proceed` unless another safety gate triggers

### High

- protected-file edits
- network actions
- commits
- database or migration work
- broad refactors
- long-running fix loops

Default decision: `ask-user`

### Critical

- destructive shell actions
- irreversible data changes
- force pushes
- production-impacting deploy or runtime changes

Default decision: `blocked` until explicit approval and scope confirmation exist
