#!/usr/bin/env python3
import argparse
import re
from pathlib import Path


BLOCK_IDS = [
    "ROUTING",
    "MODEL_ROUTING",
    "RESPONSE_MODE",
    "CONTEXT_BUDGET",
    "AUTO_COMPACT",
    "SEARCH_POLICY",
    "PROJECT_INDEX",
    "HELPER_POLICY",
    "SKILL_POLICY",
    "NESTJS_SPEC",
    "TESTING_SPEC",
    "PROTECTED_FILES",
    "USER_RULE_MUTATION",
]


def block_pattern(block_id: str) -> re.Pattern[str]:
    return re.compile(
        rf"<!-- CODEXMINIMAL:{block_id} START -->.*?<!-- CODEXMINIMAL:{block_id} END -->",
        re.DOTALL,
    )


def extract_block(template: str, block_id: str) -> str:
    match = block_pattern(block_id).search(template)
    if not match:
        raise ValueError(f"missing block in template: {block_id}")
    return match.group(0)


def sync_blocks(template: str, existing: str) -> str:
    result = existing
    for block_id in BLOCK_IDS:
        block = extract_block(template, block_id)
        pattern = block_pattern(block_id)
        if pattern.search(result):
            result = pattern.sub(block, result, count=1)
        else:
            if not result.endswith("\n"):
                result += "\n"
            result += "\n" + block + "\n"
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Sync CodexMinimal managed AGENTS blocks.")
    parser.add_argument("--template", required=True, help="Path to AGENTS template")
    parser.add_argument("--target", required=True, help="Path to target AGENTS.md")
    parser.add_argument("--check", action="store_true", help="Only check whether target is in sync")
    args = parser.parse_args()

    template_text = Path(args.template).read_text(encoding="utf-8")
    target_path = Path(args.target)
    target_text = target_path.read_text(encoding="utf-8") if target_path.exists() else ""

    synced = sync_blocks(template_text, target_text)

    if args.check:
        if target_text == synced:
            print("AGENTS blocks are in sync")
            return 0
        print("AGENTS blocks are out of sync")
        return 1

    target_path.write_text(synced, encoding="utf-8")
    print(f"Synced AGENTS blocks into {target_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
