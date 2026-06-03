#!/usr/bin/env python3
import argparse
import shutil
from pathlib import Path

DOCS_AI_TEMPLATE_MAP = {
    "project-index.md": ["project-index.md", "project-index.template.md"],
    "module-index.md": ["module-index.md", "module-index.template.md"],
    "route-index.md": ["route-index.md", "route-index.template.md"],
    "entity-index.md": ["entity-index.md", "entity-index.template.md"],
    "test-index.md": ["test-index.md", "test-index.template.md"],
    "dependency-index.md": ["dependency-index.md", "dependency-index.template.md"],
    "protected-files.md": ["protected-files.md", "protected-files.template.md"],
    "rule-registry.md": ["rule-registry.md", "rule-registry.template.md"],
    "stack-profile.md": ["stack-profile.md", "stack-profile.template.md"],
    "architecture-notes.md": ["architecture-notes.md", "architecture-notes.template.md"],
    "refactor-log.md": ["refactor-log.md", "refactor-log.template.md"],
    "context-map.json": ["context-map.json", "context-map.template.json"],
}


def default_templates_dir() -> Path:
    script_path = Path(__file__).resolve()
    candidates = [
        script_path.parent.parent / "assets",
        script_path.parent.parent / "skills" / "project-init" / "assets",
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate
    raise FileNotFoundError("could not locate project-init assets directory")


def resolve_template(templates_dir: Path, candidates: list[str]) -> Path | None:
    for name in candidates:
        path = templates_dir / name
        if path.exists():
            return path
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description="Create missing docs/ai files from templates.")
    parser.add_argument("--templates-dir", help="Path to template docs-ai directory or project-init assets directory")
    parser.add_argument("--repo-root", required=True, help="Path to repository root")
    parser.add_argument("--check", action="store_true", help="Only check for missing docs/ai files")
    args = parser.parse_args()

    templates_dir = Path(args.templates_dir) if args.templates_dir else default_templates_dir()
    repo_root = Path(args.repo_root)
    docs_ai_dir = repo_root / "docs" / "ai"
    missing = []

    resolved_templates: list[tuple[Path, Path]] = []
    for target_name, candidates in DOCS_AI_TEMPLATE_MAP.items():
        template_path = resolve_template(templates_dir, candidates)
        if template_path is None:
            raise FileNotFoundError(f"missing template for {target_name} in {templates_dir}")
        target = docs_ai_dir / target_name
        resolved_templates.append((template_path, target))
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
    for template_path, target in resolved_templates:
        if not target.exists():
            shutil.copyfile(template_path, target)
            print(f"CREATED {target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
