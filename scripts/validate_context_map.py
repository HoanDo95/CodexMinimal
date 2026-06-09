#!/usr/bin/env python3
import argparse
import json
from pathlib import Path


REQUIRED_TOP_LEVEL_KEYS = {
    "version",
    "project",
    "entrypoints",
    "modules",
    "handlers",
    "controllers",
    "services",
    "dataAccess",
    "repositories",
    "entities",
    "dtos",
    "contracts",
    "routes",
    "jobs",
    "integrations",
    "configuration",
    "surfaces",
    "tests",
    "scripts",
    "verification",
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

    project = data.get("project", {})
    if not isinstance(project, dict):
        print("INVALID_PROJECT project must be an object")
        return 1
    stack_profile = project.get("stackProfile")
    if not isinstance(stack_profile, str):
        print("INVALID_PROJECT stackProfile must be a string")
        return 1
    detected_stack = project.get("detectedStack")
    if not isinstance(detected_stack, list):
        print("INVALID_PROJECT detectedStack must be a list")
        return 1

    verification = data.get("verification", {})
    if not isinstance(verification, dict):
        print("INVALID_VERIFICATION verification must be an object")
        return 1
    commands = verification.get("commands")
    if not isinstance(commands, list):
        print("INVALID_VERIFICATION commands must be a list")
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
