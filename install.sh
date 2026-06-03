#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MARKER_FILE=".codexminimal-owner"
FORCE_INSTALL="${CODEXMINIMAL_FORCE:-0}"
COMPANION_SKILLS=(
  brainstorming
  subagent-driven-development
  executing-plans
)

if [[ -x "$ROOT_DIR/check-codexminimal.sh" ]]; then
  echo "Running readiness check..."
  "$ROOT_DIR/check-codexminimal.sh"
fi

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"

mkdir -p "$SKILLS_DIR"

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
  if [[ ! -d "$SKILLS_DIR/$skill" ]]; then
    missing_companions+=("$skill")
  fi
done

echo
echo "CodexMinimal installed successfully."
echo
echo "Location:"
echo "$SKILLS_DIR"
echo
echo "Mode:"
echo "- Core mode is installed by default."
echo "- This includes CodexMinimal core skills and bundled skill-local helpers."
if [[ "${#missing_companions[@]}" -gt 0 ]]; then
  echo
  echo "Recommended companion skills not found:"
  for skill in "${missing_companions[@]}"; do
    echo "- $skill"
  done
  echo
  echo "Full mode requires companion skills such as the ones above."
  echo "Without them, Core mode still works, but external brainstorming/execution steps are not bundled by install.sh."
  echo "Advanced users may also wire in custom stage or execution skills instead."
fi
