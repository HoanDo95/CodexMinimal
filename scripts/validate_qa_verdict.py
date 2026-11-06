#!/usr/bin/env python3
"""Validate the post-execution QA verdict block in a phase tracker.

The tracker must contain a QA verdict section produced from ticket AC plus
the PR diff. Structure-only mode checks the block exists with the required
fields. ``--require-pass`` additionally gates phase completion: only a PASS
verdict is accepted, FAIL/BLOCKED must be fixed and re-verified.
"""

import argparse
import re
import sys
from pathlib import Path


def check(pattern: str, text: str, message: str, errors: list[str]) -> None:
    if not re.search(pattern, text, re.IGNORECASE | re.MULTILINE):
        errors.append(message)


def validate_tracker(text: str, errors: list[str]) -> str:
    check(
        r"^#{1,4}\s*QA verdict",
        text,
        "tracker is missing a 'QA verdict' section",
        errors,
    )
    match = re.search(
        r"verdict\s*[:\-]\s*(PASS|FAIL|BLOCKED)",
        text,
        re.IGNORECASE,
    )
    if not match:
        errors.append("tracker QA verdict must state PASS, FAIL, or BLOCKED")
        return ""
    check(
        r"a\.?c[\s\-]*coverage",
        text,
        "tracker QA verdict is missing AC-coverage (ticket AC vs code)",
        errors,
    )
    check(
        r"affected flows?",
        text,
        "tracker QA verdict is missing affected flows",
        errors,
    )
    check(
        r"(error[\s\-]*prone|edge cases?)",
        text,
        "tracker QA verdict is missing error-prone edge cases",
        errors,
    )
    check(
        r"(test|evidence) gaps?",
        text,
        "tracker QA verdict is missing test gaps",
        errors,
    )
    return match.group(1).upper()


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate tracker QA verdict.")
    parser.add_argument("--tracker", required=True, help="Path to tracker markdown file")
    parser.add_argument(
        "--require-pass",
        action="store_true",
        help="Exit non-zero unless the verdict is PASS",
    )
    args = parser.parse_args()

    path = Path(args.tracker)
    if not path.is_file():
        print(f"FAIL: tracker file not found: {path}")
        return 1
    text = path.read_text(encoding="utf-8")
    if not text.strip():
        print(f"FAIL: tracker file is empty: {path}")
        return 1

    errors: list[str] = []
    verdict = validate_tracker(text, errors)
    for error in errors:
        print(f"FAIL: {error}")
    if errors:
        return 1

    if args.require_pass and verdict != "PASS":
        print(f"FAIL: QA verdict is {verdict}; fix and re-verify, do not advance")
        return 1

    print(f"QA verdict is valid: {verdict or 'stated'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
