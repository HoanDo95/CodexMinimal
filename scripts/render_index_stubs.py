#!/usr/bin/env python3
import argparse
import shutil
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description="Render missing docs/ai index stubs from project-indexer assets.")
    parser.add_argument("--assets-dir", required=True, help="Path to project-indexer assets")
    parser.add_argument("--docs-ai-dir", required=True, help="Path to docs/ai directory")
    parser.add_argument("--check", action="store_true", help="Only check for missing index stubs")
    args = parser.parse_args()

    assets_dir = Path(args.assets_dir)
    docs_ai_dir = Path(args.docs_ai_dir)
    missing = []

    for asset_path in sorted(assets_dir.glob("*.template.*")):
        target_name = asset_path.name.replace(".template", "")
        target = docs_ai_dir / target_name
        if not target.exists():
            missing.append(target)

    if args.check:
        if missing:
            for path in missing:
                print(f"MISSING {path}")
            return 1
        print("index stubs are complete")
        return 0

    docs_ai_dir.mkdir(parents=True, exist_ok=True)
    for asset_path in sorted(assets_dir.glob("*.template.*")):
        target_name = asset_path.name.replace(".template", "")
        target = docs_ai_dir / target_name
        if not target.exists():
            shutil.copyfile(asset_path, target)
            print(f"CREATED {target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
