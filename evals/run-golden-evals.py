#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def normalize_cases(cases):
    mapping = {}
    for case in cases:
      name = case["name"]
      mapping[name] = case
    return mapping


def grade_case(expected, actual):
    failures = []
    for key, value in expected.items():
        if key not in actual:
            failures.append(f"missing key: {key}")
            continue
        if actual[key] != value:
            failures.append(f"{key}: expected {value!r}, got {actual[key]!r}")
    return failures


def case_expectation(case):
    if "expected" in case:
        return case["expected"]

    derived = {}
    for key, value in case.items():
        if key in {"name", "input", "setup", "notes"}:
            continue
        derived[key] = value
    return derived


def main():
    parser = argparse.ArgumentParser(description="Grade CodexMinimal golden eval results.")
    parser.add_argument("--cases", required=True, help="Path to golden cases JSON file")
    parser.add_argument("--results", required=True, help="Path to actual results JSON file")
    args = parser.parse_args()

    cases = normalize_cases(load_json(Path(args.cases)))
    results = load_json(Path(args.results))

    results_by_name = {}
    for item in results:
        results_by_name[item["name"]] = item["actual"]

    total = 0
    failed = 0

    for name, case in cases.items():
        total += 1
        expected = case_expectation(case)
        actual = results_by_name.get(name)
        if actual is None:
            failed += 1
            print(f"FAIL {name}: missing result")
            continue

        failures = grade_case(expected, actual)
        if failures:
            failed += 1
            print(f"FAIL {name}")
            for failure in failures:
                print(f"  - {failure}")
        else:
            print(f"PASS {name}")

    extra = sorted(set(results_by_name.keys()) - set(cases.keys()))
    for name in extra:
        print(f"WARN extra result with no matching case: {name}")

    print()
    print(f"Summary: {total - failed}/{total} cases passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
