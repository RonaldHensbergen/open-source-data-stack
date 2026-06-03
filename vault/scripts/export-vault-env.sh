#!/usr/bin/env sh
set -eu

until vault status >/dev/null 2>&1; do
  echo "Waiting for Vault..."
  sleep 2
done

export DBT_USER="$(vault kv get -field=username secret/postgres-local)"
export DBT_PASSWORD="$(vault kv get -field=password secret/postgres-local)"
export DBT_HOST="$(vault kv get -field=host secret/postgres-local)"
export DBT_PORT="$(vault kv get -field=port secret/postgres-local)"
export DBT_DBNAME="$(vault kv get -field=dbname secret/postgres-local)"

exec "$@"
