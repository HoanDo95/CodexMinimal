# Compact Mode

Compact mode exists for users who care more about speed and focus than explanation depth.

## Goal

Make the answer:

- shorter
- more direct
- less repetitive
- cheaper in context and output tokens

## When To Use

- operational tasks
- repeated workflows
- bounded code or repo questions
- when the user clearly prioritizes speed

## Rules

- answer with the shortest useful form
- avoid long recaps
- avoid optional side-notes unless they change the decision
- use lists only when the content is inherently list-shaped

## Current Scope

Compact mode currently works as a routing and response policy, with an instruction-level auto-compact policy for long sessions.

That means:

- the router can recommend `compact`
- downstream skills can stay shorter and more direct
- the workflow can pair compact answers with a lower context budget
- long sessions can be compacted by workflow triggers when only the active working set needs to remain

This still does not mean there is a separate centralized compression engine for every conversation.
The current approach is policy-driven compaction at the workflow layer.

## Auto-Compact Guidance

Prefer budget-based triggers over an arbitrary fixed percentage.

Recommended triggers:

- repeated long turns with no new technical surface
- context budget exhaustion under `low` or `medium`
- broad exploration completed and only execution context needs to remain
- summary size is clearly smaller than the active working set

A fixed threshold such as `60%` can be used as a coarse heuristic, but it should not be the only trigger.
