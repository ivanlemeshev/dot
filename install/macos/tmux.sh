#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing tmux"

log_info "Installing tmux package"
brew install tmux

log_info "Installing tmux plugin manager (tpm)"
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
  log_info "tpm already exists at $TPM_DIR"
else
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  log_info "Cloned tpm into $TPM_DIR"
fi

log_info "Configuring tmux"
TMUX_CONFIG_SOURCE="$PROJECT_ROOT/.config/tmux/.tmux.conf"
TMUX_CONFIG_TARGET="$HOME/.tmux.conf"

if [[ -L "$TMUX_CONFIG_TARGET" ]]; then
  log_info "Removing existing symlink at $TMUX_CONFIG_TARGET"
  rm "$TMUX_CONFIG_TARGET"
elif [[ -e "$TMUX_CONFIG_TARGET" ]]; then
  log_info "Backing up existing file at $TMUX_CONFIG_TARGET"
  BACKUP="$TMUX_CONFIG_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$TMUX_CONFIG_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for tmux configuration"
ln -s "$TMUX_CONFIG_SOURCE" "$TMUX_CONFIG_TARGET"
log_info "Linked tmux configuration: $TMUX_CONFIG_SOURCE -> $TMUX_CONFIG_TARGET"

log_info "Installing tmux plugins"
"$TPM_DIR/bin/install_plugins"
