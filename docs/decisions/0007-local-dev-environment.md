# D-0007: A contained local development environment

- **Date:** 2026-10-23
- **Status:** accepted
- **Supersedes:** the local-development part of [D-0006](0006-tech-stack.md) ("Local development runs everything in Docker. LocalStack stands in for S3, SQS and DynamoDB.")

## Context
- The development machine has 8 GB of RAM, no Docker, no PostgreSQL and no Redis. Its system Node.js (20) is past end of life.
- Nothing should be installed system-wide.
- Docker on macOS always runs inside a Linux virtual machine, which reserves 2–4 GB of RAM. On 8 GB, with the backend, the web dev server, a browser and an editor also running, the machine would start swapping.

## Decision
- Everything for local development lives in **`./env`** (git-ignored). Deleting the folder removes it all.
  - **micromamba** (a single checksum-verified binary) installs **Node.js 24, PostgreSQL 17, Redis and uv** from conda-forge into `env/tools`.
  - **uv** installs **Python 3.14.7** (pinned in `.python-version`) and manages the virtualenv in `env/venv`.
  - All caches, global installs and database data are kept inside `./env`. micromamba runs with `HOME` pointed inside `./env`, because it otherwise writes to the home folder.
- `scripts/bootstrap-env.sh` creates the environment, `scripts/env.sh` activates it in a shell, and `scripts/services.sh` starts and stops the databases. See [development](../development.md).
- **Docker is used in CI and deployment**, not on the development machine. GitHub Actions builds and tests the images.
- **moto** (a Python package) stands in for S3, SQS and DynamoDB locally, in place of LocalStack.

## Consequences
- Local development runs native macOS processes, while production runs Linux containers. CI is where the containers get tested.
- Python 3.15 is a release candidate as of Oct 2026. Moving to it once Django and the other dependencies publish builds for it is a one-line change.
- Windows needs WSL; the scripts are POSIX shell.
- With 8 GB of RAM, a local vision model (for example Qwen3-VL 4B, about 6 GB) can't run on this machine. During development, extraction uses an external provider with made-up documents only ([D-0004](0004-automatic-assistance-scope.md)).

## Alternatives considered
- **Docker Desktop:** a system-wide app (about 2 GB, needs admin rights), and the VM's memory use is too much for 8 GB.
- **Colima plus the Docker CLI inside `./env`:** containable, but has the same VM memory cost. It can be added later to debug an image locally.
- **Homebrew:** installs PostgreSQL, Redis and Node system-wide.
