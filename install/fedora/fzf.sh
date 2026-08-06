#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing fzf"

FZF_DIR="$HOME/.fzf"

if [[ -d "$FZF_DIR/.git" ]]; then
  log_info "Updating fzf"
  git -C "$FZF_DIR" pull --ff-only
elif [[ -e "$FZF_DIR" ]]; then
  log_error "$FZF_DIR exists but is not an fzf Git checkout"
  exit 1
else
  log_info "Cloning fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
fi

log_info "Installing fzf binary"
"$FZF_DIR/install" --bin --no-update-rc --no-bash --no-zsh --no-fish

mkdir -p "$HOME/.local/bin"
ln -sf "$FZF_DIR/bin/fzf" "$HOME/.local/bin/fzf"
log_info "Linked fzf in ~/.local/bin"
