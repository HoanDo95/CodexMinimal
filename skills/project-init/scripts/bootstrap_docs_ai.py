#!/usr/bin/env python3
import argparse
import shutil
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description="Create missing docs/ai files from templates.")
    parser.add_argument("--templates-dir", required=True, help="Path to template docs-ai directory")
    parser.add_argument("--repo-root", required=True, help="Path to repository root")
    parser.add_argument("--check", action="store_true", help="Only check for missing docs/ai files")
    args = parser.parse_args()

    templates_dir = Path(args.templates_dir)
    repo_root = Path(args.repo_root)
    docs_ai_dir = repo_root / "docs" / "ai"
    missing = []

    for template_path in sorted(templates_dir.iterdir()):
        target = docs_ai_dir / template_path.name
        if not target.exists():
            missing.append(target)

    if args.check:
        if missing:
            for path in missing:
                print(f"MISSING {path}")
            return 1
        print("docs/ai is complete")
        return 0

    docs_ai_dir.mkdir(parents=True, exist_ok=True)
    for template_path in sorted(templates_dir.iterdir()):
        target = docs_ai_dir / template_path.name
        if not target.exists():
            shutil.copyfile(template_path, target)
            print(f"CREATED {target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
