#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Helix"

log_info "Installing Helix package"
brew install helix

log_info "Configuring Helix"
HELIX_SOURCE="$PROJECT_ROOT/.config/helix/config.toml"
HELIX_TARGET="$HOME/.config/helix/config.toml"

if [[ -L "$HELIX_TARGET" ]]; then
  log_info "Removing existing symlink at $HELIX_TARGET"
  rm "$HELIX_TARGET"
elif [[ -e "$HELIX_TARGET" ]]; then
  log_info "Backing up existing file at $HELIX_TARGET"
  BACKUP="$HELIX_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$HELIX_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Helix configuration"
ln -s "$HELIX_SOURCE" "$HELIX_TARGET"
log_info "Linked Vim configuration: $HELIX_SOURCE -> $HELIX_TARGET"

log_info "Linking Helix colorscheme"
COLORSCHEME_SOURCE="$PROJECT_ROOT/.config/helix/themes/custom.toml"
COLORSCHEME_TARGET="$HOME/.config/helix/themes/custom.toml"

mkdir -p "$(dirname "$COLORSCHEME_TARGET")"

if [[ -L "$COLORSCHEME_TARGET" ]]; then
  log_info "Removing existing symlink at $COLORSCHEME_TARGET"
  rm "$COLORSCHEME_TARGET"
elif [[ -e "$COLORSCHEME_TARGET" ]]; then
  log_info "Backing up existing file at $COLORSCHEME_TARGET"
  BACKUP="$COLORSCHEME_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$COLORSCHEME_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

ln -s "$COLORSCHEME_SOURCE" "$COLORSCHEME_TARGET"
log_info "Linked colorscheme: $COLORSCHEME_SOURCE -> $COLORSCHEME_TARGET"
