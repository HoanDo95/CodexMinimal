#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def case_expectation(case):
    if "expected" in case:
        return case["expected"]

    return {
        key: value
        for key, value in case.items()
        if key not in {"name", "input", "setup", "notes"}
    }


def grade_case(expected, actual):
    failures = []
    for key, value in expected.items():
        if key not in actual:
            failures.append(f"missing key: {key}")
        elif actual[key] != value:
            failures.append(f"{key}: expected {value!r}, got {actual[key]!r}")
    return failures


def build_prompt(case):
    return "\n".join(
        [
            "Use the CodexMinimal task-router skill for this request.",
            "Return only the structured JSON object required by the provided output schema.",
            "",
            f"User request: {case['input']}",
        ]
    )


def run_case(args, case):
    with tempfile.TemporaryDirectory(prefix="codexminimal-exec-eval-") as tmp:
        output_path = Path(tmp) / "last-message.json"
        command = [
            args.codex_bin,
            "exec",
            "--json",
            "--ephemeral",
            "--cd",
            str(args.repo_root),
            "--sandbox",
            "read-only",
            "--output-schema",
            str(args.schema),
            "--output-last-message",
            str(output_path),
        ]
        if args.model:
            command.extend(["--model", args.model])
        command.append(build_prompt(case))

        completed = subprocess.run(
            command,
            cwd=args.repo_root,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )

        if completed.returncode != 0:
            return {
                "name": case["name"],
                "actual": {},
                "error": {
                    "kind": "codex-exec-failed",
                    "returncode": completed.returncode,
                    "stderr": completed.stderr[-4000:],
                },
            }

        try:
            actual = json.loads(output_path.read_text(encoding="utf-8"))
        except Exception as exc:
            return {
                "name": case["name"],
                "actual": {},
                "error": {
                    "kind": "invalid-final-json",
                    "message": str(exc),
                    "stdout": completed.stdout[-4000:],
                    "stderr": completed.stderr[-4000:],
                },
            }

        return {"name": case["name"], "actual": actual}


def main():
    parser = argparse.ArgumentParser(
        description="Run opt-in Codex exec evals against CodexMinimal golden cases."
    )
    parser.add_argument("--cases", required=True, help="Golden cases JSON file")
    parser.add_argument("--schema", required=True, help="Output JSON schema file")
    parser.add_argument("--output", required=True, help="Where to write result JSON")
    parser.add_argument("--repo-root", default=".", help="Repository root for codex exec")
    parser.add_argument("--codex-bin", default="codex", help="Codex CLI binary")
    parser.add_argument("--model", default="", help="Optional Codex model slug")
    parser.add_argument("--limit", type=int, default=0, help="Run at most N cases")
    parser.add_argument(
        "--allow-external",
        action="store_true",
        help="Allow calling Codex exec. Otherwise CODEXMINIMAL_RUN_LLM_EVALS=1 is required.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Validate inputs and print selected cases without calling Codex.",
    )
    args = parser.parse_args()

    args.repo_root = Path(args.repo_root).resolve()
    args.schema = Path(args.schema).resolve()
    cases = load_json(Path(args.cases))
    if args.limit > 0:
        cases = cases[: args.limit]

    if args.dry_run:
        for case in cases:
            print(f"DRY-RUN {case['name']}")
        return 0

    if not args.allow_external and os.environ.get("CODEXMINIMAL_RUN_LLM_EVALS") != "1":
        print(
            "Refusing to call Codex exec. Set CODEXMINIMAL_RUN_LLM_EVALS=1 "
            "or pass --allow-external.",
            file=sys.stderr,
        )
        return 2

    results = []
    failed = 0
    for case in cases:
        result = run_case(args, case)
        expected = case_expectation(case)
        failures = grade_case(expected, result.get("actual", {}))
        if "error" in result:
            failures.append(result["error"]["kind"])
        if failures:
            failed += 1
            result["failures"] = failures
            print(f"FAIL {case['name']}")
            for failure in failures:
                print(f"  - {failure}")
        else:
            print(f"PASS {case['name']}")
        results.append(result)

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(results, indent=2) + "\n", encoding="utf-8")

    print()
    print(f"Summary: {len(cases) - failed}/{len(cases)} cases passed")
    print(f"Results: {output_path}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
