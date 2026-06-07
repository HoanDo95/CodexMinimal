# Context Map Schema v2

`docs/ai/context-map.json` should be compact and machine-readable.

Schema:

```json
{
  "version": 2,
  "project": {
    "name": null,
    "packageManager": null,
    "framework": null,
    "stackProfile": "generic",
    "language": "typescript",
    "testCommand": null,
    "lintCommand": null,
    "buildCommand": null
  },
  "modules": {},
  "controllers": {},
  "services": {},
  "repositories": {},
  "entities": {},
  "dtos": {},
  "routes": {},
  "surfaces": {},
  "tests": {},
  "scripts": {},
  "protectedPaths": {
    "critical": [],
    "sensitive": [],
    "integration": []
  }
}
```

Keep the top-level keys stable so downstream prompts can rely on a consistent shape.
