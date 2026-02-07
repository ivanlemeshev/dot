#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Neovim"

log_info "Installing Neovim package"
brew install nvim

log_info "Configuring Neovim"
NVIM_CONFIG_SOURCE="$PROJECT_ROOT/.config/nvim"
NVIM_CONFIG_TARGET="$HOME/.config/nvim"

mkdir -p "$(dirname "$NVIM_CONFIG_TARGET")"

if [[ -L "$NVIM_CONFIG_TARGET" ]]; then
  log_info "Removing existing symlink at $NVIM_CONFIG_TARGET"
  rm "$NVIM_CONFIG_TARGET"
elif [[ -e "$NVIM_CONFIG_TARGET" ]]; then
  log_info "Backing up existing directory at $NVIM_CONFIG_TARGET"
  BACKUP="$NVIM_CONFIG_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$NVIM_CONFIG_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Neovim configuration"
ln -s "$NVIM_CONFIG_SOURCE" "$NVIM_CONFIG_TARGET"
log_info "Linked Neovim configuration: $NVIM_CONFIG_SOURCE -> $NVIM_CONFIG_TARGET"
