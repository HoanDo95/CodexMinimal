#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
MARKER_FILE=".codexminimal-owner"
FORCE_UNINSTALL="${CODEXMINIMAL_FORCE:-0}"

SKILLS=(
  task-router
  project-init
  project-indexer
  nestjs-sdd-planner
  nestjs-tdd-builder
  nestjs-bug-fixer
  nestjs-code-reviewer
  nestjs-refactor-guardian
  repo-phase-orchestrator
)

echo "Removing CodexMinimal..."

for skill in "${SKILLS[@]}"; do
  target_dir="$SKILLS_DIR/$skill"

  if [[ ! -e "$target_dir" ]]; then
    continue
  fi

  if [[ -f "$target_dir/$MARKER_FILE" || "$FORCE_UNINSTALL" == "1" ]]; then
    rm -rf "$target_dir"
  else
    echo "Skipping unmanaged skill: $target_dir"
  fi
done

echo
echo "CodexMinimal removed from:"
echo "  $SKILLS_DIR"
