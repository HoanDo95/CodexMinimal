#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
MARKER_FILE=".codexminimal-owner"
FORCE_UNINSTALL="${CODEXMINIMAL_FORCE:-0}"

echo "Removing CodexMinimal..."

if [[ -d "$SKILLS_DIR" ]]; then
  for target_dir in "$SKILLS_DIR"/*; do
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

echo
echo "CodexMinimal removed from:"
echo "  $SKILLS_DIR"
