#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Oh My Posh"

brew install jandedobbeleer/oh-my-posh/oh-my-posh

log_info "Configuring Oh My Posh theme"
OMP_THEME_SOURCE="$PROJECT_ROOT/.config/oh-my-posh/theme.omp.json"
OMP_THEME_TARGET="$HOME/.config/oh-my-posh/theme.omp.json"

mkdir -p "$(dirname "$OMP_THEME_TARGET")"

if [[ -L "$OMP_THEME_TARGET" ]]; then
  log_info "Removing existing symlink at $OMP_THEME_TARGET"
  rm "$OMP_THEME_TARGET"
elif [[ -e "$OMP_THEME_TARGET" ]]; then
  log_info "Backing up existing file at $OMP_THEME_TARGET"
  BACKUP="$OMP_THEME_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$OMP_THEME_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Oh My Posh theme"
ln -s "$OMP_THEME_SOURCE" "$OMP_THEME_TARGET"
log_info "Linked Oh My Posh theme: $OMP_THEME_SOURCE -> $OMP_THEME_TARGET"
