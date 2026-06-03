#!/usr/bin/env bash
set -euo pipefail

python3 evals/run-golden-evals.py \
  --cases evals/task-router-golden-cases.json \
  --results evals/samples/task-router-results.sample.json

python3 evals/run-golden-evals.py \
  --cases evals/feature-intake-gate-golden-cases.json \
  --results evals/samples/feature-intake-gate-results.sample.json

python3 evals/run-golden-evals.py \
  --cases evals/project-init-golden-cases.json \
  --results evals/samples/project-init-results.sample.json

python3 evals/run-golden-evals.py \
  --cases evals/project-indexer-golden-cases.json \
  --results evals/samples/project-indexer-results.sample.json

python3 evals/run-golden-evals.py \
  --cases evals/nestjs-sdd-planner-golden-cases.json \
  --results evals/samples/nestjs-sdd-planner-results.sample.json

python3 evals/run-golden-evals.py \
  --cases evals/repo-phase-orchestrator-golden-cases.json \
  --results evals/samples/repo-phase-orchestrator-results.sample.json
