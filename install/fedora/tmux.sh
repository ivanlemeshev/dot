#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing tmux"

sudo dnf install -y tmux xclip

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR/.git" ]]; then
  log_info "tmux plugin manager already exists"
elif [[ -e "$TPM_DIR" ]]; then
  log_error "$TPM_DIR exists but is not a Git checkout"
  exit 1
else
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

TMUX_CONFIG_SOURCE="$PROJECT_ROOT/.config/tmux/.tmux.conf"
TMUX_CONFIG_TARGET="$HOME/.tmux.conf"

if [[ -L "$TMUX_CONFIG_TARGET" ]]; then
  rm "$TMUX_CONFIG_TARGET"
elif [[ -e "$TMUX_CONFIG_TARGET" ]]; then
  BACKUP="${TMUX_CONFIG_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  mv "$TMUX_CONFIG_TARGET" "$BACKUP"
  log_info "Backed up existing tmux configuration to $BACKUP"
fi

ln -s "$TMUX_CONFIG_SOURCE" "$TMUX_CONFIG_TARGET"
"$TPM_DIR/bin/install_plugins"
log_info "Linked tmux configuration: $TMUX_CONFIG_TARGET"
