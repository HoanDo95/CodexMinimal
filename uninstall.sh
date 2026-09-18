#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
OPENCODE_HOME="${OPENCODE_HOME:-$HOME/.config/opencode}"
CODEX_SKILLS_DIR="$CODEX_HOME/skills"
OPENCODE_SKILLS_DIR="$OPENCODE_HOME/skills"
MARKER_FILE=".codexminimal-owner"
FORCE_UNINSTALL="${CODEXMINIMAL_FORCE:-0}"
TARGET="${CODEXMINIMAL_TARGET:-codex}"

usage() {
  cat <<'EOF'
Usage: bash uninstall.sh [--target codex|opencode|all]

Targets:
  codex     remove skills from $CODEX_HOME/skills (default)
  opencode  remove skills from $OPENCODE_HOME/skills
  all       remove from both locations

Environment:
  CODEXMINIMAL_TARGET  same as --target (default: codex)
  CODEX_HOME           Codex home (default: $HOME/.codex)
  OPENCODE_HOME        OpenCode config home (default: $HOME/.config/opencode)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --target=*)
      TARGET="${1#--target=}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

case "$TARGET" in
  codex|opencode|all) ;;
  *)
    echo "Invalid target: $TARGET (expected codex, opencode, or all)" >&2
    exit 1
    ;;
esac

remove_from() {
  local skills_dir="$1"
  local target_dir

  if [[ -d "$skills_dir" ]]; then
    for target_dir in "$skills_dir"/*; do
      if [[ ! -e "$target_dir" ]]; then
        continue
      fi

      if [[ -f "$target_dir/$MARKER_FILE" || "$FORCE_UNINSTALL" == "1" ]]; then
        rm -rf "$target_dir"
      else
        echo "Skipping unmanaged skill: $target_dir"
      fi
    done
  fi
}

echo "Removing CodexMinimal (target: $TARGET) ..."

REMOVED_FROM=()
if [[ "$TARGET" == "codex" || "$TARGET" == "all" ]]; then
  remove_from "$CODEX_SKILLS_DIR"
  REMOVED_FROM+=("$CODEX_SKILLS_DIR")
fi
if [[ "$TARGET" == "opencode" || "$TARGET" == "all" ]]; then
  remove_from "$OPENCODE_SKILLS_DIR"
  REMOVED_FROM+=("$OPENCODE_SKILLS_DIR")
fi

echo
echo "CodexMinimal removed from:"
for dir in "${REMOVED_FROM[@]}"; do
  echo "  $dir"
done
