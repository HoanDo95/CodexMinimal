#!/usr/bin/env python3
import argparse
import json
from datetime import datetime, timezone
from pathlib import Path


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=True) + "\n", encoding="utf-8")


def parse_csv(value: str) -> list[str]:
    if not value.strip():
        return []
    return [item.strip() for item in value.split(",") if item.strip()]


def derive_status(count: int, threshold: int) -> str:
    if count >= threshold:
        return "promoted"
    if count == threshold - 1:
        return "watch"
    return "observed"


def default_rule_text(description: str) -> str:
    return f"Do not repeat this issue: {description}"


def main() -> int:
    parser = argparse.ArgumentParser(description="Record explicit user feedback into the CodexMinimal feedback ledger.")
    parser.add_argument("--repo-root", required=True, help="Path to repository root")
    parser.add_argument("--issue-key", required=True, help="Stable issue key to increment or create")
    parser.add_argument("--description", help="Description for a new issue or replacement description")
    parser.add_argument("--strikes", type=int, default=1, help="How many user-confirmed strikes to add")
    parser.add_argument("--notes", default="", help="Optional note about the feedback event")
    parser.add_argument("--rule-target", default="", help="Optional durable rule target, e.g. docs/ai/rule-registry.md")
    parser.add_argument("--rule-text", default="", help="Optional promoted rule text")
    parser.add_argument("--affected-paths", default="", help="Comma-separated affected paths")
    parser.add_argument("--affected-artifacts", default="", help="Comma-separated affected artifacts")
    parser.add_argument("--source", default="explicit-user-feedback", help="Feedback source label")
    args = parser.parse_args()

    if args.strikes < 1:
        raise SystemExit("--strikes must be >= 1")

    ledger_path = Path(args.repo_root) / "docs" / "codexminimal" / "feedback-ledger.json"
    ledger = load_json(ledger_path)
    now = utc_now()
    threshold = int(ledger.get("promotionThreshold", 3))
    issues = ledger.setdefault("issues", [])

    existing = None
    for issue in issues:
        if isinstance(issue, dict) and issue.get("issueKey") == args.issue_key:
            existing = issue
            break

    if existing is None:
        existing = {
            "issueKey": args.issue_key,
            "description": args.description or "",
            "count": 0,
            "status": "observed",
            "firstSeenAt": now,
            "lastSeenAt": now,
            "source": args.source,
            "ruleTarget": args.rule_target,
            "promotedRuleText": args.rule_text,
            "affectedArtifacts": parse_csv(args.affected_artifacts),
            "affectedPaths": parse_csv(args.affected_paths),
            "notes": args.notes,
        }
        issues.append(existing)
    else:
        if args.description:
            existing["description"] = args.description
        if args.rule_target:
            existing["ruleTarget"] = args.rule_target
        if args.rule_text:
            existing["promotedRuleText"] = args.rule_text
        if args.affected_artifacts:
            existing["affectedArtifacts"] = parse_csv(args.affected_artifacts)
        if args.affected_paths:
            existing["affectedPaths"] = parse_csv(args.affected_paths)
        if args.notes:
            existing["notes"] = args.notes
        existing["source"] = args.source or existing.get("source", "explicit-user-feedback")

    existing["count"] = int(existing.get("count", 0)) + args.strikes
    existing["status"] = derive_status(existing["count"], threshold)
    if existing["status"] == "promoted":
        if not existing.get("ruleTarget"):
            existing["ruleTarget"] = "docs/ai/rule-registry.md"
        if not existing.get("promotedRuleText"):
            existing["promotedRuleText"] = default_rule_text(existing.get("description", "").strip())
    existing["lastSeenAt"] = now
    ledger["updatedAt"] = now

    write_json(ledger_path, ledger)
    print(f"UPDATED {ledger_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
