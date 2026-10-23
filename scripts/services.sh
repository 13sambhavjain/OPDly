#!/bin/sh
# Manage the local PostgreSQL and Redis that live in ./env.
#
#   sh scripts/services.sh init|start|stop|status
#
# init creates the databases on first use (role and database "opdly",
# development-only password from .env.example) and leaves them running.
set -eu
cd "$(git rev-parse --show-toplevel)"
. scripts/env.sh

RUN="$OPDLY_ENV/run"
LOG="$OPDLY_ENV/log"
REDIS_DATA="$OPDLY_ENV/data/redis"
mkdir -p "$RUN" "$LOG" "$REDIS_DATA"

pg_running() { pg_ctl -D "$PGDATA" status >/dev/null 2>&1; }
redis_running() { redis-cli -p "$REDIS_PORT" ping >/dev/null 2>&1; }

start_postgres() {
  pg_running || pg_ctl -D "$PGDATA" -l "$LOG/postgres.log" -w start >/dev/null
  echo "postgres: running on localhost:$PGPORT"
}

start_redis() {
  if ! redis_running; then
    # Redis only holds short-lived state (D-0006), so nothing is saved to disk.
    redis-server --bind 127.0.0.1 --port "$REDIS_PORT" --dir "$REDIS_DATA" \
      --save "" --appendonly no --daemonize yes \
      --pidfile "$RUN/redis.pid" --logfile "$LOG/redis.log"
    sleep 1
  fi
  echo "redis:    running on localhost:$REDIS_PORT"
}

init_postgres() {
  if [ -f "$PGDATA/PG_VERSION" ]; then return 0; fi
  echo "postgres: creating database cluster in env/data/postgres"
  initdb -D "$PGDATA" -U postgres --encoding=UTF8 --locale=C \
    --auth-local=trust --auth-host=scram-sha-256 >"$LOG/initdb.log"
  cat >>"$PGDATA/postgresql.conf" <<EOF

# OPDly local development
listen_addresses = 'localhost'
port = $PGPORT
unix_socket_directories = '$RUN'
EOF
  start_postgres
  psql -h "$RUN" -U postgres -q -c "CREATE ROLE opdly LOGIN CREATEDB PASSWORD 'opdly'"
  createdb -h "$RUN" -U postgres -O opdly opdly
  echo "postgres: created role and database 'opdly'"
}

case "${1:-status}" in
  init)
    init_postgres
    start_postgres
    start_redis
    ;;
  start)
    start_postgres
    start_redis
    ;;
  stop)
    if pg_running; then pg_ctl -D "$PGDATA" -m fast -w stop >/dev/null; fi
    if redis_running; then redis-cli -p "$REDIS_PORT" shutdown nosave >/dev/null 2>&1 || true; fi
    echo "postgres and redis stopped"
    ;;
  status)
    if pg_running; then echo "postgres: running"; else echo "postgres: stopped"; fi
    if redis_running; then echo "redis:    running"; else echo "redis:    stopped"; fi
    ;;
  *)
    echo "usage: sh scripts/services.sh init|start|stop|status" >&2
    exit 2
    ;;
esac
