# Development

Everything for local development lives in `./env`. Nothing is installed system-wide. The reasons are in [D-0007](decisions/0007-local-dev-environment.md).

## Requirements
macOS or Linux (on Windows, use WSL), `git`, `curl` and a POSIX shell.

## First-time setup
```sh
sh scripts/bootstrap-env.sh
```
This downloads micromamba and installs Node.js 24, PostgreSQL 17, Redis, uv and Python 3.14.7 into `./env`. It then creates the local database (role and database `opdly`) and starts PostgreSQL and Redis. It is safe to re-run.

Then copy the local settings:
```sh
cp .env.example .env
```

## In every new terminal
```sh
source scripts/env.sh
```
This puts the tools in `./env` first on your `PATH` and keeps all caches inside `./env`.

## Databases
```sh
sh scripts/services.sh start    # PostgreSQL on localhost:5432, Redis on localhost:6379
sh scripts/services.sh status
sh scripts/services.sh stop
```
- **PostgreSQL:** data is kept in `env/data/postgres`.
- **Redis:** nothing is saved to disk, because it only holds short-lived state.

## What lives where

| Path | Contents |
|---|---|
| `env/bin` | micromamba, Python launchers |
| `env/tools` | Node.js, npm, PostgreSQL, Redis, uv |
| `env/python` | Python installations managed by uv |
| `env/venv` | The project virtualenv |
| `env/data` | Database files |
| `env/cache`, `env/mamba` | Package caches |
| `env/log`, `env/run` | Service logs, sockets and PID files |

## Removing everything
```sh
sh scripts/services.sh stop
rm -rf env
```
