#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
dry_run=false
start_shell=true

for argument in "$@"; do
  case "$argument" in
    --dry-run) dry_run=true ;;
    --no-shell) start_shell=false ;;
    *)
      printf 'Usage: %s [--dry-run] [--no-shell]\n' "${BASH_SOURCE[0]}" >&2
      exit 2
      ;;
  esac
done

if [[ ! -r /etc/os-release ]] || ! . /etc/os-release || [[ "${ID:-}" != ubuntu || "${VERSION_ID:-}" != 26.04 ]]; then
  printf 'This setup requires Ubuntu 26.04.\n' >&2
  exit 1
fi

case "$(uname -m)" in
  x86_64) nvim_arch=x86_64 ;;
  aarch64) nvim_arch=arm64 ;;
  *)
    printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2
    exit 1
    ;;
esac

export PATH="$HOME/.local/bin:/opt/nvim-linux-$nvim_arch/bin:$PATH"
export MISE_CONFIG_DIR="$SCRIPT_DIR"
MISE_CONFIG_LINK="$HOME/.config/mise"

if [[ "$dry_run" == true ]]; then
  if ! command -v mise >/dev/null 2>&1; then
    printf 'Install mise before the dry run.\n' >&2
    exit 1
  fi
  MISE_TRUSTED_CONFIG_PATHS="$SCRIPT_DIR" mise bootstrap --dry-run
  exit 0
fi

if [[ -L "$MISE_CONFIG_LINK" ]]; then
  if [[ "$(readlink -f "$MISE_CONFIG_LINK")" != "$SCRIPT_DIR" ]]; then
    printf 'Mise config link points to another directory: %s\n' "$MISE_CONFIG_LINK" >&2
    exit 1
  fi
elif [[ -e "$MISE_CONFIG_LINK" ]]; then
  printf 'Mise config directory already exists: %s\nMove it before setup.\n' "$MISE_CONFIG_LINK" >&2
  exit 1
fi

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

run_as_root apt-get update
run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl git sudo

if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi
MISE_BIN="$(command -v mise)"

mkdir -p "$HOME/.config"
if [[ ! -L "$MISE_CONFIG_LINK" ]]; then
  ln -s "$SCRIPT_DIR" "$MISE_CONFIG_LINK"
fi
export MISE_CONFIG_DIR="$MISE_CONFIG_LINK"
cd "$SCRIPT_DIR"
"$MISE_BIN" trust

mkdir -p "$HOME/.config/git"
touch "$HOME/.config/git/config.local"
chmod 600 "$HOME/.config/git/config.local"

"$MISE_BIN" bootstrap --yes --only packages,dotfiles,mise-shell-activate
"$MISE_BIN" install
"$MISE_BIN" run configure
"$MISE_BIN" run verify

if [[ "$start_shell" == true ]]; then
  unset MISE_CONFIG_DIR
  exec fish -l
fi
