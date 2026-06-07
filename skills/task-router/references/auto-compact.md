# Auto-Compact

For long sessions, compact by trigger and workflow state rather than by a fixed threshold alone.

Compact when:

- `low` or `medium` budget is close to exhaustion
- exploration is done and only execution context needs to remain
- repeated long turns do not open new technical surface

Rules:

- keep active task, constraints, touched files, unresolved risks, and next action
- drop stale branches and repeated recaps
- preserve unresolved user decisions and protected-file constraints
- a heuristic such as `60%` context usage may help, but it should not be the sole trigger
