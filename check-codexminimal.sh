#!/usr/bin/env bash
set -euo pipefail

FAILED=0
WARNED=0

pass() { echo "✅ PASS: $1"; }
warn() { echo "⚠️  WARN: $1"; WARNED=1; }
fail() { echo "❌ FAIL: $1"; FAILED=1; }

check_file() {
  [[ -f "$1" ]] && pass "$1 exists" || fail "$1 missing"
}

check_nonempty_file() {
  [[ -s "$1" ]] && pass "$1 is non-empty" || fail "$1 is empty or missing"
}

check_dir() {
  [[ -d "$1" ]] && pass "$1 exists" || fail "$1 missing"
}

check_contains() {
  local file="$1"
  local text="$2"

  if [[ ! -f "$file" ]]; then
    fail "$file missing"
    return
  fi

  grep -q "$text" "$file" \
    && pass "$file contains: $text" \
    || fail "$file missing required text: $text"
}

check_script_syntax() {
  local file="$1"

  if bash -n "$file" >/dev/null 2>&1; then
    pass "$file parses with bash -n"
  else
    fail "$file has shell syntax errors"
  fi
}

check_json_file() {
  local file="$1"

  if command -v python3 >/dev/null 2>&1; then
    python3 -m json.tool "$file" >/dev/null \
      && pass "$file is valid JSON" \
      || fail "$file is invalid JSON"
  else
    warn "python3 not found, skipped JSON validation for $file"
  fi
}

check_skill_frontmatter_yaml() {
  local file="$1"

  if ! command -v python3 >/dev/null 2>&1; then
    warn "python3 not found, skipped YAML validation for $file"
    return
  fi

  if python3 - "$file" >/dev/null 2>&1 <<'PY'
import sys
from pathlib import Path

try:
    import yaml
except Exception:
    sys.exit(2)

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
if not text.startswith("---\n"):
    raise SystemExit(1)

parts = text.split("---", 2)
if len(parts) < 3:
    raise SystemExit(1)

yaml.safe_load(parts[1])
PY
  then
    pass "$file has valid YAML front matter"
  else
    local py_yaml_status=$?
    if [[ "$py_yaml_status" -eq 2 ]]; then
      warn "PyYAML not available, skipped YAML validation for $file"
    else
      fail "$file has invalid YAML front matter"
    fi
  fi
}

echo "== CodexMinimal Local Readiness Check =="

echo
echo "== Root files =="
check_file README.md
check_file install.sh
check_file uninstall.sh
check_file templates/AGENTS.md
check_nonempty_file README.md

echo
echo "== Required core skills =="

CORE_SKILLS=(
  task-router
  feature-intake-gate
  implementation-spec-writer
  project-init
  project-indexer
  repo-phase-orchestrator
)

for skill in "${CORE_SKILLS[@]}"; do
  check_dir "skills/$skill"
  check_file "skills/$skill/SKILL.md"
  check_dir "skills/$skill/references"
  check_dir "skills/$skill/assets"
  check_skill_frontmatter_yaml "skills/$skill/SKILL.md"
  check_contains "skills/$skill/SKILL.md" "## Goal"
  check_contains "skills/$skill/SKILL.md" "## Use When"
  check_contains "skills/$skill/SKILL.md" "## Output Format"
done

echo
echo "== Optional profile skills =="

OPTIONAL_SKILLS=(
  nestjs-sdd-planner
  nestjs-tdd-builder
  nestjs-bug-fixer
  nestjs-code-reviewer
  nestjs-refactor-guardian
)

for skill in "${OPTIONAL_SKILLS[@]}"; do
  if [[ -d "skills/$skill" ]]; then
    check_dir "skills/$skill"
    check_file "skills/$skill/SKILL.md"
    check_dir "skills/$skill/references"
    check_dir "skills/$skill/assets"
    check_skill_frontmatter_yaml "skills/$skill/SKILL.md"
    check_contains "skills/$skill/SKILL.md" "## Goal"
    check_contains "skills/$skill/SKILL.md" "## Use When"
    check_contains "skills/$skill/SKILL.md" "## Output Format"
  else
    warn "optional profile skill not present: skills/$skill"
  fi
done

echo
echo "== Templates docs-ai =="

DOCS_AI=(
  project-index.md
  module-index.md
  route-index.md
  entity-index.md
  test-index.md
  dependency-index.md
  protected-files.md
  rule-registry.md
  stack-profile.md
  architecture-notes.md
  refactor-log.md
  context-map.json
)

for file in "${DOCS_AI[@]}"; do
  check_file "templates/docs-ai/$file"
done

echo
echo "== Documentation =="

DOCS=(
  docs/setup.md
  docs/skills.md
  docs/flows.md
  docs/model-routing.md
  docs/model-compatibility.md
  docs/profiles.md
  docs/action-risk.md
  docs/compact-mode.md
  docs/context-budget.md
  docs/indexing.md
  docs/rule-registry.md
  docs/evals.md
  docs/benchmark.md
  docs/artifacts.md
  docs/harness-state.md
  docs/release-readiness-plan.md
)

for file in "${DOCS[@]}"; do
  check_nonempty_file "$file"
done

echo
echo "== Eval Assets =="

check_nonempty_file evals/README.md
check_nonempty_file evals/task-router-golden-cases.json
check_nonempty_file evals/feature-intake-gate-golden-cases.json
check_nonempty_file evals/project-init-golden-cases.json
check_nonempty_file evals/project-indexer-golden-cases.json
check_nonempty_file evals/implementation-spec-writer-golden-cases.json
check_nonempty_file evals/repo-phase-orchestrator-golden-cases.json
check_nonempty_file evals/run-golden-evals.py
check_nonempty_file evals/run-sample-evals.sh
check_nonempty_file evals/samples/task-router-results.sample.json
check_nonempty_file evals/samples/feature-intake-gate-results.sample.json
check_nonempty_file evals/samples/project-init-results.sample.json
check_nonempty_file evals/samples/project-indexer-results.sample.json
check_nonempty_file evals/samples/implementation-spec-writer-results.sample.json
check_nonempty_file evals/samples/repo-phase-orchestrator-results.sample.json

if [[ -d "skills/nestjs-sdd-planner" ]]; then
  check_nonempty_file evals/nestjs-sdd-planner-golden-cases.json
  check_nonempty_file evals/samples/nestjs-sdd-planner-results.sample.json
fi

echo
echo "== Shell syntax =="

SCRIPTS=(
  install.sh
  uninstall.sh
  release.sh
  check-codexminimal.sh
  evals/run-sample-evals.sh
)

for file in "${SCRIPTS[@]}"; do
  check_file "$file"
  check_script_syntax "$file"
done

if command -v python3 >/dev/null 2>&1; then
  python3 -m py_compile evals/run-golden-evals.py >/dev/null \
    && pass "evals/run-golden-evals.py compiles with python3" \
    || fail "evals/run-golden-evals.py has python syntax errors"
else
  warn "python3 not found, skipped Python syntax validation"
fi

echo
echo "== Helper scripts =="

PY_SCRIPTS=(
  scripts/sync_agents_blocks.py
  scripts/bootstrap_docs_ai.py
  scripts/validate_context_map.py
  scripts/bootstrap_harness_runtime.py
  scripts/validate_harness_runtime.py
  scripts/promote_feedback_rules.py
  scripts/render_index_stubs.py
  evals/run-golden-evals.py
)

for file in "${PY_SCRIPTS[@]}"; do
  check_nonempty_file "$file"
  if command -v python3 >/dev/null 2>&1; then
    python3 -m py_compile "$file" >/dev/null \
      && pass "$file compiles with python3" \
      || fail "$file has python syntax errors"
  else
    warn "python3 not found, skipped Python syntax validation for $file"
  fi
done

echo
echo "== AGENTS.md template required blocks =="

check_contains templates/AGENTS.md "CODEXMINIMAL:ROUTING START"
check_contains templates/AGENTS.md "Always-On Task Router Protocol"
check_contains templates/AGENTS.md "CODEXMINIMAL:MODEL_ROUTING START"
check_contains templates/AGENTS.md "CODEXMINIMAL:RESPONSE_MODE START"
check_contains templates/AGENTS.md "CODEXMINIMAL:CONTEXT_BUDGET START"
check_contains templates/AGENTS.md "CODEXMINIMAL:AUTO_COMPACT START"
check_contains templates/AGENTS.md "CODEXMINIMAL:SEARCH_POLICY START"
check_contains templates/AGENTS.md "CODEXMINIMAL:HELPER_POLICY START"
check_contains templates/AGENTS.md "CODEXMINIMAL:SKILL_POLICY START"
check_contains templates/AGENTS.md "CODEXMINIMAL:STACK_PROFILE START"
check_contains templates/AGENTS.md "CODEXMINIMAL:TESTING_SPEC START"
check_contains templates/AGENTS.md "CODEXMINIMAL:PROTECTED_FILES START"
check_contains templates/AGENTS.md "CODEXMINIMAL:USER_RULE_MUTATION START"

echo
echo "== context-map schema =="

check_contains templates/docs-ai/context-map.json '"version": 2'
check_contains templates/docs-ai/context-map.json '"stackProfile"'
check_contains templates/docs-ai/context-map.json '"modules"'
check_contains templates/docs-ai/context-map.json '"controllers"'
check_contains templates/docs-ai/context-map.json '"services"'
check_contains templates/docs-ai/context-map.json '"repositories"'
check_contains templates/docs-ai/context-map.json '"entities"'
check_contains templates/docs-ai/context-map.json '"dtos"'
check_contains templates/docs-ai/context-map.json '"routes"'
check_contains templates/docs-ai/context-map.json '"surfaces"'
check_contains templates/docs-ai/context-map.json '"protectedPaths"'

if command -v python3 >/dev/null 2>&1; then
  check_json_file templates/docs-ai/context-map.json
  check_json_file templates/docs-codexminimal/current-work.json
  check_json_file templates/docs-codexminimal/artifact-registry.json
  check_json_file templates/docs-codexminimal/telemetry.json
  check_json_file templates/docs-codexminimal/feedback-ledger.json
  check_json_file skills/task-router/assets/router-output.schema.json
  check_json_file skills/feature-intake-gate/assets/intake-output.schema.json
  check_json_file skills/project-init/assets/init-output.schema.json
  check_json_file skills/project-init/assets/feedback-ledger.template.json
  check_json_file skills/project-indexer/assets/indexer-output.schema.json
  check_json_file skills/implementation-spec-writer/assets/spec-output.schema.json
  check_json_file evals/task-router-golden-cases.json
  check_json_file evals/feature-intake-gate-golden-cases.json
  check_json_file evals/project-init-golden-cases.json
  check_json_file evals/project-indexer-golden-cases.json
  check_json_file evals/implementation-spec-writer-golden-cases.json
  check_json_file evals/repo-phase-orchestrator-golden-cases.json
  check_json_file evals/samples/task-router-results.sample.json
  check_json_file evals/samples/feature-intake-gate-results.sample.json
  check_json_file evals/samples/project-init-results.sample.json
  check_json_file evals/samples/project-indexer-results.sample.json
  check_json_file evals/samples/implementation-spec-writer-results.sample.json
  check_json_file evals/samples/repo-phase-orchestrator-results.sample.json
  if [[ -d "skills/nestjs-sdd-planner" ]]; then
    check_json_file skills/nestjs-sdd-planner/assets/spec-output.schema.json
    check_json_file evals/nestjs-sdd-planner-golden-cases.json
    check_json_file evals/samples/nestjs-sdd-planner-results.sample.json
  fi
else
  warn "python3 not found, skipped JSON validation"
fi

if command -v python3 >/dev/null 2>&1; then
  if python3 scripts/validate_context_map.py --file templates/docs-ai/context-map.json >/dev/null; then
    pass "context-map helper validates template context-map"
  else
    fail "context-map helper failed on template context-map"
  fi
else
  warn "python3 not found, skipped context-map helper validation"
fi

if command -v python3 >/dev/null 2>&1; then
  TMP_REPO="$(mktemp -d /tmp/codexminimal-harness-XXXXXX)"
  python3 scripts/bootstrap_harness_runtime.py --templates-dir templates/docs-codexminimal --repo-root "$TMP_REPO" >/dev/null
  if python3 scripts/validate_harness_runtime.py --repo-root "$TMP_REPO" >/dev/null; then
    pass "harness runtime helpers bootstrap and validate correctly"
  else
    fail "harness runtime helpers failed on a temp repo"
  fi
  mkdir -p "$TMP_REPO/docs/ai"
  cp templates/docs-ai/rule-registry.md "$TMP_REPO/docs/ai/rule-registry.md"
  python3 - "$TMP_REPO/docs/codexminimal/feedback-ledger.json" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
data = json.loads(path.read_text(encoding="utf-8"))
data["issues"] = [
    {
        "issueKey": "repeat-dto-boundary",
        "description": "Do not return raw entities from controllers.",
        "count": 3,
        "status": "observed",
        "firstSeenAt": "",
        "lastSeenAt": "",
        "source": "user-feedback",
        "ruleTarget": "",
        "promotedRuleText": "",
        "affectedArtifacts": [],
        "affectedPaths": [],
        "notes": ""
    }
]
path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
  if python3 scripts/promote_feedback_rules.py --repo-root "$TMP_REPO" >/dev/null; then
    if grep -q "repeat-dto-boundary" "$TMP_REPO/docs/ai/rule-registry.md"; then
      pass "feedback promotion helper syncs promoted rules"
    else
      fail "feedback promotion helper did not render promoted rules"
    fi
  else
    fail "feedback promotion helper failed on a temp repo"
  fi
else
  warn "python3 not found, skipped harness runtime helper validation"
fi

echo
echo "== protected-files categories =="

check_contains templates/docs-ai/protected-files.md "## Critical"
check_contains templates/docs-ai/protected-files.md "## Sensitive"
check_contains templates/docs-ai/protected-files.md "## Integration"

echo
echo "== Empty Reference Guard =="

EMPTY_SKILL_FILES="$(find skills -type f -empty | sort || true)"
if [[ -n "$EMPTY_SKILL_FILES" ]]; then
  echo "$EMPTY_SKILL_FILES"
  fail "empty skill asset/reference files found"
else
  pass "no empty skill asset/reference files"
fi

echo
echo "== Bundled Helper Sync =="

SYNC_PAIRS=(
  "templates/AGENTS.md|skills/project-init/assets/AGENTS.template.md"
  "templates/docs-ai/project-index.md|skills/project-init/assets/project-index.template.md"
  "templates/docs-ai/module-index.md|skills/project-init/assets/module-index.template.md"
  "templates/docs-ai/route-index.md|skills/project-init/assets/route-index.template.md"
  "templates/docs-ai/entity-index.md|skills/project-init/assets/entity-index.template.md"
  "templates/docs-ai/test-index.md|skills/project-init/assets/test-index.template.md"
  "templates/docs-ai/dependency-index.md|skills/project-init/assets/dependency-index.template.md"
  "templates/docs-ai/protected-files.md|skills/project-init/assets/protected-files.template.md"
  "templates/docs-ai/rule-registry.md|skills/project-init/assets/rule-registry.template.md"
  "templates/docs-ai/architecture-notes.md|skills/project-init/assets/architecture-notes.template.md"
  "templates/docs-ai/refactor-log.md|skills/project-init/assets/refactor-log.template.md"
  "templates/docs-ai/stack-profile.md|skills/project-init/assets/stack-profile.template.md"
  "templates/docs-ai/context-map.json|skills/project-init/assets/context-map.template.json"
  "templates/docs-codexminimal/current-work.json|skills/project-init/assets/current-work.template.json"
  "templates/docs-codexminimal/artifact-registry.json|skills/project-init/assets/artifact-registry.template.json"
  "templates/docs-codexminimal/telemetry.json|skills/project-init/assets/telemetry.template.json"
  "templates/docs-codexminimal/feedback-ledger.json|skills/project-init/assets/feedback-ledger.template.json"
  "templates/docs-ai/project-index.md|skills/project-indexer/assets/project-index.template.md"
  "templates/docs-ai/module-index.md|skills/project-indexer/assets/module-index.template.md"
  "templates/docs-ai/route-index.md|skills/project-indexer/assets/route-index.template.md"
  "templates/docs-ai/dependency-index.md|skills/project-indexer/assets/dependency-index.template.md"
  "templates/docs-ai/context-map.json|skills/project-indexer/assets/context-map.template.json"
  "scripts/sync_agents_blocks.py|skills/project-init/scripts/sync_agents_blocks.py"
  "scripts/bootstrap_docs_ai.py|skills/project-init/scripts/bootstrap_docs_ai.py"
  "scripts/bootstrap_harness_runtime.py|skills/project-init/scripts/bootstrap_harness_runtime.py"
  "scripts/promote_feedback_rules.py|skills/project-init/scripts/promote_feedback_rules.py"
  "scripts/render_index_stubs.py|skills/project-indexer/scripts/render_index_stubs.py"
  "scripts/validate_context_map.py|skills/project-indexer/scripts/validate_context_map.py"
)

for pair in "${SYNC_PAIRS[@]}"; do
  left="${pair%%|*}"
  right="${pair##*|}"
  if diff -u "$left" "$right" >/dev/null 2>&1; then
    pass "$left is in sync with $right"
  else
    fail "$left differs from $right"
  fi
done

echo
echo "== install target preview =="

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"

echo "Codex skills target: $SKILLS_DIR"

if [[ -d "$SKILLS_DIR" ]]; then
  pass "$SKILLS_DIR exists"
else
  warn "$SKILLS_DIR does not exist yet; install.sh should create it"
fi

echo
echo "== Result =="

if [[ "$FAILED" -eq 1 ]]; then
  echo "❌ CodexMinimal is NOT ready."
  exit 1
fi

if [[ "$WARNED" -eq 1 ]]; then
  echo "⚠️  CodexMinimal is structurally ready with warnings."
  exit 0
fi

echo "✅ CodexMinimal is ready for local install and testing."
