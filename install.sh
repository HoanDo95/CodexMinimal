#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MARKER_FILE=".codexminimal-owner"
FORCE_INSTALL="${CODEXMINIMAL_FORCE:-0}"
SUPERPOWERS_CACHE_ROOT="${HOME}/.codex/plugins/cache/openai-curated/superpowers"
COMPANION_SKILLS=(
  brainstorming
  subagent-driven-development
  executing-plans
)

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
READINESS_LOG="$(mktemp)"

cleanup() {
  rm -f "$READINESS_LOG"
}

trap cleanup EXIT

companion_skill_present() {
  local skill="$1"

  if [[ -d "$SKILLS_DIR/$skill" ]]; then
    return 0
  fi

  if find "$SUPERPOWERS_CACHE_ROOT" -path "*/skills/$skill/SKILL.md" -print -quit >/dev/null 2>&1; then
    local match
    match="$(find "$SUPERPOWERS_CACHE_ROOT" -path "*/skills/$skill/SKILL.md" -print -quit 2>/dev/null || true)"
    [[ -n "$match" ]] && return 0
  fi

  return 1
}

if [[ -x "$ROOT_DIR/check-codexminimal.sh" ]]; then
  echo "Checking local readiness..."
  if "$ROOT_DIR/check-codexminimal.sh" >"$READINESS_LOG" 2>&1; then
    echo "Readiness check: pass"
  else
    echo "Readiness check: fail"
    echo
    cat "$READINESS_LOG"
    exit 1
  fi
fi

mkdir -p "$SKILLS_DIR"

echo "Installing core skills into $SKILLS_DIR ..."

for skill_dir in "$ROOT_DIR"/skills/*; do
  skill="$(basename "$skill_dir")"
  target_dir="$SKILLS_DIR/$skill"

  if [[ -e "$target_dir" && ! -f "$target_dir/$MARKER_FILE" && "$FORCE_INSTALL" != "1" ]]; then
    echo "Refusing to overwrite existing unmanaged skill: $target_dir"
    echo "Set CODEXMINIMAL_FORCE=1 to overwrite intentionally."
    exit 1
  fi
done

for skill_dir in "$ROOT_DIR"/skills/*; do
  skill="$(basename "$skill_dir")"
  target_dir="$SKILLS_DIR/$skill"

  rm -rf "$target_dir"
  cp -R "$skill_dir" "$SKILLS_DIR/"
  printf 'CodexMinimal\n' > "$target_dir/$MARKER_FILE"
done

missing_companions=()
for skill in "${COMPANION_SKILLS[@]}"; do
  if ! companion_skill_present "$skill"; then
    missing_companions+=("$skill")
  fi
done

echo
echo "CodexMinimal installed successfully."
echo
echo "Location: $SKILLS_DIR"
echo "Mode: Core"
echo "Includes: CodexMinimal core skills and bundled skill-local helpers"
if [[ "${#missing_companions[@]}" -gt 0 ]]; then
  echo
  echo "Full mode: unavailable"
  echo "Missing recommended companion skills:"
  for skill in "${missing_companions[@]}"; do
    echo "- $skill"
  done
else
  echo "Full mode: available"
fi
