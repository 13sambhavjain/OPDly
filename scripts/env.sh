# Use the project's contained development environment in this shell:
#
#   source scripts/env.sh
#
# Tools, databases and caches all live in ./env (git-ignored). Nothing is
# installed system-wide; deleting ./env removes everything.

OPDLY_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
export OPDLY_ROOT
export OPDLY_ENV="$OPDLY_ROOT/env"

# Node, PostgreSQL, Redis and uv come from conda-forge via micromamba.
export MAMBA_ROOT_PREFIX="$OPDLY_ENV/mamba"

# Python and the project virtualenv are managed by uv.
export UV_PYTHON_INSTALL_DIR="$OPDLY_ENV/python"
export UV_PYTHON_BIN_DIR="$OPDLY_ENV/bin"
export UV_PYTHON_PREFERENCE=only-managed
export UV_PROJECT_ENVIRONMENT="$OPDLY_ENV/venv"
export UV_TOOL_DIR="$OPDLY_ENV/uv-tools"
export UV_TOOL_BIN_DIR="$OPDLY_ENV/bin"

# Caches and global installs stay inside ./env too.
export XDG_CACHE_HOME="$OPDLY_ENV/cache"
export UV_CACHE_DIR="$OPDLY_ENV/cache/uv"
export PIP_CACHE_DIR="$OPDLY_ENV/cache/pip"
export npm_config_cache="$OPDLY_ENV/cache/npm"
export npm_config_prefix="$OPDLY_ENV/npm-global"

# Local services (see scripts/services.sh).
export PGDATA="$OPDLY_ENV/data/postgres"
export PGHOST=localhost
export PGPORT=5432
export REDIS_PORT=6379

export PATH="$OPDLY_ENV/venv/bin:$OPDLY_ENV/tools/bin:$OPDLY_ENV/npm-global/bin:$OPDLY_ENV/bin:$PATH"
