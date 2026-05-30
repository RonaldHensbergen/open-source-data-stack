#!/usr/bin/env bash
set -euo pipefail

STATE_FILE=".docker-build.hash"
CONTEXTS=(airflow db python_base)

docker network create open-source-data-stack 2>/dev/null || true

# Hash: Dockerfile + all tracked files under each context dir
HASH="$(
  {
    for d in "${CONTEXTS[@]}"; do
      git ls-files -z -- "$d" \
        | xargs -0 -I{} shasum -a 256 "{}"
    done
  } | shasum -a 256 | awk '{print $1}'
)"

PREV_HASH="$(cat "$STATE_FILE" 2>/dev/null || true)"

if [[ "$HASH" != "$PREV_HASH" ]]; then
  echo "Build inputs changed -> building"
  export DOCKER_BUILDKIT=1
  export COMPOSE_DOCKER_CLI_BUILD=1
  docker compose -f docker-compose.yml build --pull
  echo "$HASH" > "$STATE_FILE"
else
  echo "No build input changes -> skipping build"
fi

docker compose -f docker-compose.yml -f docker-compose-superset.yml up -d
