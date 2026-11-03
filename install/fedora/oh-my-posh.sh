#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Oh My Posh"

curl -fsSL https://ohmyposh.dev/install.sh | bash -s

OMP_CONFIG_SOURCE="$PROJECT_ROOT/.config/oh-my-posh/theme.omp.json"
OMP_CONFIG_TARGET="$HOME/.config/oh-my-posh/theme.omp.json"
mkdir -p "$(dirname "$OMP_CONFIG_TARGET")"
if [[ -L "$OMP_CONFIG_TARGET" ]]; then
  rm "$OMP_CONFIG_TARGET"
elif [[ -e "$OMP_CONFIG_TARGET" ]]; then
  BACKUP="${OMP_CONFIG_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  mv "$OMP_CONFIG_TARGET" "$BACKUP"
  log_info "Backed up existing Oh My Posh config to $BACKUP"
fi
ln -s "$OMP_CONFIG_SOURCE" "$OMP_CONFIG_TARGET"
log_info "Linked Oh My Posh config: $OMP_CONFIG_TARGET"
