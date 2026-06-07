# Index Format

Each index entry should be short and navigational.

Rules:

- keep indexes concise and navigational
- prefer file paths, module names, route summaries, and cross-links over pasted source
- keep top-level `context-map.json` keys stable
- preserve valid JSON at all times
- if source contradicts an index, trust source and repair the index

Use this structure:

```md
## <Name>

- Path:
- Responsibility:
- Main exports:
- Related tests:
- Related routes:
- Related entities:
- Dependencies:
- Constraints:
```
