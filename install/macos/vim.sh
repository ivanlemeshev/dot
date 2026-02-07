#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Vim"

log_info "Installing Vim package"
brew install vim

log_info "Configuring Vim"
VIMRC_SOURCE="$PROJECT_ROOT/.config/vim/.vimrc"
VIMRC_TARGET="$HOME/.vimrc"

if [[ -L "$VIMRC_TARGET" ]]; then
  log_info "Removing existing symlink at $VIMRC_TARGET"
  rm "$VIMRC_TARGET"
elif [[ -e "$VIMRC_TARGET" ]]; then
  log_info "Backing up existing file at $VIMRC_TARGET"
  BACKUP="$VIMRC_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$VIMRC_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Vim configuration"
ln -s "$VIMRC_SOURCE" "$VIMRC_TARGET"
log_info "Linked Vim configuration: $VIMRC_SOURCE -> $VIMRC_TARGET"
