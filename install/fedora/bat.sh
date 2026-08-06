#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing bat"

sudo dnf install -y bat

BAT_THEME_SOURCE="$PROJECT_ROOT/.config/bat/themes/custom.tmTheme"
BAT_THEME_TARGET="$HOME/.config/bat/themes/custom.tmTheme"
mkdir -p "$(dirname "$BAT_THEME_TARGET")"

if [[ -L "$BAT_THEME_TARGET" ]]; then
  rm "$BAT_THEME_TARGET"
elif [[ -e "$BAT_THEME_TARGET" ]]; then
  BACKUP="${BAT_THEME_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  mv "$BAT_THEME_TARGET" "$BACKUP"
  log_info "Backed up existing bat theme to $BACKUP"
fi

ln -s "$BAT_THEME_SOURCE" "$BAT_THEME_TARGET"
bat cache --build
log_info "Linked bat theme: $BAT_THEME_TARGET"
