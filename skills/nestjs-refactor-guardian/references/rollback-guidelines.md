# Rollback Guidelines

A refactor should have a rollback boundary.

Good rollback boundary:
- one module
- one feature folder
- one import direction change
- one rename set
- one phase

Avoid mixing:
- behavior changes
- schema changes
- deployment changes
- broad formatting
- unrelated cleanup
