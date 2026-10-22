#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Vim"

log_info "Installing Vim package"
sudo dnf install -y vim-enhanced

VIMRC_SOURCE="$PROJECT_ROOT/.config/vim/.vimrc"
VIMRC_TARGET="$HOME/.vimrc"

if [[ -L "$VIMRC_TARGET" ]]; then
  rm "$VIMRC_TARGET"
elif [[ -e "$VIMRC_TARGET" ]]; then
  BACKUP="${VIMRC_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  mv "$VIMRC_TARGET" "$BACKUP"
  log_info "Backed up existing Vim configuration to $BACKUP"
fi

ln -s "$VIMRC_SOURCE" "$VIMRC_TARGET"
mkdir -p "$HOME/.vim/undodir"
log_info "Linked Vim configuration: $VIMRC_TARGET"
