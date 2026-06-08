#!/usr/bin/env python3
import argparse
import re
from datetime import date
from pathlib import Path


VALID_AGENT_CARDS = {"planner", "architect", "implementer", "verifier", "reviewer"}


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", value.strip().lower()).strip("-")
    return slug or "idsd-intent"


def bullet_list(items: list[str], fallback: str) -> str:
    values = items or [fallback]
    return "\n".join(f"- {item}" for item in values)


def render(args) -> str:
    today = date.today().isoformat()
    cards = args.agent_card or ["planner", "architect", "verifier"]
    invalid = sorted(set(cards) - VALID_AGENT_CARDS)
    if invalid:
        raise ValueError(f"invalid agent card(s): {', '.join(invalid)}")

    return f"""# IDSD Intent Package: {args.topic}

date: {today}
status: draft

## Intent Contract

{args.intent}

## Business Rules

{bullet_list(args.business_rule, "No business rules captured yet.")}

## Non-Goals

{bullet_list(args.non_goal, "No non-goals captured yet.")}

## Constraints

{bullet_list(args.constraint, "No constraints captured yet.")}

## Acceptance Criteria

{bullet_list(args.acceptance_criterion, "No acceptance criteria captured yet.")}

## Selected Agent Cards

{bullet_list(cards, "planner")}

## Decision Ledger

| Decision | Options Considered | Selected Path | Reason | Risk | Evidence |
| --- | --- | --- | --- | --- | --- |
| Start with IDSD intent package | SDD-first, TDD-first, IDSD-first | IDSD-first | Intent and evidence should control the workflow before implementation. | Evidence depth may need calibration. | This package |

## Acceptance Evidence

{bullet_list(args.evidence, "Define verification commands or review evidence before execution.")}

## Optional Compatibility Gates

{bullet_list(args.compatibility_gate, "None")}

## Open Questions Or Assumptions

{bullet_list(args.assumption, "No open questions captured yet.")}
"""


def main() -> int:
    parser = argparse.ArgumentParser(description="Scaffold a CodexMinimal IDSD intent package.")
    parser.add_argument("--repo-root", default=".", help="Repository root where docs/codexminimal/idsd will be created")
    parser.add_argument("--topic", required=True, help="Short topic used for the output filename and title")
    parser.add_argument("--intent", required=True, help="Core user or product intent")
    parser.add_argument("--business-rule", action="append", default=[], help="Business rule to include; may be repeated")
    parser.add_argument("--non-goal", action="append", default=[], help="Non-goal to include; may be repeated")
    parser.add_argument("--constraint", action="append", default=[], help="Constraint to include; may be repeated")
    parser.add_argument("--acceptance-criterion", action="append", default=[], help="Acceptance criterion; may be repeated")
    parser.add_argument("--agent-card", action="append", choices=sorted(VALID_AGENT_CARDS), help="Agent card to select; may be repeated")
    parser.add_argument("--evidence", action="append", default=[], help="Acceptance evidence item; may be repeated")
    parser.add_argument("--compatibility-gate", action="append", default=[], help="Optional legacy or evidence gate; may be repeated")
    parser.add_argument("--assumption", action="append", default=[], help="Open question or assumption; may be repeated")
    parser.add_argument("--output", help="Explicit output path; defaults to docs/codexminimal/idsd/<topic>-intent.md")
    parser.add_argument("--force", action="store_true", help="Overwrite an existing output file")
    args = parser.parse_args()

    repo_root = Path(args.repo_root)
    output = Path(args.output) if args.output else repo_root / "docs" / "codexminimal" / "idsd" / f"{slugify(args.topic)}-intent.md"
    if output.exists() and not args.force:
        raise FileExistsError(f"{output} already exists; pass --force to overwrite")

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(render(args), encoding="utf-8")
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
