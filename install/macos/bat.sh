#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing bat"

log_info "Installing bat package"
brew install bat

log_info "Installing custom-dark theme"
BAT_THEME_SOURCE="$PROJECT_ROOT/.config/bat/themes/custom-dark.tmTheme"
BAT_THEME_DIR="$(bat --config-dir)/themes"
BAT_THEME_TARGET="$BAT_THEME_DIR/custom-dark.tmTheme"

mkdir -p "$BAT_THEME_DIR"

if [[ -L "$BAT_THEME_TARGET" ]]; then
  log_info "Removing existing symlink at $BAT_THEME_TARGET"
  rm "$BAT_THEME_TARGET"
elif [[ -e "$BAT_THEME_TARGET" ]]; then
  log_info "Backing up existing file at $BAT_THEME_TARGET"
  BACKUP="$BAT_THEME_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$BAT_THEME_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

ln -s "$BAT_THEME_SOURCE" "$BAT_THEME_TARGET"
log_info "Linked: $BAT_THEME_SOURCE -> $BAT_THEME_TARGET"

log_info "Rebuilding bat cache"
bat cache --build
