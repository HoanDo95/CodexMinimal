#!/usr/bin/env python3
import argparse
import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path


VALID_STACKS = {"generic", "nestjs", "rust", "nestjs-rust", "other"}


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", value.strip().lower()).strip("-")
    return slug or "idsd-trace"


def now_iso() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def run_scaffold(repo_root: Path, topic: str, intent: str, output: Path) -> None:
    script = Path(__file__).resolve().parent / "scaffold_idsd_intent.py"
    command = [
        "python3",
        str(script),
        "--repo-root",
        str(repo_root),
        "--topic",
        topic,
        "--intent",
        intent,
        "--output",
        str(output),
    ]
    subprocess.run(command, check=True)


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Create a complete IDSD evidence trace folder.")
    parser.add_argument("--repo-root", default=".", help="Repository root where docs/codexminimal/idsd-traces will be created")
    parser.add_argument("--topic", required=True, help="Trace topic, used for directory and titles")
    parser.add_argument("--intent", required=True, help="Core task intent")
    parser.add_argument("--prompt", default="", help="Original user prompt; if omitted, intent is reused")
    parser.add_argument("--stack", default="generic", choices=sorted(VALID_STACKS), help="Target stack/profile")
    parser.add_argument("--task-type", default="feature", help="Task type such as feature, bugfix, refactor, review")
    parser.add_argument("--notes", default="", help="Optional initial notes")
    parser.add_argument("--force", action="store_true", help="Overwrite an existing trace folder")
    args = parser.parse_args()

    repo_root = Path(args.repo_root)
    trace_id = slugify(args.topic)
    trace_dir = repo_root / "docs" / "codexminimal" / "idsd-traces" / trace_id
    if trace_dir.exists() and any(trace_dir.iterdir()) and not args.force:
        raise FileExistsError(f"{trace_dir} already exists; pass --force to overwrite")
    trace_dir.mkdir(parents=True, exist_ok=True)

    created_at = now_iso()
    prompt = args.prompt or args.intent
    intent_path = trace_dir / "intent-package.md"
    run_scaffold(repo_root, args.topic, args.intent, intent_path)

    metadata = {
        "version": 1,
        "traceId": trace_id,
        "topic": args.topic,
        "stack": args.stack,
        "taskType": args.task_type,
        "status": "started",
        "createdAt": created_at,
        "updatedAt": created_at,
        "artifacts": {
            "intentPackage": "intent-package.md",
            "originalPrompt": "original-prompt.md",
            "repoContext": "repo-context.md",
            "verification": "verification.md",
            "results": "results.md"
        }
    }

    write_text(trace_dir / "trace.json", json.dumps(metadata, indent=2) + "\n")
    write_text(
        trace_dir / "README.md",
        f"""# IDSD Trace: {args.topic}

## Status

started

## What To Send Back

Send this whole folder after the task has gone through the target project:

`{trace_dir}`

## Files

- `intent-package.md`: generated IDSD intent package
- `original-prompt.md`: original user prompt or task request
- `repo-context.md`: stack, repo notes, touched modules, protected boundaries
- `verification.md`: commands run and outputs worth preserving
- `results.md`: what worked, what failed, what should improve
- `trace.json`: machine-readable trace metadata
""",
    )
    write_text(trace_dir / "original-prompt.md", f"# Original Prompt\n\n{prompt}\n")
    write_text(
        trace_dir / "repo-context.md",
        f"""# Repo Context

## Stack

{args.stack}

## Task Type

{args.task_type}

## Initial Notes

{args.notes or "No initial notes."}

## Touched Areas

- Fill after execution.

## Protected Or Risk Boundaries

- Fill after execution.
""",
    )
    write_text(
        trace_dir / "verification.md",
        """# Verification

Record commands and important outcomes here.

## Commands

- Fill after execution.

## Evidence Gaps

- Fill after execution.
""",
    )
    write_text(
        trace_dir / "results.md",
        """# Results

## Outcome

- Fill after execution.

## IDSD Helped

- Fill after execution.

## IDSD Failed Or Felt Heavy

- Fill after execution.

## Suggested Improvements

- Fill after execution.
""",
    )

    print(trace_dir)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
