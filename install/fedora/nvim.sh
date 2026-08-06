#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Neovim"

# Neovim itself and clipboard integration for Fedora KDE's Wayland session.
packages=(
  neovim
  wl-clipboard
)

log_info "Installing Neovim and its runtime dependencies"
sudo dnf install -y "${packages[@]}"

NVIM_CONFIG_SOURCE="$PROJECT_ROOT/.config/nvim"
NVIM_CONFIG_TARGET="$HOME/.config/nvim"
mkdir -p "$(dirname "$NVIM_CONFIG_TARGET")"

if [[ -L "$NVIM_CONFIG_TARGET" ]]; then
  rm "$NVIM_CONFIG_TARGET"
elif [[ -e "$NVIM_CONFIG_TARGET" ]]; then
  BACKUP="${NVIM_CONFIG_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  mv "$NVIM_CONFIG_TARGET" "$BACKUP"
  log_info "Backed up existing Neovim configuration to $BACKUP"
fi

ln -s "$NVIM_CONFIG_SOURCE" "$NVIM_CONFIG_TARGET"
log_info "Linked Neovim configuration: $NVIM_CONFIG_TARGET"
