#!/usr/bin/env python3
import argparse
import json
from pathlib import Path


REQUIRED_TOP_LEVEL_KEYS = {
    "version",
    "project",
    "modules",
    "controllers",
    "services",
    "repositories",
    "entities",
    "dtos",
    "routes",
    "tests",
    "scripts",
    "protectedPaths",
}

REQUIRED_PROTECTED_KEYS = {"critical", "sensitive", "integration"}


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate CodexMinimal context-map structure.")
    parser.add_argument("--file", required=True, help="Path to context-map.json")
    args = parser.parse_args()

    data = json.loads(Path(args.file).read_text(encoding="utf-8"))

    missing = sorted(REQUIRED_TOP_LEVEL_KEYS - set(data.keys()))
    if missing:
        for key in missing:
            print(f"MISSING_TOP_LEVEL_KEY {key}")
        return 1

    if data.get("version") != 2:
        print(f"INVALID_VERSION {data.get('version')!r}")
        return 1

    protected = data.get("protectedPaths", {})
    missing_protected = sorted(REQUIRED_PROTECTED_KEYS - set(protected.keys()))
    if missing_protected:
        for key in missing_protected:
            print(f"MISSING_PROTECTED_KEY {key}")
        return 1

    print("context-map structure is valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
