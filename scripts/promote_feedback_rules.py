#!/usr/bin/env python3
import argparse
import json
from datetime import datetime, timezone
from pathlib import Path

MARKER_START = "<!-- CODEXMINIMAL:PROMOTED_FEEDBACK_RULES START -->"
MARKER_END = "<!-- CODEXMINIMAL:PROMOTED_FEEDBACK_RULES END -->"
DEFAULT_RULE_TARGET = "docs/ai/rule-registry.md"


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=True) + "\n", encoding="utf-8")


def derive_status(count: int, threshold: int) -> str:
    if count >= threshold:
        return "promoted"
    if count == threshold - 1:
        return "watch"
    return "observed"


def default_rule_text(description: str) -> str:
    return f"Do not repeat this issue: {description}"


def normalize_ledger(ledger: dict) -> tuple[dict, list[dict], bool]:
    threshold = ledger.get("promotionThreshold", 3)
    promoted: list[dict] = []
    changed = False

    for issue in ledger.get("issues", []):
        if not isinstance(issue, dict):
            continue
        count = issue.get("count", 0)
        if not isinstance(count, int):
            continue
        status = derive_status(count, threshold)
        if issue.get("status") != status:
            changed = True
        issue["status"] = status
        defaults = {
            "source": "user-feedback",
            "ruleTarget": "",
            "promotedRuleText": "",
            "notes": "",
            "affectedArtifacts": [],
            "affectedPaths": [],
            "firstSeenAt": "",
            "lastSeenAt": "",
        }
        for key, value in defaults.items():
            if key not in issue:
                issue[key] = value
                changed = True
        if status == "promoted":
            if not issue["ruleTarget"]:
                issue["ruleTarget"] = DEFAULT_RULE_TARGET
                changed = True
            if not issue["promotedRuleText"]:
                issue["promotedRuleText"] = default_rule_text(issue.get("description", "").strip())
                changed = True
            if issue["ruleTarget"] == DEFAULT_RULE_TARGET:
                promoted.append(issue)

    promoted.sort(key=lambda item: (item.get("issueKey", ""), item.get("description", "")))
    return ledger, promoted, changed


def render_promoted_rules(promoted: list[dict]) -> str:
    if not promoted:
        return "No promoted rules yet."

    lines = []
    for issue in promoted:
        issue_key = issue.get("issueKey", "").strip() or "unnamed-issue"
        rule_text = issue.get("promotedRuleText", "").strip() or default_rule_text(issue.get("description", "").strip())
        strike_count = issue.get("count", 0)
        lines.append(f"- `{issue_key}`: {rule_text} (promoted after {strike_count} strikes)")
    return "\n".join(lines)


def replace_marker_block(text: str, content: str) -> str:
    if MARKER_START not in text or MARKER_END not in text:
        raise ValueError("rule-registry.md is missing promoted feedback markers")
    start = text.index(MARKER_START) + len(MARKER_START)
    end = text.index(MARKER_END)
    return f"{text[:start]}\n{content}\n{text[end:]}"


def main() -> int:
    parser = argparse.ArgumentParser(description="Promote repeated feedback into durable rule-registry entries.")
    parser.add_argument("--repo-root", required=True, help="Path to repository root")
    parser.add_argument("--ledger-file", help="Override path to feedback-ledger.json")
    parser.add_argument("--rule-registry-file", help="Override path to docs/ai/rule-registry.md")
    parser.add_argument("--check", action="store_true", help="Check whether promotion output is already in sync")
    args = parser.parse_args()

    repo_root = Path(args.repo_root)
    ledger_path = Path(args.ledger_file) if args.ledger_file else repo_root / "docs" / "codexminimal" / "feedback-ledger.json"
    rule_registry_path = (
        Path(args.rule_registry_file) if args.rule_registry_file else repo_root / "docs" / "ai" / "rule-registry.md"
    )

    ledger = load_json(ledger_path)
    normalized_ledger, promoted, ledger_semantic_changed = normalize_ledger(json.loads(json.dumps(ledger)))
    normalized_ledger["updatedAt"] = utc_now() if ledger_semantic_changed else ledger.get("updatedAt", "")
    rendered_block = render_promoted_rules(promoted)
    rule_registry_text = rule_registry_path.read_text(encoding="utf-8")
    updated_rule_registry_text = replace_marker_block(rule_registry_text, rendered_block)

    ledger_changed = normalized_ledger != ledger
    registry_changed = updated_rule_registry_text != rule_registry_text

    if args.check:
        if ledger_changed:
            print("OUT_OF_SYNC feedback-ledger.json")
        if registry_changed:
            print("OUT_OF_SYNC docs/ai/rule-registry.md")
        return 1 if ledger_changed or registry_changed else 0

    if ledger_changed:
        write_json(ledger_path, normalized_ledger)
        print(f"UPDATED {ledger_path}")
    if registry_changed:
        rule_registry_path.write_text(updated_rule_registry_text, encoding="utf-8")
        print(f"UPDATED {rule_registry_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
