#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Ghostty"

log_info "Installing ghostty package"
brew install --cask ghostty

log_info "Configuring Ghostty"
GHOSTTY_CONFIG_SOURCE="$PROJECT_ROOT/.config/ghostty/config"
GHOSTTY_CONFIG_TARGET="$HOME/.config/ghostty/config"
GHOSTTY_THEME_SOURCE="$PROJECT_ROOT/.config/ghostty/themes/custom"
GHOSTTY_THEME_TARGET="$HOME/.config/ghostty/themes/custom"

mkdir -p "$(dirname "$GHOSTTY_CONFIG_TARGET")"
mkdir -p "$(dirname "$GHOSTTY_THEME_TARGET")"

if [[ -L "$GHOSTTY_CONFIG_TARGET" ]]; then
  log_info "Removing existing symlink at $GHOSTTY_CONFIG_TARGET"
  rm "$GHOSTTY_CONFIG_TARGET"
elif [[ -e "$GHOSTTY_CONFIG_TARGET" ]]; then
  log_info "Backing up existing file at $GHOSTTY_CONFIG_TARGET"
  BACKUP="$GHOSTTY_CONFIG_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$GHOSTTY_CONFIG_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

if [[ -L "$GHOSTTY_THEME_TARGET" ]]; then
  log_info "Removing existing symlink at $GHOSTTY_THEME_TARGET"
  rm "$GHOSTTY_THEME_TARGET"
elif [[ -e "$GHOSTTY_THEME_TARGET" ]]; then
  log_info "Backing up existing file at $GHOSTTY_THEME_TARGET"
  BACKUP="$GHOSTTY_THEME_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$GHOSTTY_THEME_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Ghostty config"
ln -s "$GHOSTTY_CONFIG_SOURCE" "$GHOSTTY_CONFIG_TARGET"
log_info "Linked Ghostty config: $GHOSTTY_CONFIG_SOURCE -> $GHOSTTY_CONFIG_TARGET"

log_info "Creating symlink for Ghostty theme"
ln -s "$GHOSTTY_THEME_SOURCE" "$GHOSTTY_THEME_TARGET"
log_info "Linked Ghostty theme: $GHOSTTY_THEME_SOURCE -> $GHOSTTY_THEME_TARGET"
