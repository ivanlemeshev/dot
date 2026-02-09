#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing fish"

log_info "Installing fish package"
brew install fish

log_info "Configuring fish"
FISH_CONFIG_SOURCE="$PROJECT_ROOT/.config/fish/config.fish"
FISH_CONFIG_TARGET="$HOME/.config/fish/config.fish"

mkdir -p "$(dirname "$FISH_CONFIG_TARGET")"

if [[ -L "$FISH_CONFIG_TARGET" ]]; then
  log_info "Removing existing symlink at $FISH_CONFIG_TARGET"
  rm "$FISH_CONFIG_TARGET"
elif [[ -e "$FISH_CONFIG_TARGET" ]]; then
  log_info "Backing up existing file at $FISH_CONFIG_TARGET"
  BACKUP="$FISH_CONFIG_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$FISH_CONFIG_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Fish configuration"
ln -s "$FISH_CONFIG_SOURCE" "$FISH_CONFIG_TARGET"
log_info "Linked Fish configuration: $FISH_CONFIG_SOURCE -> $FISH_CONFIG_TARGET"

log_info "Installing Fisher plugin manager"
fish -c "curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

log_info "Installing fzf.fish plugin"
fish -c "fisher install PatrickF1/fzf.fish"

log_info "Installing gruvbox theme for fish"
fish -c "fisher install Jomik/fish-gruvbox"

# Catppuccin theme (commented out)
# log_info "Installing catppuccin theme for fish"
# fish -c "fisher install catppuccin/fish"

log_info "Changing default shell to Fish"
sudo chsh -s "$(which fish)" "$(whoami)"
