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

log_info "Installing Gruvbox Material theme"
GRUVBOX_DIR="$HOME/.vim/pack/themes/start/gruvbox-material"
if [[ -d "$GRUVBOX_DIR" ]]; then
  log_info "Gruvbox Material theme already installed, updating"
  git -C "$GRUVBOX_DIR" pull
else
  mkdir -p "$HOME/.vim/pack/themes/start"
  git clone https://github.com/sainnhe/gruvbox-material.git "$GRUVBOX_DIR"
fi

# Installing Catppuccin theme (commented out)
# log_info "Installing Catppuccin theme"
# CATPPUCCIN_DIR="$HOME/.vim/pack/themes/start/catppuccin"
# if [[ -d "$CATPPUCCIN_DIR" ]]; then
#   log_info "Catppuccin theme already installed, updating"
#   git -C "$CATPPUCCIN_DIR" pull
# else
#   mkdir -p "$HOME/.vim/pack/themes/start"
#   git clone https://github.com/catppuccin/vim.git "$CATPPUCCIN_DIR"
# fi

log_info "Creating undo directory"
mkdir -p "$HOME/.vim/undodir"
