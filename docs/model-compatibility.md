# Model Compatibility

CodexMinimal is prompt-driven, so model quality and prompt compatibility matter.

## Recommended

- `gpt-5.5`: default for planning, coding, review, and orchestration
- `gpt-5.5 high`: high-risk or multi-module work
- `gpt-5.4`: balanced fallback for everyday coding and focused fix-test loops
- `gpt-5.4-mini`: bounded scan and summarization

## Tool-Agnostic Runtime Policy

CodexMinimal core does not require a specific tool runtime, model cache, or hosted provider.
Model availability belongs to the selected tool adapter.

Adapter documentation should record:

- runtime name and version
- supported model identifiers
- output schema behavior
- data-export boundary
- tested date and verification command

Treat older model aliases as adapter-local compatibility notes, not core routing requirements.

## Notes

- prompt quality may drift across model families even when the repo files do not change
- routing and planner outputs should be spot-checked again after model changes
- if you change the recommended model set, rerun the local checks and golden eval cases
- lower-cost models are more suitable when `compact` mode and `low` context budget are enough

## Snapshot Policy

For production or team-wide automation:

- prefer pinned snapshots when available
- do not silently swap the default model without rerunning evals
- record tested models in release notes or changelog
