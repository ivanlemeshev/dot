#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing OpenCode"

log_info "Installing OpenCode package"
curl -fsSL https://opencode.ai/install | bash

log_info "Configuring OpenCode"
OPENCODE_CONFIG_SOURCE="$PROJECT_ROOT/.config/opencode/opencode.json"
OPENCODE_CONFIG_TARGET="$HOME/.config/opencode/opencode.json"

if [[ -L "$OPENCODE_CONFIG_TARGET" ]]; then
  log_info "Removing existing symlink at $OPENCODE_CONFIG_TARGET"
  rm "$OPENCODE_CONFIG_TARGET"
elif [[ -e "$OPENCODE_CONFIG_TARGET" ]]; then
  log_info "Backing up existing file at $OPENCODE_CONFIG_TARGET"
  BACKUP="$OPENCODE_CONFIG_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$OPENCODE_CONFIG_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for OpenCode configuration"
mkdir -p "$(dirname "$OPENCODE_CONFIG_TARGET")"
ln -s "$OPENCODE_CONFIG_SOURCE" "$OPENCODE_CONFIG_TARGET"
log_info "Linked OpenCode configuration: $OPENCODE_CONFIG_SOURCE -> $OPENCODE_CONFIG_TARGET"
