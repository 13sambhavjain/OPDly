#!/bin/sh
# Create (or update) the contained development environment in ./env.
# Safe to re-run. Needs only git, curl and a POSIX shell.
#
#   sh scripts/bootstrap-env.sh
set -eu
cd "$(git rev-parse --show-toplevel)"
. scripts/env.sh

MICROMAMBA="$OPDLY_ENV/bin/micromamba"
mkdir -p "$OPDLY_ENV/bin" "$OPDLY_ENV/cache"

sha256() {
  if command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1"; else sha256sum "$1"; fi | cut -d' ' -f1
}

# 1. micromamba: a single binary, checked against its published checksum.
if [ ! -x "$MICROMAMBA" ]; then
  case "$(uname -s)-$(uname -m)" in
    Darwin-arm64) platform=osx-arm64 ;;
    Darwin-x86_64) platform=osx-64 ;;
    Linux-x86_64) platform=linux-64 ;;
    Linux-aarch64) platform=linux-aarch64 ;;
    *) echo "Unsupported platform: $(uname -s)-$(uname -m)" >&2; exit 1 ;;
  esac
  url="https://github.com/mamba-org/micromamba-releases/releases/latest/download/micromamba-$platform"
  echo "Downloading micromamba ($platform)"
  curl -fsSL -o "$MICROMAMBA.download" "$url"
  expected="$(curl -fsSL "$url.sha256" | cut -d' ' -f1)"
  actual="$(sha256 "$MICROMAMBA.download")"
  if [ "$expected" != "$actual" ]; then
    rm -f "$MICROMAMBA.download"
    echo "micromamba checksum mismatch (expected $expected, got $actual)" >&2
    exit 1
  fi
  mv "$MICROMAMBA.download" "$MICROMAMBA"
  chmod +x "$MICROMAMBA"
fi

# 2. Node, PostgreSQL, Redis and uv from conda-forge.
#    micromamba writes a few files under $HOME (an environments list, a
#    package cache), so it runs with HOME pointed inside ./env.
mm() { HOME="$OPDLY_ENV/home" CONDA_PKGS_DIRS="$MAMBA_ROOT_PREFIX/pkgs" "$MICROMAMBA" "$@"; }
mkdir -p "$OPDLY_ENV/home"
if [ -d "$OPDLY_ENV/tools/conda-meta" ]; then
  mm install --no-rc -y -p "$OPDLY_ENV/tools" -f scripts/env-tools.yml
else
  mm create --no-rc -y -p "$OPDLY_ENV/tools" -f scripts/env-tools.yml
fi

# 3. Python, pinned in .python-version.
uv python install "$(cat .python-version)"

# 4. Local databases (first run only).
sh scripts/services.sh init

echo
echo "Done. In each new terminal run:  source scripts/env.sh"
