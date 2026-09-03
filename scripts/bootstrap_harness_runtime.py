#!/usr/bin/env python3
import argparse
import shutil
from pathlib import Path

RUNTIME_TEMPLATE_MAP = {
    "current-work.json": ["current-work.json", "current-work.template.json"],
    "artifact-registry.json": ["artifact-registry.json", "artifact-registry.template.json"],
    "telemetry.json": ["telemetry.json", "telemetry.template.json"],
}


def default_templates_dir() -> Path:
    script_path = Path(__file__).resolve()
    candidates = [
        script_path.parent.parent / "assets",
        script_path.parent.parent / "skills" / "project-init" / "assets",
        script_path.parent.parent / "templates" / "docs-codexminimal",
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate
    raise FileNotFoundError("could not locate runtime template directory")


def resolve_template(templates_dir: Path, candidates: list[str]) -> Path | None:
    for name in candidates:
        path = templates_dir / name
        if path.exists():
            return path
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description="Create missing docs/codexminimal runtime files from templates.")
    parser.add_argument("--templates-dir", help="Path to runtime template directory or project-init assets directory")
    parser.add_argument("--repo-root", required=True, help="Path to repository root")
    parser.add_argument("--check", action="store_true", help="Only check for missing runtime files")
    args = parser.parse_args()

    templates_dir = Path(args.templates_dir) if args.templates_dir else default_templates_dir()
    repo_root = Path(args.repo_root)
    runtime_dir = repo_root / "docs" / "codexminimal"
    missing = []

    resolved_templates: list[tuple[Path, Path]] = []
    for target_name, candidates in RUNTIME_TEMPLATE_MAP.items():
        template_path = resolve_template(templates_dir, candidates)
        if template_path is None:
            raise FileNotFoundError(f"missing runtime template for {target_name} in {templates_dir}")
        target = runtime_dir / target_name
        resolved_templates.append((template_path, target))
        if not target.exists():
            missing.append(target)

    if args.check:
        if missing:
            for path in missing:
                print(f"MISSING {path}")
            return 1
        print("docs/codexminimal runtime is complete")
        return 0

    runtime_dir.mkdir(parents=True, exist_ok=True)
    for template_path, target in resolved_templates:
        if not target.exists():
            shutil.copyfile(template_path, target)
            print(f"CREATED {target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
