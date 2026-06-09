# Context Budget

Set one context budget before broad exploration:

- `low`: index-first plus up to 5 files
- `medium`: index-first plus up to 12 files
- `high`: use only when justified by risk, ambiguity, or multi-module scope

Rules:

- start with the lowest budget that can answer the task
- if the budget is exhausted and confidence is still low, reroute or ask the user
- do not continue scanning by inertia
- do not broad-scan the repository under `low`
- use `low` for existing tracker continuation: read the tracker, current-work, telemetry, and only the files named by the active phase or blocker
