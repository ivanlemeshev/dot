#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dry_run=false

case "${1:-}" in
  "") ;;
  --dry-run) dry_run=true ;;
  *)
    printf 'Usage: %s [--dry-run]\n' "${BASH_SOURCE[0]}" >&2
    exit 2
    ;;
esac

run_as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    printf 'Run this script as root or install sudo.\n' >&2
    exit 1
  fi
}

if [[ ! -r /etc/os-release ]] || ! . /etc/os-release || [[ "${ID:-}" != ubuntu ]]; then
  printf 'This setup supports Ubuntu.\n' >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1 || ! dpkg-query -W ca-certificates >/dev/null 2>&1; then
  run_as_root apt-get update
  run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl git
fi

run_as_root apt-get update
run_as_root env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

if ! command -v mise >/dev/null 2>&1 && [[ ! -x "$HOME/.local/bin/mise" ]]; then
  curl -fsSL https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"
MISE_BIN="$(command -v mise || printf '%s' "$HOME/.local/bin/mise")"
MISE_CONFIG_SOURCE="$SCRIPT_DIR"
MISE_CONFIG_LINK="$HOME/.config/mise"
export MISE_CONFIG_DIR="$MISE_CONFIG_SOURCE"

cd "$SCRIPT_DIR"
"$MISE_BIN" trust

if [[ "$dry_run" == true ]]; then
  "$MISE_BIN" bootstrap --dry-run
  exit 0
fi

mkdir -p "$HOME/.config"

if [[ -L "$MISE_CONFIG_LINK" ]]; then
  if [[ "$(readlink -f "$MISE_CONFIG_LINK")" != "$(readlink -f "$MISE_CONFIG_SOURCE")" ]]; then
    printf 'Mise config link points to another directory: %s\n' "$MISE_CONFIG_LINK" >&2
    exit 1
  fi
elif [[ -e "$MISE_CONFIG_LINK" ]]; then
  printf 'Mise config directory already exists: %s\nMove it before setup.\n' "$MISE_CONFIG_LINK" >&2
  exit 1
else
  ln -s "$MISE_CONFIG_SOURCE" "$MISE_CONFIG_LINK"
fi

export MISE_CONFIG_DIR="$MISE_CONFIG_LINK"

mkdir -p "$HOME/.config/git"
touch "$HOME/.config/git/config.local"
chmod 600 "$HOME/.config/git/config.local"

"$MISE_BIN" bootstrap --yes
"$MISE_BIN" install
"$MISE_BIN" run configure
"$MISE_BIN" run configure:cleanup

case "$(uname -m)" in
  x86_64) nvim_arch=x86_64 ;;
  aarch64) nvim_arch=arm64 ;;
esac

export PATH="/opt/nvim-linux-$nvim_arch/bin:$PATH"
"$MISE_BIN" run verify

unset MISE_CONFIG_DIR
exec fish -l
