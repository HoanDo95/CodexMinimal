#!/usr/bin/env bash
set -euo pipefail

FAILED=0
WARNED=0
CORE_SKILL_LINE_LIMIT=200
PROFILE_SKILL_LINE_LIMIT=120

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

check_markdown_links() {
  local files=("$@")

  if ! command -v python3 >/dev/null 2>&1; then
    warn "python3 not found, skipped Markdown link validation"
    return
  fi

  if python3 - "${files[@]}" <<'PY'
import re
import sys
from pathlib import Path
from urllib.parse import unquote

root = Path.cwd()
missing = []
pattern = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")

for raw_file in sys.argv[1:]:
    source = Path(raw_file)
    text = source.read_text(encoding="utf-8")
    for match in pattern.finditer(text):
        raw_target = match.group(1).strip()
        if not raw_target or raw_target.startswith(("#", "http://", "https://", "mailto:")):
            continue
        target = raw_target.split("#", 1)[0].strip()
        if not target:
            continue
        if target.startswith("<") and target.endswith(">"):
            target = target[1:-1]
        target = unquote(target)
        path = Path(target)
        resolved = path if path.is_absolute() else source.parent / path
        try:
            resolved.relative_to(root)
        except ValueError:
            continue
        if not resolved.exists():
            missing.append(f"{source}:{raw_target}")

if missing:
    for item in missing:
        print(item)
    raise SystemExit(1)
PY
  then
    pass "Markdown local links resolve"
  else
    fail "Markdown local links contain missing targets"
  fi
}

check_skill_line_budget() {
  local file="$1"
  local max_lines="$2"
  local label="$3"

  if [[ ! -f "$file" ]]; then
    fail "$file missing for line-budget check"
    return
  fi

  local line_count
  line_count="$(wc -l < "$file" | tr -d ' ')"
  if [[ "$line_count" -le "$max_lines" ]]; then
    pass "$file has $line_count lines within $label budget ($max_lines)"
  else
    fail "$file has $line_count lines, exceeds $label budget ($max_lines)"
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

run_install_smoke() {
  local label="$1"
  local profiles="$2"
  local forbidden="$3"
  shift 3

  local tmp_home
  local log_file
  tmp_home="$(mktemp -d "/tmp/codexminimal-install-${label}-XXXXXX")"
  log_file="$tmp_home/install.log"

  if CODEX_HOME="$tmp_home/.codex" \
      CODEXMINIMAL_INSTALL_PROFILES="$profiles" \
      CODEXMINIMAL_SKIP_READINESS=1 \
      bash install.sh >"$log_file" 2>&1; then
    pass "install smoke passes for $label"
  else
    cat "$log_file"
    fail "install smoke failed for $label"
    rm -rf "$tmp_home"
    return
  fi

  local skill
  for skill in "${CORE_SKILLS[@]}"; do
    if [[ -f "$tmp_home/.codex/skills/$skill/SKILL.md" ]]; then
      pass "$label install includes core skill $skill"
    else
      fail "$label install missing core skill $skill"
    fi
  done

  for skill in "$@"; do
    if [[ -f "$tmp_home/.codex/skills/$skill/SKILL.md" ]]; then
      pass "$label install includes profile skill $skill"
    else
      fail "$label install missing profile skill $skill"
    fi
  done

  local expected_profile_skills=" $* "
  for skill in "${OPTIONAL_SKILLS[@]}"; do
    if [[ "$expected_profile_skills" != *" $skill "* && -e "$tmp_home/.codex/skills/$skill" ]]; then
      fail "$label install unexpectedly includes profile skill $skill"
    fi
  done

  local forbidden_skills=" $forbidden "
  for skill in $forbidden_skills; do
    if [[ -e "$tmp_home/.codex/skills/$skill" ]]; then
      fail "$label install unexpectedly includes legacy skill $skill"
    else
      pass "$label install omits legacy skill $skill"
    fi
  done

  rm -rf "$tmp_home"
}

run_idsd_scaffold_smoke() {
  local tmp_home
  tmp_home="$(mktemp -d "/tmp/codexminimal-idsd-smoke-XXXXXX")"

  if python3 scripts/scaffold_idsd_intent.py \
      --repo-root "$tmp_home" \
      --topic "billing rollout" \
      --intent "Charge teams fairly while admins understand every charge." \
      --business-rule "Usage must map to an auditable charge." \
      --acceptance-criterion "Given usage exists, when the admin views charges, then each charge shows its usage source." \
      --agent-card planner \
      --agent-card verifier >/dev/null; then
    pass "IDSD scaffold helper creates an intent package"
  else
    fail "IDSD scaffold helper failed to create an intent package"
    rm -rf "$tmp_home"
    return
  fi

  local expected="$tmp_home/docs/codexminimal/idsd/billing-rollout-intent.md"
  if [[ -f "$expected" ]]; then
    pass "IDSD scaffold helper writes expected slugged file"
  else
    fail "IDSD scaffold helper missing expected file"
  fi

  if grep -q "Charge teams fairly" "$expected" && grep -q "planner" "$expected"; then
    pass "IDSD scaffold helper writes intent and agent cards"
  else
    fail "IDSD scaffold helper output missing intent or agent cards"
  fi

  rm -rf "$tmp_home"
}

run_idsd_trace_smoke() {
  local tmp_home
  tmp_home="$(mktemp -d "/tmp/codexminimal-idsd-trace-XXXXXX")"

  if python3 scripts/start_idsd_trace.py \
      --repo-root "$tmp_home" \
      --topic "checkout cleanup" \
      --intent "Make checkout easier to complete." \
      --stack nestjs \
      --task-type feature >/dev/null; then
    pass "IDSD trace helper creates a trace folder"
  else
    fail "IDSD trace helper failed to create a trace folder"
    rm -rf "$tmp_home"
    return
  fi

  local trace_dir="$tmp_home/docs/codexminimal/idsd-traces/checkout-cleanup"
  if [[ -f "$trace_dir/trace.json" && -f "$trace_dir/intent-package.md" && -f "$trace_dir/verification.md" ]]; then
    pass "IDSD trace helper writes expected trace files"
  else
    fail "IDSD trace helper missing expected trace files"
  fi

  if grep -q '"stack": "nestjs"' "$trace_dir/trace.json" && grep -q "Make checkout easier" "$trace_dir/intent-package.md"; then
    pass "IDSD trace helper records stack and intent"
  else
    fail "IDSD trace helper output missing stack or intent"
  fi

  rm -rf "$tmp_home"
}

echo "== CodexMinimal Local Readiness Check =="

echo
echo "== Root files =="
check_file README.md
check_file install.sh
check_file uninstall.sh
check_file templates/AGENTS.md
check_nonempty_file README.md
check_nonempty_file docs/idsd-architecture-report.html

echo
echo "== Required core skills =="

CORE_SKILLS=(
  task-router
  idsd-orchestrator
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

NESTJS_PROFILE_SKILLS=(
  nestjs-sdd-planner
  nestjs-tdd-builder
  nestjs-bug-fixer
  nestjs-code-reviewer
  nestjs-refactor-guardian
)

RUST_PROFILE_SKILLS=(
  rust-sdd-planner
  rust-tdd-builder
  rust-bug-fixer
  rust-code-reviewer
  rust-refactor-guardian
)

OPTIONAL_SKILLS=(
  feature-intake-gate
  implementation-spec-writer
  "${NESTJS_PROFILE_SKILLS[@]}"
  "${RUST_PROFILE_SKILLS[@]}"
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
echo "== Skill Size Budget =="

for skill in "${CORE_SKILLS[@]}"; do
  check_skill_line_budget "skills/$skill/SKILL.md" "$CORE_SKILL_LINE_LIMIT" "core"
done

for skill in "${OPTIONAL_SKILLS[@]}"; do
  if [[ -d "skills/$skill" ]]; then
    check_skill_line_budget "skills/$skill/SKILL.md" "$PROFILE_SKILL_LINE_LIMIT" "profile"
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
  docs/idsd.md
  docs/idsd-usage-guide.md
  docs/profiles.md
  docs/action-risk.md
  docs/compact-mode.md
  docs/context-budget.md
  docs/indexing.md
  docs/rule-registry.md
  docs/evals.md
  docs/tool-adapter-playbook.md
  docs/review-policy.md
  docs/benchmark.md
  docs/artifacts.md
  docs/harness-state.md
  docs/release-readiness-plan.md
)

for file in "${DOCS[@]}"; do
  check_nonempty_file "$file"
done

MARKDOWN_DOCS=(README.md docs/*.md)
check_markdown_links "${MARKDOWN_DOCS[@]}"

echo
echo "== Eval Assets =="

check_nonempty_file evals/README.md
check_nonempty_file evals/task-router-golden-cases.json
check_nonempty_file evals/idsd-orchestrator-golden-cases.json
check_nonempty_file evals/feature-intake-gate-golden-cases.json
check_nonempty_file evals/project-init-golden-cases.json
check_nonempty_file evals/project-indexer-golden-cases.json
check_nonempty_file evals/implementation-spec-writer-golden-cases.json
check_nonempty_file evals/repo-phase-orchestrator-golden-cases.json
check_nonempty_file evals/run-golden-evals.py
check_nonempty_file evals/run-sample-evals.sh
check_nonempty_file scripts/scaffold_idsd_intent.py
check_nonempty_file scripts/start_idsd_trace.py
check_nonempty_file evals/samples/task-router-results.sample.json
check_nonempty_file evals/samples/idsd-orchestrator-results.sample.json
check_nonempty_file evals/samples/feature-intake-gate-results.sample.json
check_nonempty_file evals/samples/project-init-results.sample.json
check_nonempty_file evals/samples/project-indexer-results.sample.json
check_nonempty_file evals/samples/implementation-spec-writer-results.sample.json
check_nonempty_file evals/samples/repo-phase-orchestrator-results.sample.json

if [[ -d "skills/nestjs-sdd-planner" ]]; then
  check_nonempty_file evals/nestjs-sdd-planner-golden-cases.json
  check_nonempty_file evals/samples/nestjs-sdd-planner-results.sample.json
fi

if [[ -d "skills/rust-sdd-planner" ]]; then
  check_nonempty_file skills/rust-sdd-planner/assets/spec-output.schema.json
  check_nonempty_file evals/rust-sdd-planner-golden-cases.json
  check_nonempty_file evals/samples/rust-sdd-planner-results.sample.json
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
  scripts/record_feedback_issue.py
  scripts/promote_feedback_rules.py
  scripts/render_index_stubs.py
  scripts/scaffold_idsd_intent.py
  scripts/start_idsd_trace.py
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
check_contains templates/docs-ai/context-map.json '"detectedStack"'
check_contains templates/docs-ai/context-map.json '"entrypoints"'
check_contains templates/docs-ai/context-map.json '"modules"'
check_contains templates/docs-ai/context-map.json '"handlers"'
check_contains templates/docs-ai/context-map.json '"controllers"'
check_contains templates/docs-ai/context-map.json '"services"'
check_contains templates/docs-ai/context-map.json '"dataAccess"'
check_contains templates/docs-ai/context-map.json '"repositories"'
check_contains templates/docs-ai/context-map.json '"entities"'
check_contains templates/docs-ai/context-map.json '"dtos"'
check_contains templates/docs-ai/context-map.json '"contracts"'
check_contains templates/docs-ai/context-map.json '"routes"'
check_contains templates/docs-ai/context-map.json '"jobs"'
check_contains templates/docs-ai/context-map.json '"integrations"'
check_contains templates/docs-ai/context-map.json '"configuration"'
check_contains templates/docs-ai/context-map.json '"surfaces"'
check_contains templates/docs-ai/context-map.json '"verification"'
check_contains templates/docs-ai/context-map.json '"protectedPaths"'

if command -v python3 >/dev/null 2>&1; then
  check_json_file templates/docs-ai/context-map.json
  check_json_file templates/docs-codexminimal/current-work.json
  check_json_file templates/docs-codexminimal/artifact-registry.json
  check_json_file templates/docs-codexminimal/telemetry.json
  check_json_file templates/docs-codexminimal/feedback-ledger.json
  check_json_file skills/task-router/assets/router-output.schema.json
  check_json_file skills/idsd-orchestrator/assets/idsd-output.schema.json
  check_json_file skills/feature-intake-gate/assets/intake-output.schema.json
  check_json_file skills/project-init/assets/init-output.schema.json
  check_json_file skills/project-init/assets/feedback-ledger.template.json
  check_json_file skills/project-indexer/assets/indexer-output.schema.json
  check_json_file skills/implementation-spec-writer/assets/spec-output.schema.json
  check_json_file evals/task-router-golden-cases.json
  check_json_file evals/idsd-orchestrator-golden-cases.json
  check_json_file evals/feature-intake-gate-golden-cases.json
  check_json_file evals/project-init-golden-cases.json
  check_json_file evals/project-indexer-golden-cases.json
  check_json_file evals/implementation-spec-writer-golden-cases.json
  check_json_file evals/repo-phase-orchestrator-golden-cases.json
  check_json_file evals/samples/task-router-results.sample.json
  check_json_file evals/samples/idsd-orchestrator-results.sample.json
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
  if [[ -d "skills/rust-sdd-planner" ]]; then
    check_json_file skills/rust-sdd-planner/assets/spec-output.schema.json
    check_json_file evals/rust-sdd-planner-golden-cases.json
    check_json_file evals/samples/rust-sdd-planner-results.sample.json
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
  run_idsd_scaffold_smoke
  run_idsd_trace_smoke
else
  warn "python3 not found, skipped IDSD helper smokes"
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
  if python3 scripts/record_feedback_issue.py \
      --repo-root "$TMP_REPO" \
      --issue-key repeat-dto-boundary \
      --description "Do not return raw entities from controllers." \
      --strikes 3 >/dev/null \
    && python3 scripts/promote_feedback_rules.py --repo-root "$TMP_REPO" >/dev/null; then
    if grep -q "repeat-dto-boundary" "$TMP_REPO/docs/ai/rule-registry.md"; then
      pass "feedback record and promotion helpers sync promoted rules"
    else
      fail "feedback promotion helper did not render promoted rules"
    fi
  else
    fail "feedback record or promotion helper failed on a temp repo"
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
  "scripts/record_feedback_issue.py|skills/project-init/scripts/record_feedback_issue.py"
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
echo "== Install Smoke Tests =="

run_install_smoke "core" "" "feature-intake-gate implementation-spec-writer"
run_install_smoke "legacy" "legacy" "" feature-intake-gate implementation-spec-writer
run_install_smoke "nestjs" "nestjs" "feature-intake-gate implementation-spec-writer" "${NESTJS_PROFILE_SKILLS[@]}"
run_install_smoke "rust" "rust" "feature-intake-gate implementation-spec-writer" "${RUST_PROFILE_SKILLS[@]}"
run_install_smoke "nestjs-rust" "nestjs,rust" "feature-intake-gate implementation-spec-writer" "${NESTJS_PROFILE_SKILLS[@]}" "${RUST_PROFILE_SKILLS[@]}"

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
