#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def require(condition: bool, message: str, errors: list[str]) -> None:
    if not condition:
        errors.append(message)


def validate_registry(data: dict, errors: list[str]) -> None:
    require(isinstance(data, dict), "artifact-registry.json must be an object", errors)
    if errors:
        return
    require(data.get("version") == 1, "artifact-registry.json version must be 1", errors)
    require(isinstance(data.get("activeTopic"), str), "artifact-registry.json activeTopic must be a string", errors)
    require(isinstance(data.get("updatedAt"), str), "artifact-registry.json updatedAt must be a string", errors)
    require(isinstance(data.get("artifacts"), list), "artifact-registry.json artifacts must be an array", errors)
    for idx, artifact in enumerate(data.get("artifacts", [])):
        prefix = f"artifact-registry.json artifacts[{idx}]"
        require(isinstance(artifact, dict), f"{prefix} must be an object", errors)
        if not isinstance(artifact, dict):
            continue
        require(isinstance(artifact.get("topic"), str), f"{prefix}.topic must be a string", errors)
        require(isinstance(artifact.get("type"), str), f"{prefix}.type must be a string", errors)
        require(isinstance(artifact.get("path"), str), f"{prefix}.path must be a string", errors)
        require(isinstance(artifact.get("status"), str), f"{prefix}.status must be a string", errors)
        require(isinstance(artifact.get("updatedAt"), str), f"{prefix}.updatedAt must be a string", errors)


def validate_current_work(data: dict, errors: list[str]) -> None:
    require(isinstance(data, dict), "current-work.json must be an object", errors)
    if errors:
        return
    require(data.get("version") == 1, "current-work.json version must be 1", errors)
    string_keys = [
        "topic",
        "status",
        "currentStage",
        "currentPhase",
        "specPath",
        "phasePlanPath",
        "trackerPath",
        "executionWorkflow",
        "lastUpdated",
    ]
    for key in string_keys:
        require(isinstance(data.get(key), str), f"current-work.json {key} must be a string", errors)
    require(isinstance(data.get("blockedBy"), list), "current-work.json blockedBy must be an array", errors)
    require(isinstance(data.get("openQuestions"), list), "current-work.json openQuestions must be an array", errors)


def validate_telemetry(data: dict, errors: list[str]) -> None:
    require(isinstance(data, dict), "telemetry.json must be an object", errors)
    if errors:
        return
    require(data.get("version") == 1, "telemetry.json version must be 1", errors)
    require(isinstance(data.get("updatedAt"), str), "telemetry.json updatedAt must be a string", errors)
    require(isinstance(data.get("sessions"), list), "telemetry.json sessions must be an array", errors)
    require(isinstance(data.get("phaseEvents"), list), "telemetry.json phaseEvents must be an array", errors)


def validate_feedback_ledger(data: dict, errors: list[str]) -> None:
    require(isinstance(data, dict), "feedback-ledger.json must be an object", errors)
    if errors:
        return
    require(data.get("version") == 1, "feedback-ledger.json version must be 1", errors)
    require(isinstance(data.get("updatedAt"), str), "feedback-ledger.json updatedAt must be a string", errors)
    require(
        isinstance(data.get("promotionThreshold"), int) and data.get("promotionThreshold") >= 1,
        "feedback-ledger.json promotionThreshold must be an integer >= 1",
        errors,
    )
    require(isinstance(data.get("issues"), list), "feedback-ledger.json issues must be an array", errors)
    allowed_statuses = {"observed", "watch", "promoted"}
    threshold = data.get("promotionThreshold", 3) if isinstance(data, dict) else 3
    for idx, issue in enumerate(data.get("issues", [])):
        prefix = f"feedback-ledger.json issues[{idx}]"
        require(isinstance(issue, dict), f"{prefix} must be an object", errors)
        if not isinstance(issue, dict):
            continue
        string_keys = [
            "issueKey",
            "description",
            "status",
            "firstSeenAt",
            "lastSeenAt",
            "source",
            "ruleTarget",
            "promotedRuleText",
            "notes",
        ]
        for key in string_keys:
            require(isinstance(issue.get(key), str), f"{prefix}.{key} must be a string", errors)
        require(
            isinstance(issue.get("count"), int) and issue.get("count") >= 0,
            f"{prefix}.count must be a non-negative integer",
            errors,
        )
        require(issue.get("status") in allowed_statuses, f"{prefix}.status must be one of {sorted(allowed_statuses)}", errors)
        require(isinstance(issue.get("affectedArtifacts"), list), f"{prefix}.affectedArtifacts must be an array", errors)
        require(isinstance(issue.get("affectedPaths"), list), f"{prefix}.affectedPaths must be an array", errors)
        if issue.get("status") == "promoted":
            require(bool(issue.get("ruleTarget")), f"{prefix}.ruleTarget must be set when status is promoted", errors)
            require(bool(issue.get("promotedRuleText")), f"{prefix}.promotedRuleText must be set when status is promoted", errors)
        if isinstance(issue.get("count"), int) and issue.get("count", 0) >= threshold:
            require(issue.get("status") == "promoted", f"{prefix}.status must be promoted when count reaches threshold", errors)


def validate_cross_links(repo_root: Path, registry: dict, current_work: dict, errors: list[str]) -> None:
    artifacts = registry.get("artifacts", []) if isinstance(registry, dict) else []
    by_path = {}
    for artifact in artifacts:
        if isinstance(artifact, dict):
            path = artifact.get("path")
            if isinstance(path, str) and path:
                by_path[path] = artifact

    path_mappings = {
        "specPath": "spec",
        "phasePlanPath": "phase-plan",
        "trackerPath": "tracker",
    }
    for field, expected_type in path_mappings.items():
        path_value = current_work.get(field, "")
        if not isinstance(path_value, str) or not path_value:
            continue
        require(path_value in by_path, f"current-work.json {field} must exist in artifact-registry.json", errors)
        artifact = by_path.get(path_value)
        if artifact:
            require(
                artifact.get("type") == expected_type,
                f"current-work.json {field} must point to artifact type {expected_type}",
                errors,
            )
        require((repo_root / path_value).exists(), f"current-work.json {field} path does not exist: {path_value}", errors)

    current_stage = current_work.get("currentStage", "")
    if current_stage in {"phase-plan", "ready-to-execute"}:
        require(bool(current_work.get("phasePlanPath")), "phase-plan or ready-to-execute requires phasePlanPath", errors)
        require(bool(current_work.get("trackerPath")), "phase-plan or ready-to-execute requires trackerPath", errors)
    if current_stage == "ready-to-execute":
        require(bool(current_work.get("executionWorkflow")), "ready-to-execute requires executionWorkflow", errors)


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate docs/codexminimal runtime state files.")
    parser.add_argument("--repo-root", required=True, help="Path to repository root")
    args = parser.parse_args()

    repo_root = Path(args.repo_root)
    runtime_dir = repo_root / "docs" / "codexminimal"
    registry_path = runtime_dir / "artifact-registry.json"
    current_work_path = runtime_dir / "current-work.json"
    telemetry_path = runtime_dir / "telemetry.json"
    feedback_ledger_path = runtime_dir / "feedback-ledger.json"

    missing = [str(path) for path in [registry_path, current_work_path, telemetry_path, feedback_ledger_path] if not path.exists()]
    if missing:
        for item in missing:
            print(f"MISSING {item}")
        return 1

    errors: list[str] = []
    registry = load_json(registry_path)
    current_work = load_json(current_work_path)
    telemetry = load_json(telemetry_path)
    feedback_ledger = load_json(feedback_ledger_path)

    validate_registry(registry, errors)
    validate_current_work(current_work, errors)
    validate_telemetry(telemetry, errors)
    validate_feedback_ledger(feedback_ledger, errors)
    validate_cross_links(repo_root, registry, current_work, errors)

    if errors:
        for error in errors:
            print(f"FAIL {error}")
        return 1

    print("harness runtime state is valid")
    return 0


if __name__ == "__main__":
    sys.exit(main())
