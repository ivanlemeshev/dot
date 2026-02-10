#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Vim"

log_info "Installing Vim package"
sudo apt-get install -y vim

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

log_info "Linking Vim colorscheme"
COLORSCHEME_SOURCE="$PROJECT_ROOT/.config/vim/colors/gruvbox-material.vim"
COLORSCHEME_TARGET="$HOME/.config/vim/colors/gruvbox-material.vim"

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

log_info "Creating undo directory"
mkdir -p "$HOME/.vim/undodir"
