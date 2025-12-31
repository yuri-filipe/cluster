#!/usr/bin/env bash
set -euo pipefail

APP_USER="${APP_USER:-app}"
APP_DB="${APP_DB:-appdb}"
APP_PASS_FILE="/run/secrets/app_password"

if [[ ! -f "$APP_PASS_FILE" ]]; then
  echo "app_password secret nao encontrado em $APP_PASS_FILE" >&2
  exit 1
fi

APP_PASS="$(cat "$APP_PASS_FILE")"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '${APP_USER}') THEN
    CREATE ROLE ${APP_USER} LOGIN PASSWORD '${APP_PASS}';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = '${APP_DB}') THEN
    CREATE DATABASE ${APP_DB} OWNER ${APP_USER};
  END IF;
END
\$\$;

GRANT CONNECT ON DATABASE ${APP_DB} TO ${APP_USER};
EOSQL

# Habilita pg_stat_statements também no appdb
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$APP_DB" <<EOSQL
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
EOSQL
