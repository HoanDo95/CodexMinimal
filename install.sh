#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MARKER_FILE=".codexminimal-owner"
FORCE_INSTALL="${CODEXMINIMAL_FORCE:-0}"
INSTALL_PROFILES_RAW="${CODEXMINIMAL_INSTALL_PROFILES:-}"
CORE_SKILLS=(
  task-router
  idsd-orchestrator
  project-init
  project-indexer
  repo-phase-orchestrator
)
NESTJS_PROFILE_SKILLS=(
  nestjs-tdd-builder
  nestjs-bug-fixer
  nestjs-code-reviewer
  nestjs-refactor-guardian
)
RUST_PROFILE_SKILLS=(
  rust-tdd-builder
  rust-bug-fixer
  rust-code-reviewer
  rust-refactor-guardian
)

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
READINESS_LOG="$(mktemp)"

cleanup() {
  rm -f "$READINESS_LOG"
}

trap cleanup EXIT

profile_requested() {
  local profile="$1"
  case ",$INSTALL_PROFILES_RAW," in
    *,all,*|*,"$profile",*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

if [[ -x "$ROOT_DIR/check-codexminimal.sh" && "${CODEXMINIMAL_SKIP_READINESS:-0}" != "1" ]]; then
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

INSTALL_SKILLS=("${CORE_SKILLS[@]}")
ACTIVE_PROFILES=()
if profile_requested "nestjs"; then
  INSTALL_SKILLS+=("${NESTJS_PROFILE_SKILLS[@]}")
  ACTIVE_PROFILES+=("nestjs")
fi
if profile_requested "rust"; then
  INSTALL_SKILLS+=("${RUST_PROFILE_SKILLS[@]}")
  ACTIVE_PROFILES+=("rust")
fi

for skill in "${INSTALL_SKILLS[@]}"; do
  skill_dir="$ROOT_DIR/skills/$skill"

  if [[ ! -d "$skill_dir" ]]; then
    echo "Missing bundled skill for requested profile: $skill"
    echo "Complete the profile implementation before installing it."
    exit 1
  fi
done

for skill in "${INSTALL_SKILLS[@]}"; do
  target_dir="$SKILLS_DIR/$skill"

  if [[ -e "$target_dir" && ! -f "$target_dir/$MARKER_FILE" && "$FORCE_INSTALL" != "1" ]]; then
    echo "Refusing to overwrite existing unmanaged skill: $target_dir"
    echo "Set CODEXMINIMAL_FORCE=1 to overwrite intentionally."
    exit 1
  fi
done

for skill in "${INSTALL_SKILLS[@]}"; do
  skill_dir="$ROOT_DIR/skills/$skill"
  target_dir="$SKILLS_DIR/$skill"

  rm -rf "$target_dir"
  cp -R "$skill_dir" "$SKILLS_DIR/"
  printf 'CodexMinimal\n' > "$target_dir/$MARKER_FILE"
done

echo
echo "CodexMinimal installed successfully."
echo
echo "Location: $SKILLS_DIR"
if [[ "${#ACTIVE_PROFILES[@]}" -gt 0 ]]; then
  echo "Mode: Core + profiles"
else
  echo "Mode: Core"
fi
echo "Includes: CodexMinimal core skills and bundled skill-local helpers"
if [[ "${#ACTIVE_PROFILES[@]}" -gt 0 ]]; then
  echo "Profiles: ${ACTIVE_PROFILES[*]}"
else
  echo "Profiles: none"
fi
echo "Plugin manifest: $ROOT_DIR/.codex-plugin/plugin.json"
