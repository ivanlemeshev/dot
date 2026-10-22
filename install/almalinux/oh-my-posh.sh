#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Oh My Posh"

curl -fsSL https://ohmyposh.dev/install.sh | bash -s

OMP_THEME_SOURCE="$PROJECT_ROOT/.config/oh-my-posh/theme.omp.json"
OMP_THEME_TARGET="$HOME/.config/oh-my-posh/theme.omp.json"
mkdir -p "$(dirname "$OMP_THEME_TARGET")"

if [[ -L "$OMP_THEME_TARGET" ]]; then
  rm "$OMP_THEME_TARGET"
elif [[ -e "$OMP_THEME_TARGET" ]]; then
  BACKUP="${OMP_THEME_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  mv "$OMP_THEME_TARGET" "$BACKUP"
  log_info "Backed up existing Oh My Posh theme to $BACKUP"
fi

ln -s "$OMP_THEME_SOURCE" "$OMP_THEME_TARGET"
log_info "Linked Oh My Posh theme: $OMP_THEME_TARGET"
