#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MARKER_FILE=".codexminimal-owner"
FORCE_INSTALL="${CODEXMINIMAL_FORCE:-0}"
INSTALL_PROFILES_RAW="${CODEXMINIMAL_INSTALL_PROFILES:-}"
TARGET="${CODEXMINIMAL_TARGET:-codex}"

usage() {
  cat <<'EOF'
Usage: bash install.sh [--target codex|opencode|all]

Targets:
  codex     install skills into $CODEX_HOME/skills (default)
  opencode  install skills into $OPENCODE_HOME/skills
  all       install into both locations

Environment:
  CODEXMINIMAL_TARGET            same as --target (default: codex)
  CODEX_HOME                     Codex home (default: $HOME/.codex)
  OPENCODE_HOME                  OpenCode config home (default: $HOME/.config/opencode)
  CODEXMINIMAL_INSTALL_PROFILES  comma list: nestjs, rust, all
  CODEXMINIMAL_FORCE=1           overwrite unmanaged skills
  CODEXMINIMAL_SKIP_READINESS=1  skip readiness check
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
OPENCODE_HOME="${OPENCODE_HOME:-$HOME/.config/opencode}"
CODEX_SKILLS_DIR="$CODEX_HOME/skills"
OPENCODE_SKILLS_DIR="$OPENCODE_HOME/skills"
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

echo "Installing skills (target: $TARGET) ..."

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

install_into() {
  local dest_skills_dir="$1"
  local skill skill_dir target_dir src target

  mkdir -p "$dest_skills_dir"

  echo "Installing skills into $dest_skills_dir ..."

  for skill in "${INSTALL_SKILLS[@]}"; do
    target_dir="$dest_skills_dir/$skill"

    if [[ -e "$target_dir" && ! -f "$target_dir/$MARKER_FILE" && "$FORCE_INSTALL" != "1" ]]; then
      echo "Refusing to overwrite existing unmanaged skill: $target_dir"
      echo "Set CODEXMINIMAL_FORCE=1 to overwrite intentionally."
      exit 1
    fi
  done

  for skill in "${INSTALL_SKILLS[@]}"; do
    skill_dir="$ROOT_DIR/skills/$skill"
    target_dir="$dest_skills_dir/$skill"

    rm -rf "$target_dir"
    cp -R "$skill_dir" "$dest_skills_dir/"
    printf 'CodexMinimal\n' > "$target_dir/$MARKER_FILE"
  done

  echo "Materializing shared skill assets from single sources into $dest_skills_dir ..."
  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      ""|"#"*) continue ;;
    esac
    src="$ROOT_DIR/${line%%|*}"
    target="$dest_skills_dir/${line##*|}"
    mkdir -p "$(dirname "$target")"
    cp "$src" "$target"
  done < "$ROOT_DIR/skill-assets.manifest"
}

TARGET_DIRS=()
if [[ "$TARGET" == "codex" || "$TARGET" == "all" ]]; then
  TARGET_DIRS+=("$CODEX_SKILLS_DIR")
fi
if [[ "$TARGET" == "opencode" || "$TARGET" == "all" ]]; then
  TARGET_DIRS+=("$OPENCODE_SKILLS_DIR")
fi

for dir in "${TARGET_DIRS[@]}"; do
  install_into "$dir"
done

echo
echo "CodexMinimal installed successfully."
echo
echo "Targets: $TARGET"
for dir in "${TARGET_DIRS[@]}"; do
  echo "Location: $dir"
done
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
