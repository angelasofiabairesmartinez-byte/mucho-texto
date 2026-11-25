#!/usr/bin/env bash
# ============================================================
# Crea la base biblioteca_libreria desde cero con los archivos
# del repo, en este orden:
#   DDL -> Vistas -> Funciones -> Procedimientos -> DML
# Con PRUEBAS=1 ejecuta además base-de-datos/pruebas/*.test.sql
#
# Lo usan el contenedor db-init (docker compose) y el CI.
# Variables: DB_HOST, DB_PORT, DB_USER, MSSQL_SA_PASSWORD
# ============================================================
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-1433}"
DB_USER="${DB_USER:-sa}"
DB_NAME="biblioteca_libreria"
SQLCMD="${SQLCMD:-/opt/mssql-tools18/bin/sqlcmd}"

ejecutar() {
  local archivo="$1" base="$2"
  echo "  -> ${archivo#"$DIR"/}"
  "$SQLCMD" -S "${DB_HOST},${DB_PORT}" -U "$DB_USER" -P "$MSSQL_SA_PASSWORD" \
    -C -b -I -f 65001 -d "$base" -i "$archivo"
}

echo "== Esperando a SQL Server en ${DB_HOST}:${DB_PORT}"
for i in $(seq 1 60); do
  if "$SQLCMD" -S "${DB_HOST},${DB_PORT}" -U "$DB_USER" -P "$MSSQL_SA_PASSWORD" -C -Q "SELECT 1" >/dev/null 2>&1; then
    break
  fi
  sleep 2
  if [ "$i" -eq 60 ]; then echo "SQL Server no respondió"; exit 1; fi
done

echo "== DDL"
ejecutar "$DIR/DDL/000_base_de_datos.sql" master
for f in $(ls "$DIR"/DDL/*.sql | sort | grep -v '/000_'); do ejecutar "$f" "$DB_NAME"; done

for carpeta in Vistas Funciones Procedimientos DML; do
  echo "== $carpeta"
  for f in $(ls "$DIR/$carpeta"/*.sql 2>/dev/null | sort); do ejecutar "$f" "$DB_NAME"; done
done

if [ "${PRUEBAS:-0}" = "1" ]; then
  echo "== Pruebas"
  for f in $(ls "$DIR"/pruebas/*.test.sql 2>/dev/null | sort); do ejecutar "$f" "$DB_NAME"; done
fi

echo "== Base de datos lista"
