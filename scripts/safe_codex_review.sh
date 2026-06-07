#!/usr/bin/env bash
set -euo pipefail

if [[ "${CODEXMINIMAL_ALLOW_EXTERNAL_REVIEW:-0}" != "1" ]]; then
  cat >&2 <<'MSG'
Refusing to run codex review.

codex review may send repository diffs to an external service.
Set CODEXMINIMAL_ALLOW_EXTERNAL_REVIEW=1 only after the diff is approved for external review.
MSG
  exit 2
fi

MODE_COUNT=0
for arg in "$@"; do
  case "$arg" in
    --uncommitted|--base|--commit)
      MODE_COUNT=$((MODE_COUNT + 1))
      ;;
  esac
done

if [[ "$MODE_COUNT" -ne 1 ]]; then
  echo "Use exactly one review scope: --uncommitted, --base <branch>, or --commit <sha>." >&2
  exit 2
fi

SENSITIVE_PATTERN='(^|/)(\.env|\.env\..*|.*secret.*|.*credential.*|.*private.*|id_rsa|id_ed25519|.*\.pem|.*\.key|.*\.p12|kubeconfig)(/|$)'

changed_files() {
  case " $* " in
    *" --uncommitted "*)
      git diff --name-only
      git diff --cached --name-only
      git ls-files --others --exclude-standard
      ;;
    *" --commit "*)
      local next_is_sha=0
      local sha=""
      for arg in "$@"; do
        if [[ "$next_is_sha" -eq 1 ]]; then
          sha="$arg"
          break
        fi
        [[ "$arg" == "--commit" ]] && next_is_sha=1
      done
      [[ -n "$sha" ]] || return 0
      git diff-tree --no-commit-id --name-only -r "$sha"
      ;;
    *" --base "*)
      local next_is_base=0
      local base=""
      for arg in "$@"; do
        if [[ "$next_is_base" -eq 1 ]]; then
          base="$arg"
          break
        fi
        [[ "$arg" == "--base" ]] && next_is_base=1
      done
      [[ -n "$base" ]] || return 0
      git diff --name-only "$base"...HEAD
      ;;
  esac
}

SENSITIVE_FILES="$(changed_files "$@" | sort -u | grep -E "$SENSITIVE_PATTERN" || true)"
if [[ -n "$SENSITIVE_FILES" ]]; then
  echo "Refusing codex review because sensitive-looking paths are in scope:" >&2
  echo "$SENSITIVE_FILES" >&2
  exit 3
fi

exec codex review "$@"
