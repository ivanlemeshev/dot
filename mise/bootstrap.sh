#!/usr/bin/env bash

set -euo pipefail

show_banner() {
  if [ "${DOTFILES_BANNER:-}" != 1 ] && [ ! -t 1 ]; then
    return
  fi

  local can_reveal=0 column cursor_up="" frame green="" hide_cursor=""
  local line line_index reset="" show_cursor="" terminal_width="" width=0
  local -a logo=(
    '          _       _    __ _ _'
    '       __| | ___ | |_ / _(_) | ___  ___'
    '      / _` |/ _ \| __| |_| | |/ _ \/ __|'
    "     | (_| | (_) | |_|  _| | |  __/\\__ \\"
    '    . \__,_|\___/ \__|_| |_|_|\___||___/'
    ''
    '    > own your shell. shape your system.'
  )
  local -a spinner=('|' '/' '-' "\\")

  if [ -z "${NO_COLOR:-}" ]; then
    if command -v tput >/dev/null 2>&1; then
      green="$(tput setaf 2 2>/dev/null || true)"
      reset="$(tput sgr0 2>/dev/null || true)"
    fi
    green="${green:-$'\033[32m'}"
    reset="${reset:-$'\033[0m'}"
  fi

  for line in "${logo[@]}"; do
    if [ "${#line}" -gt "$width" ]; then
      width="${#line}"
    fi
  done

  if [ -t 1 ] && [ "${TERM:-}" != dumb ] && command -v tput >/dev/null 2>&1; then
    terminal_width="$(tput cols 2>/dev/null || true)"
    case "$terminal_width" in
      '' | *[!0-9]*) ;;
      *)
        if [ "$terminal_width" -lt "$width" ]; then
          logo=('.dotfiles' '> own your shell.')
          width="${#logo[1]}"
        fi
        ;;
    esac

    cursor_up="$(tput cuu "${#logo[@]}" 2>/dev/null || true)"
    hide_cursor="$(tput civis 2>/dev/null || true)"
    show_cursor="$(tput cnorm 2>/dev/null || true)"
    if [ -n "$cursor_up" ]; then
      can_reveal=1
    fi
  fi

  printf '\n'

  if [ "$can_reveal" -eq 1 ]; then
    trap 'printf "%s" "$show_cursor"' EXIT
    trap 'printf "%s" "$show_cursor"; exit 130' HUP INT TERM
    printf '%s' "$hide_cursor"

    for ((column = 1; column <= width; column++)); do
      for line_index in "${!logo[@]}"; do
        printf '%s%s%s\n' "$green" "${logo[$line_index]:0:$column}" "$reset"
      done
      sleep 0.06
      if [ "$column" -lt "$width" ]; then
        printf '%s' "$cursor_up"
      fi
    done

    sleep 0.5
    printf '%s' "$show_cursor"
    trap - EXIT HUP INT TERM
    printf '\n%sPreparing your environment...%s\n\n' "$green" "$reset"
  else
    for line in "${logo[@]}"; do
      printf '%s%s%s\n' "$green" "$line" "$reset"
    done
    printf '\n'
  fi

  if [ "$can_reveal" -eq 0 ] && [ -t 1 ] && [ "${TERM:-}" != dumb ]; then
    for frame in {0..14}; do
      printf '\r%s[%s] Preparing your environment...%s' \
        "$green" "${spinner[$((frame % ${#spinner[@]}))]}" "$reset"
      sleep 0.2
    done
    printf '\r%s[+] Preparing your environment...%s\n\n' "$green" "$reset"
  elif [ "$can_reveal" -eq 0 ]; then
    printf '%sPreparing your environment...%s\n\n' "$green" "$reset"
  fi
}

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

show_banner

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

"$MISE_BIN" bootstrap --yes --only packages,dotfiles
"$MISE_BIN" install
"$MISE_BIN" run configure
"$MISE_BIN" run verify

if [[ "$start_shell" == true ]]; then
  unset MISE_CONFIG_DIR
  exec fish -l
fi
