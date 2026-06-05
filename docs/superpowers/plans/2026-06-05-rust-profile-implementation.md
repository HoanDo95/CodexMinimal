# Rust Profile Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a standalone optional `rust` profile to `CodexMinimal` with install wiring, routing and detection support, five Rust-specific skills, Rust profile docs, and minimal eval coverage.

**Architecture:** Keep the existing generic harness intact and extend the current optional-profile pattern instead of inventing a parallel system. Mirror the `nestjs` profile surface for install, routing, skills, and evals, but keep the Rust rules `convention-first` so repository evidence decides whether service-specific patterns apply.

**Tech Stack:** Bash installer/check scripts, Markdown docs, JSON schemas and eval fixtures, Codex skill folders, Python eval runner, Cargo/Rust conventions

---

## File Structure Map

### Create

- `docs/rust-spec.md`
- `docs/superpowers/plans/2026-06-05-rust-profile-implementation.md`
- `skills/rust-sdd-planner/SKILL.md`
- `skills/rust-sdd-planner/references/acceptance-criteria.md`
- `skills/rust-sdd-planner/references/crate-api-contract.md`
- `skills/rust-sdd-planner/references/spec-format.md`
- `skills/rust-sdd-planner/references/workspace-impact.md`
- `skills/rust-sdd-planner/assets/acceptance-criteria.template.md`
- `skills/rust-sdd-planner/assets/spec-output.schema.json`
- `skills/rust-sdd-planner/assets/spec.template.md`
- `skills/rust-tdd-builder/SKILL.md`
- `skills/rust-tdd-builder/references/repository-guidelines.md`
- `skills/rust-tdd-builder/references/rust-rules.md`
- `skills/rust-tdd-builder/references/naming-conventions.md`
- `skills/rust-tdd-builder/references/testing-guidelines.md`
- `skills/rust-tdd-builder/references/crate-boundaries.md`
- `skills/rust-tdd-builder/assets/lib.template.rs`
- `skills/rust-tdd-builder/assets/response-template.md`
- `skills/rust-tdd-builder/assets/unit-test.template.rs`
- `skills/rust-bug-fixer/SKILL.md`
- `skills/rust-bug-fixer/references/debug-flow.md`
- `skills/rust-bug-fixer/references/root-cause-analysis.md`
- `skills/rust-bug-fixer/references/common-rust-bugs.md`
- `skills/rust-bug-fixer/references/regression-test.md`
- `skills/rust-bug-fixer/assets/fix-summary.template.md`
- `skills/rust-bug-fixer/assets/bug-report.template.md`
- `skills/rust-bug-fixer/assets/regression-test.template.rs`
- `skills/rust-code-reviewer/SKILL.md`
- `skills/rust-code-reviewer/references/review-checklist.md`
- `skills/rust-code-reviewer/references/api-checklist.md`
- `skills/rust-code-reviewer/references/safety-checklist.md`
- `skills/rust-code-reviewer/references/test-checklist.md`
- `skills/rust-code-reviewer/references/concurrency-checklist.md`
- `skills/rust-code-reviewer/assets/review-report.template.md`
- `skills/rust-code-reviewer/assets/verdict-template.md`
- `skills/rust-refactor-guardian/SKILL.md`
- `skills/rust-refactor-guardian/references/refactor-checklist.md`
- `skills/rust-refactor-guardian/references/architecture-rules.md`
- `skills/rust-refactor-guardian/references/rollback-guidelines.md`
- `skills/rust-refactor-guardian/references/impact-map-template.md`
- `skills/rust-refactor-guardian/assets/rollback-plan.template.md`
- `skills/rust-refactor-guardian/assets/impact-map.template.md`
- `skills/rust-refactor-guardian/assets/refactor-log-entry.template.md`
- `evals/rust-sdd-planner-golden-cases.json`
- `evals/samples/rust-sdd-planner-results.sample.json`

### Modify

- `install.sh`
- `check-codexminimal.sh`
- `README.md`
- `docs/profiles.md`
- `docs/setup.md`
- `docs/skills.md`
- `docs/flows.md`
- `docs/artifacts.md`
- `docs/architecture.md`
- `docs/cheat-sheet.md`
- `docs/evals.md`
- `docs/release-readiness-plan.md`
- `skills/task-router/SKILL.md`
- `skills/task-router/references/classification-rules.md`
- `skills/task-router/assets/router-output.schema.json`
- `skills/feature-intake-gate/SKILL.md`
- `skills/feature-intake-gate/references/handoff-policy.md`
- `skills/feature-intake-gate/assets/intake-output.schema.json`
- `skills/project-init/SKILL.md`
- `skills/project-init/references/project-structure.md`
- `templates/AGENTS.md`
- `skills/project-init/assets/AGENTS.template.md`
- `evals/task-router-golden-cases.json`
- `evals/samples/task-router-results.sample.json`
- `evals/feature-intake-gate-golden-cases.json`
- `evals/samples/feature-intake-gate-results.sample.json`
- `evals/run-sample-evals.sh`

### Verification Targets

- `rtk bash check-codexminimal.sh`
- `rtk bash evals/run-sample-evals.sh`
- `rtk proxy env CODEX_HOME=/tmp/codexminimal-rust-install CODEXMINIMAL_INSTALL_PROFILES=rust bash install.sh`
- `rtk proxy env CODEX_HOME=/tmp/codexminimal-rust-combo CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust bash install.sh`

### Protected/High-Risk Notes

- Do not overwrite the real `~/.codex/skills` during smoke tests; always set `CODEX_HOME` to a `/tmp` path.
- Keep generic routing unchanged for non-Rust repositories.
- Do not move existing `nestjs-*` files; only extend the optional-profile model.

### Task 1: Wire Installer And Readiness For Rust

**Files:**
- Modify: `install.sh`
- Modify: `check-codexminimal.sh`

- [ ] **Step 1: Add the Rust profile array and install branch in `install.sh`**

```bash
RUST_PROFILE_SKILLS=(
  rust-sdd-planner
  rust-tdd-builder
  rust-bug-fixer
  rust-code-reviewer
  rust-refactor-guardian
)

if profile_requested "rust"; then
  INSTALL_SKILLS+=("${RUST_PROFILE_SKILLS[@]}")
  ACTIVE_PROFILES+=("rust")
fi
```

- [ ] **Step 2: Extend optional-skill checks in `check-codexminimal.sh`**

```bash
OPTIONAL_SKILLS=(
  nestjs-sdd-planner
  nestjs-tdd-builder
  nestjs-bug-fixer
  nestjs-code-reviewer
  nestjs-refactor-guardian
  rust-sdd-planner
  rust-tdd-builder
  rust-bug-fixer
  rust-code-reviewer
  rust-refactor-guardian
)

if [[ -d "skills/rust-sdd-planner" ]]; then
  check_json_file skills/rust-sdd-planner/assets/spec-output.schema.json
  check_json_file evals/rust-sdd-planner-golden-cases.json
  check_json_file evals/samples/rust-sdd-planner-results.sample.json
fi
```

- [ ] **Step 3: Run the readiness check before any Rust skill files exist**

Run:

```bash
rtk bash check-codexminimal.sh
```

Expected:
- command exits `0`
- output includes warnings such as `optional profile skill not present: skills/rust-sdd-planner`
- no existing core or NestJS checks regress

- [ ] **Step 4: Commit the installer/readiness plumbing**

```bash
rtk proxy git add install.sh check-codexminimal.sh
rtk proxy git commit -m "Add rust profile install and readiness hooks"
```

### Task 2: Add Rust Profile Docs And Public Install Surface

**Files:**
- Create: `docs/rust-spec.md`
- Modify: `docs/profiles.md`
- Modify: `docs/setup.md`
- Modify: `docs/skills.md`
- Modify: `docs/flows.md`
- Modify: `docs/artifacts.md`
- Modify: `docs/architecture.md`
- Modify: `docs/cheat-sheet.md`
- Modify: `docs/evals.md`
- Modify: `docs/release-readiness-plan.md`
- Modify: `README.md`

- [ ] **Step 1: Create `docs/rust-spec.md` as the Rust counterpart to `docs/nestjs-spec.md`**

```md
# Rust Specification

This file describes the optional `rust` profile.

Apply these rules only when:

- the active stack profile is `rust`
- or the user explicitly chooses the Rust profile

Rust profile defaults:

- prefer idiomatic Cargo package and crate organization
- keep module visibility explicit and narrow
- separate binary entrypoints from reusable library logic
- prefer `Result` for recoverable failures
- reserve `panic!` for unrecoverable invariants or explicit contract violations
- prefer unit tests near implementation and integration tests at crate or public API boundaries
- reason at package, crate, and module level for workspaces
- follow framework-specific patterns only when the repository already uses them
```

- [ ] **Step 2: Update profile and setup docs to advertise standalone and combined Rust installs**

```md
## Rust Profile

When the active profile is `rust`, CodexMinimal may use:

- `rust-sdd-planner`
- `rust-tdd-builder`
- `rust-bug-fixer`
- `rust-code-reviewer`
- `rust-refactor-guardian`

Core plus Rust profile:
`CODEXMINIMAL_INSTALL_PROFILES=rust bash install.sh`

Core plus NestJS and Rust profiles:
`CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust bash install.sh`
```

- [ ] **Step 3: Sweep the remaining docs and README for Rust flow, artifacts, eval, and cheat-sheet references**

Use these exact additions as anchors:

```md
- `brainstorming -> rust-sdd-planner -> repo-phase-orchestrator`
- `rust-bug-fixer -> project-indexer`
- `rust-refactor-guardian -> project-indexer`
- if the active profile is rust and the request is code-review only, you may use `rust-code-reviewer`
- if you ship the Rust profile, test against at least one real Rust repository or template
```

- [ ] **Step 4: Verify the docs surface contains the new Rust paths and install examples**

Run:

```bash
rtk rg -n "rust-sdd-planner|rust-bug-fixer|CODEXMINIMAL_INSTALL_PROFILES=rust|CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust" docs README.md
```

Expected:
- every listed file above appears in the search results
- `docs/rust-spec.md` exists
- no existing `nestjs` examples are removed

- [ ] **Step 5: Commit the docs sweep**

```bash
rtk proxy git add docs/rust-spec.md docs/profiles.md docs/setup.md docs/skills.md docs/flows.md docs/artifacts.md docs/architecture.md docs/cheat-sheet.md docs/evals.md docs/release-readiness-plan.md README.md
rtk proxy git commit -m "Document the rust profile surface"
```

### Task 3: Extend Routing, Feature Intake, Templates, And Detection Metadata

**Files:**
- Modify: `skills/task-router/SKILL.md`
- Modify: `skills/task-router/references/classification-rules.md`
- Modify: `skills/task-router/assets/router-output.schema.json`
- Modify: `skills/feature-intake-gate/SKILL.md`
- Modify: `skills/feature-intake-gate/references/handoff-policy.md`
- Modify: `skills/feature-intake-gate/assets/intake-output.schema.json`
- Modify: `skills/project-init/SKILL.md`
- Modify: `skills/project-init/references/project-structure.md`
- Modify: `templates/AGENTS.md`
- Modify: `skills/project-init/assets/AGENTS.template.md`

- [ ] **Step 1: Add Rust optional-profile skills to task-router and its schema**

```md
- rust-sdd-planner
- rust-tdd-builder
- rust-bug-fixer
- rust-code-reviewer
- rust-refactor-guardian

Treat `rust-*` skills as optional profile skills. Use them only when the active stack profile is `rust` or the user explicitly selects them.
```

```json
"primarySkill": {
  "enum": [
    "none",
    "feature-intake-gate",
    "brainstorming",
    "implementation-spec-writer",
    "project-init",
    "project-indexer",
    "nestjs-sdd-planner",
    "nestjs-tdd-builder",
    "nestjs-bug-fixer",
    "nestjs-code-reviewer",
    "nestjs-refactor-guardian",
    "rust-sdd-planner",
    "rust-tdd-builder",
    "rust-bug-fixer",
    "rust-code-reviewer",
    "rust-refactor-guardian",
    "repo-phase-orchestrator"
  ]
}
```

- [ ] **Step 2: Route approved Rust feature work through `rust-sdd-planner` in feature intake**

```md
- `rust-sdd-planner` owns the implementation-ready Rust specification
- Use `rust-sdd-planner` only when the active stack profile is `rust` and the repository needs Rust-specific spec detail.
```

```json
"nextSkill": {
  "enum": [
    "brainstorming",
    "implementation-spec-writer",
    "nestjs-sdd-planner",
    "rust-sdd-planner",
    "repo-phase-orchestrator",
    "subagent-driven-development",
    "executing-plans"
  ]
}
```

- [ ] **Step 3: Teach `project-init` and AGENTS templates how to recognize Rust repositories**

```md
14. Detect the active stack profile:
   - default to `generic`
   - promote to `nestjs` only when the repository structure or dependencies clearly support it
   - promote to `rust` when Cargo manifests, workspace structure, or Rust-specific conventions clearly support it
```

```md
- `rust-sdd-planner`, `rust-bug-fixer`, `rust-code-reviewer`, `rust-refactor-guardian`, `rust-tdd-builder`: optional Rust profile skills
```

```md
- Rust: Cargo.toml, Cargo.lock, src/lib.rs, src/main.rs, src/bin, crates/, rust-toolchain.toml, .cargo/config.toml
```

- [ ] **Step 4: Validate the modified JSON schemas parse cleanly**

Run:

```bash
rtk python3 -m json.tool skills/task-router/assets/router-output.schema.json >/dev/null
rtk python3 -m json.tool skills/feature-intake-gate/assets/intake-output.schema.json >/dev/null
```

Expected:
- both commands exit `0`
- no JSON syntax regression

- [ ] **Step 5: Commit routing and detection updates**

```bash
rtk proxy git add skills/task-router/SKILL.md skills/task-router/references/classification-rules.md skills/task-router/assets/router-output.schema.json skills/feature-intake-gate/SKILL.md skills/feature-intake-gate/references/handoff-policy.md skills/feature-intake-gate/assets/intake-output.schema.json skills/project-init/SKILL.md skills/project-init/references/project-structure.md templates/AGENTS.md skills/project-init/assets/AGENTS.template.md
rtk proxy git commit -m "Add rust routing and detection metadata"
```

### Task 4: Create The Rust Planner Skill

**Files:**
- Create: `skills/rust-sdd-planner/SKILL.md`
- Create: `skills/rust-sdd-planner/references/acceptance-criteria.md`
- Create: `skills/rust-sdd-planner/references/crate-api-contract.md`
- Create: `skills/rust-sdd-planner/references/spec-format.md`
- Create: `skills/rust-sdd-planner/references/workspace-impact.md`
- Create: `skills/rust-sdd-planner/assets/acceptance-criteria.template.md`
- Create: `skills/rust-sdd-planner/assets/spec-output.schema.json`
- Create: `skills/rust-sdd-planner/assets/spec.template.md`

- [ ] **Step 1: Write `skills/rust-sdd-planner/SKILL.md` with Rust-specific planning rules**

```md
---
name: rust-sdd-planner
description: Plan Rust work using spec-driven development. Use for requirements, crate boundaries, API contracts, error design, concurrency assumptions, workspace impact, acceptance criteria, test plans, and implementation handoff notes before detailed planning. Do not implement code.
---

# Rust SDD Planner

## Goal

Turn a product or technical request into a concise implementation-ready Rust specification.

## Rust Specification Rules

- reason at package, crate, and module boundaries
- keep public API surface intentional
- prefer `Result` for recoverable failures
- reserve `panic!` for invariant violations or unrecoverable states
- use service-specific guidance only when repository evidence supports it
```

- [ ] **Step 2: Create planner references and assets that match the NestJS planner shape but use Rust concepts**

Use these file anchors:

```md
# Crate API Contract

- public structs, enums, traits, and functions
- visibility boundaries
- error return types
- semver-sensitive changes
```

```json
{
  "type": "object",
  "additionalProperties": false,
  "required": ["classification", "affectedModules", "openQuestionsOrAssumptions"],
  "properties": {
    "classification": { "type": "string" },
    "affectedModules": { "type": "array", "items": { "type": "string" } },
    "openQuestionsOrAssumptions": { "type": "array", "items": { "type": "string" } }
  }
}
```

- [ ] **Step 3: Run the readiness check with only the Rust planner present**

Run:

```bash
rtk bash check-codexminimal.sh
```

Expected:
- command exits `0`
- Rust planner files are validated
- remaining Rust skill directories still show optional warnings

- [ ] **Step 4: Commit the Rust planner skill**

```bash
rtk proxy git add skills/rust-sdd-planner
rtk proxy git commit -m "Add rust planner skill"
```

### Task 5: Create The Remaining Rust Execution, Review, And Refactor Skills

**Files:**
- Create: `skills/rust-tdd-builder/SKILL.md`
- Create: `skills/rust-tdd-builder/references/repository-guidelines.md`
- Create: `skills/rust-tdd-builder/references/rust-rules.md`
- Create: `skills/rust-tdd-builder/references/naming-conventions.md`
- Create: `skills/rust-tdd-builder/references/testing-guidelines.md`
- Create: `skills/rust-tdd-builder/references/crate-boundaries.md`
- Create: `skills/rust-tdd-builder/assets/lib.template.rs`
- Create: `skills/rust-tdd-builder/assets/response-template.md`
- Create: `skills/rust-tdd-builder/assets/unit-test.template.rs`
- Create: `skills/rust-bug-fixer/SKILL.md`
- Create: `skills/rust-bug-fixer/references/debug-flow.md`
- Create: `skills/rust-bug-fixer/references/root-cause-analysis.md`
- Create: `skills/rust-bug-fixer/references/common-rust-bugs.md`
- Create: `skills/rust-bug-fixer/references/regression-test.md`
- Create: `skills/rust-bug-fixer/assets/fix-summary.template.md`
- Create: `skills/rust-bug-fixer/assets/bug-report.template.md`
- Create: `skills/rust-bug-fixer/assets/regression-test.template.rs`
- Create: `skills/rust-code-reviewer/SKILL.md`
- Create: `skills/rust-code-reviewer/references/review-checklist.md`
- Create: `skills/rust-code-reviewer/references/api-checklist.md`
- Create: `skills/rust-code-reviewer/references/safety-checklist.md`
- Create: `skills/rust-code-reviewer/references/test-checklist.md`
- Create: `skills/rust-code-reviewer/references/concurrency-checklist.md`
- Create: `skills/rust-code-reviewer/assets/review-report.template.md`
- Create: `skills/rust-code-reviewer/assets/verdict-template.md`
- Create: `skills/rust-refactor-guardian/SKILL.md`
- Create: `skills/rust-refactor-guardian/references/refactor-checklist.md`
- Create: `skills/rust-refactor-guardian/references/architecture-rules.md`
- Create: `skills/rust-refactor-guardian/references/rollback-guidelines.md`
- Create: `skills/rust-refactor-guardian/references/impact-map-template.md`
- Create: `skills/rust-refactor-guardian/assets/rollback-plan.template.md`
- Create: `skills/rust-refactor-guardian/assets/impact-map.template.md`
- Create: `skills/rust-refactor-guardian/assets/refactor-log-entry.template.md`

- [ ] **Step 1: Create the Rust TDD builder with crate-aware testing guidance**

```md
---
name: rust-tdd-builder
description: Implement clear Rust behavior with TDD. Use when behavior is known and tests-first development is required: write a failing unit or integration test, implement the minimal code, rerun tests, refactor, and update indexes.
---

## Workflow

### Red
- add the smallest failing unit or integration test
- keep tests aligned with crate or public API boundaries

### Green
- implement the smallest production change
- avoid widening the public API outside the approved scope
```

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn returns_expected_value() {
        let result = function_under_test();
        assert_eq!(result, expected_value());
    }
}
```

- [ ] **Step 2: Create the Rust bug fixer with root-cause and regression-test templates**

```md
---
name: rust-bug-fixer
description: Fix a specific Rust bug, failing test, compiler error, runtime error, panic, regression, or incorrect behavior. Use for reproduction, root cause analysis, smallest safe fix, regression test, and verification.
---

## Rules

- do not refactor broadly while fixing
- treat ownership, lifetimes, error propagation, and async boundaries as first-class suspects
- preserve public API contracts unless the bug is the contract
```

```rust
#[test]
fn reproduces_the_reported_bug() {
    let err = function_under_test(invalid_input()).unwrap_err();
    assert!(err.to_string().contains("expected message"));
}
```

- [ ] **Step 3: Create the Rust code reviewer and refactor guardian**

Use these anchors:

```md
## Review Priority

1. correctness
2. public API stability
3. ownership and borrowing assumptions
4. error propagation
5. concurrency safety
6. unsafe usage
7. test coverage
8. maintainability
```

```md
## Impact Map Must Include

- files moved
- modules or crates renamed
- exports changed
- visibility changes
- dependency direction changes
- tests affected
- public API risk
- rollback boundary
```

- [ ] **Step 4: Run the readiness check with the full Rust skill set present**

Run:

```bash
rtk bash check-codexminimal.sh
```

Expected:
- command exits `0`
- no optional Rust skill warnings remain
- all Rust skill directories satisfy the same structural checks as NestJS skills

- [ ] **Step 5: Commit the Rust skill set**

```bash
rtk proxy git add skills/rust-tdd-builder skills/rust-bug-fixer skills/rust-code-reviewer skills/rust-refactor-guardian
rtk proxy git commit -m "Add rust execution and review skills"
```

### Task 6: Add Rust Routing And Planner Eval Coverage

**Files:**
- Modify: `evals/task-router-golden-cases.json`
- Modify: `evals/samples/task-router-results.sample.json`
- Modify: `evals/feature-intake-gate-golden-cases.json`
- Modify: `evals/samples/feature-intake-gate-results.sample.json`
- Create: `evals/rust-sdd-planner-golden-cases.json`
- Create: `evals/samples/rust-sdd-planner-results.sample.json`
- Modify: `evals/run-sample-evals.sh`

- [ ] **Step 1: Add a Rust routing case to the task-router eval fixtures**

```json
{
  "name": "rust_bug_fix",
  "input": "The Cargo workspace panics when parsing invalid config. Fix it.",
  "expected": {
    "classification": "bug-fix",
    "primarySkill": "rust-bug-fixer",
    "followUpSkills": ["project-indexer"],
    "responseMode": "standard",
    "contextBudget": "medium",
    "safetyGate": "proceed"
  }
}
```

- [ ] **Step 2: Add a Rust spec-stage case to the feature-intake eval fixtures**

```json
{
  "name": "approved_rust_direction_moves_to_spec",
  "input": "The direction is approved. Write the Rust spec before planning implementation.",
  "expected": {
    "currentStage": "spec",
    "nextSkill": "rust-sdd-planner"
  }
}
```

- [ ] **Step 3: Create the Rust planner golden cases and sample results**

```json
[
  {
    "name": "workspace_feature_spec",
    "input": "Plan a Rust workspace feature that adds a library crate API and updates one binary crate consumer.",
    "expected": {
      "classification": "planner",
      "affectedModules": ["library-crate", "binary-crate"],
      "openQuestionsOrAssumptions": []
    }
  }
]
```

```json
[
  {
    "name": "workspace_feature_spec",
    "actual": {
      "classification": "planner",
      "affectedModules": ["library-crate", "binary-crate"],
      "openQuestionsOrAssumptions": []
    }
  }
]
```

- [ ] **Step 4: Extend the sample-eval runner to execute Rust planner fixtures when present**

```bash
if [[ -f evals/rust-sdd-planner-golden-cases.json && -f evals/samples/rust-sdd-planner-results.sample.json ]]; then
  python3 evals/run-golden-evals.py \
    --cases evals/rust-sdd-planner-golden-cases.json \
    --results evals/samples/rust-sdd-planner-results.sample.json
fi
```

- [ ] **Step 5: Run the sample eval suite**

Run:

```bash
rtk bash evals/run-sample-evals.sh
```

Expected:
- command exits `0`
- existing task-router, feature-intake, and NestJS evals still pass
- the new Rust planner eval executes when its files exist

- [ ] **Step 6: Commit the eval coverage**

```bash
rtk proxy git add evals/task-router-golden-cases.json evals/samples/task-router-results.sample.json evals/feature-intake-gate-golden-cases.json evals/samples/feature-intake-gate-results.sample.json evals/rust-sdd-planner-golden-cases.json evals/samples/rust-sdd-planner-results.sample.json evals/run-sample-evals.sh
rtk proxy git commit -m "Add rust profile eval coverage"
```

### Task 7: Run End-To-End Verification And Install Smoke Tests

**Files:**
- Modify: none
- Test: `install.sh`
- Test: `check-codexminimal.sh`
- Test: `evals/run-sample-evals.sh`

- [ ] **Step 1: Run the full readiness check**

Run:

```bash
rtk bash check-codexminimal.sh
```

Expected:
- exits `0`
- validates core, NestJS, and Rust optional profile surfaces

- [ ] **Step 2: Run the full sample-eval suite**

Run:

```bash
rtk bash evals/run-sample-evals.sh
```

Expected:
- exits `0`
- Rust planner fixtures participate without breaking existing samples

- [ ] **Step 3: Smoke-test install with the Rust profile only in a temporary Codex home**

Run:

```bash
rtk proxy env CODEX_HOME=/tmp/codexminimal-rust-install CODEXMINIMAL_INSTALL_PROFILES=rust bash install.sh
```

Expected:
- output includes `Mode: Core + profiles`
- output includes `Profiles: rust`
- `/tmp/codexminimal-rust-install/skills/rust-sdd-planner` exists

- [ ] **Step 4: Smoke-test combined install with NestJS and Rust**

Run:

```bash
rtk proxy env CODEX_HOME=/tmp/codexminimal-rust-combo CODEXMINIMAL_INSTALL_PROFILES=nestjs,rust bash install.sh
```

Expected:
- output includes `Profiles: nestjs rust` or equivalent combined listing
- both `/tmp/codexminimal-rust-combo/skills/nestjs-sdd-planner` and `/tmp/codexminimal-rust-combo/skills/rust-sdd-planner` exist

- [ ] **Step 5: Capture the final clean state and commit if verification reveals any required adjustments**

Run:

```bash
rtk proxy git status --short
```

Expected:
- no unreviewed drift remains
- if verification required follow-up edits, stage only those edits and commit them with a focused message such as:
```bash
rtk proxy git add <paths>
rtk proxy git commit -m "Fix rust profile verification issues"
```

## Self-Review Checklist

- The plan covers install, docs, routing, detection, five Rust skills, evals, and verification from the approved spec.
- No task assumes `axum`, `tokio`, `tracing`, `thiserror`, or `sea-orm` unless repository evidence supports them.
- Every file named in the approved design appears either in the file map or a task.
- The smoke tests use `/tmp` `CODEX_HOME` paths so the user's real local skill install is not overwritten.
