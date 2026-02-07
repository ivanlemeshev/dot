#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Neovim"

NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
NVIM_URL="https://github.com/neovim/neovim/releases/latest/download"
NVIM_INSTALL_DIR="/opt/nvim-linux-x86_64"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

log_info "Downloading Neovim"
curl -fsSL "$NVIM_URL/$NVIM_ARCHIVE" -o "$TMP_DIR/$NVIM_ARCHIVE"

log_info "Installing Neovim to ${NVIM_INSTALL_DIR}"
if [[ -d "$NVIM_INSTALL_DIR" ]]; then
  log_info "Removing existing installation"
  sudo rm -rf "$NVIM_INSTALL_DIR"
fi

sudo tar -C /opt -xzf "$TMP_DIR/$NVIM_ARCHIVE"

log_info "Configuring Neovim"
NVIM_CONFIG_SOURCE="$PROJECT_ROOT/.config/nvim"
NVIM_CONFIG_TARGET="$HOME/.config/nvim"

# Create parent directory if it doesn't exist
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
