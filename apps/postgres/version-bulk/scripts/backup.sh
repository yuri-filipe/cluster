#!/usr/bin/env bash
set -euo pipefail

PASS_FILE="/run/secrets/postgres_password"
[[ -f "$PASS_FILE" ]] || { echo "secret postgres_password nao encontrado"; exit 1; }

export PGPASSWORD="$(cat "$PASS_FILE")"

RETENTION_DAYS="${RETENTION_DAYS:-7}"

mkdir -p /backups

while true; do
  ts="$(date +%Y%m%d-%H%M%S)"
  dir="/backups/${ts}"
  mkdir -p "$dir"

  echo "[${ts}] Dump globals..."
  pg_dumpall --globals-only > "${dir}/globals.sql"

  echo "[${ts}] Listando databases..."
  dbs="$(psql -Atc "SELECT datname FROM pg_database WHERE datistemplate = false ORDER BY 1;")"

  for db in $dbs; do
    echo "[${ts}] Dump database: ${db}"
    pg_dump -Fc -Z 6 -f "${dir}/${db}.dump" "${db}"
  done

  echo "[${ts}] Retencao: apagando backups com mais de ${RETENTION_DAYS} dias..."
  find /backups -maxdepth 1 -type d -name "20*" -mtime +"${RETENTION_DAYS}" -exec rm -rf {} +

  echo "[${ts}] OK. Dormindo 24h."
  sleep 86400
done
