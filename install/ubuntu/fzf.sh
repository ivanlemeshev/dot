#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing fzf"

FZF_DIR="$HOME/.fzf"

if [[ -d "$FZF_DIR" ]]; then
  log_info "fzf directory exists, updating"
  git -C "$FZF_DIR" pull
else
  log_info "Cloning fzf repository"
  git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
fi

log_info "Installing fzf binary and shell extensions"
"$FZF_DIR/install" --bin --no-update-rc --no-bash --no-zsh --no-fish

log_info "Creating fzf symlink in ~/.local/bin"
mkdir -p "$HOME/.local/bin"
ln -sf "$FZF_DIR/bin/fzf" "$HOME/.local/bin/fzf"

if command -v fzf &>/dev/null; then
  FZF_VERSION=$(fzf --version | awk '{print $1}')
  log_info "fzf installed successfully: version $FZF_VERSION"
else
  log_error "fzf installation failed"
  exit 1
fi
