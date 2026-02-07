#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing bat"

log_info "Updating package lists"
sudo apt-get update

log_info "Installing bat"
sudo apt-get install -y bat

log_info "Installing bat theme"
BAT_THEME_DIR="$HOME/.config/bat/themes"
THEME_NAME="CatppuccinMocha.tmTheme"
THEME_URL="https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme"

mkdir -p "$BAT_THEME_DIR"

if [[ ! -f "$BAT_THEME_DIR/$THEME_NAME" ]]; then
  log_info "Downloading Catppuccin Mocha theme"

  TMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TMP_DIR"' EXIT

  curl -fsSL "$THEME_URL" -o "$TMP_DIR/$THEME_NAME"
  mv "$TMP_DIR/$THEME_NAME" "$BAT_THEME_DIR/$THEME_NAME"
else
  log_info "Theme already exists, skipping download"
fi

log_info "Building bat cache"
batcat cache --build
