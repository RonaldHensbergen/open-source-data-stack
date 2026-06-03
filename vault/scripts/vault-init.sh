#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="${1:-vault}"

echo "==> Waiting for Vault container..."
until docker exec "$CONTAINER_NAME" vault status >/dev/null 2>&1 || docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; do
  sleep 2
done

echo "==> Checking Vault status..."
STATUS_JSON="$(docker exec "$CONTAINER_NAME" vault status -format=json 2>/dev/null || true)"

if echo "$STATUS_JSON" | grep -q '"initialized":true'; then
  echo "Vault already initialized."
else
  echo "==> Initializing Vault..."
  docker exec -it "$CONTAINER_NAME" vault operator init
  echo
  echo "Save the unseal keys and root token securely."
  exit 0
fi

if echo "$STATUS_JSON" | grep -q '"sealed":false'; then
  echo "Vault already unsealed."
else
  echo "Vault is sealed."
  echo "Run this manually with your unseal keys:"
  echo "  docker exec -it $CONTAINER_NAME vault operator unseal"
fi
