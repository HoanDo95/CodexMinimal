# Search Strategy

Prefer the narrowest search that can answer the question.

Order:

1. `docs/ai/context-map.json`
2. `docs/ai/project-index.md`
3. the most relevant `docs/ai/*-index.md`
4. exact files named in the indexes
5. sibling files in the same feature
6. parent or shared folders
7. whole repository only as a last resort

During indexing:

- prefer file lists over broad content scans when possible
- record cross-links so future searches stay narrow
- update the index when source and index disagree
