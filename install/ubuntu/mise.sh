#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing mise"

log_info "Downloading and installing mise"
curl -fsSL https://mise.run | sh

log_info "Configuring mise"
MISE_CONFIG_SOURCE="$PROJECT_ROOT/.config/mise/config.toml"
MISE_CONFIG_TARGET="$HOME/.config/mise/config.toml"

if [[ -e "$MISE_CONFIG_TARGET" ]]; then
  if [[ -L "$MISE_CONFIG_TARGET" ]]; then
    log_info "Removing existing symlink at $MISE_CONFIG_TARGET"
    rm "$MISE_CONFIG_TARGET"
  elif [[ -f "$MISE_CONFIG_TARGET" ]]; then
    log_info "Backing up existing file at $MISE_CONFIG_TARGET"
    BACKUP="$MISE_CONFIG_TARGET.backup.$(date +%Y%m%d%H%M%S)"
    mv "$MISE_CONFIG_TARGET" "$BACKUP"
    log_info "Created backup: $BACKUP"
  fi
fi

log_info "Creating symlink for mise configuration"
mkdir -p "$(dirname "$MISE_CONFIG_TARGET")"
ln -s "$MISE_CONFIG_SOURCE" "$MISE_CONFIG_TARGET"
log_info "Linked mise configuration: $MISE_CONFIG_SOURCE -> $MISE_CONFIG_TARGET"

log_info "Installing mise tools"
"$HOME/.local/bin/mise" trust
"$HOME/.local/bin/mise" install
