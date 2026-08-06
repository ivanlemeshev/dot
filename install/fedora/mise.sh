#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing mise"

curl -fsSL https://mise.run | sh

MISE_BIN="$HOME/.local/bin/mise"
MISE_CONFIG_SOURCE="$PROJECT_ROOT/.config/mise/config.toml"
MISE_CONFIG_TARGET="$HOME/.config/mise/config.toml"
mkdir -p "$(dirname "$MISE_CONFIG_TARGET")"

if [[ -L "$MISE_CONFIG_TARGET" ]]; then
  rm "$MISE_CONFIG_TARGET"
elif [[ -e "$MISE_CONFIG_TARGET" ]]; then
  BACKUP="${MISE_CONFIG_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  mv "$MISE_CONFIG_TARGET" "$BACKUP"
  log_info "Backed up existing mise configuration to $BACKUP"
fi

ln -s "$MISE_CONFIG_SOURCE" "$MISE_CONFIG_TARGET"
"$MISE_BIN" trust "$MISE_CONFIG_TARGET"
"$MISE_BIN" install
log_info "Linked mise configuration: $MISE_CONFIG_TARGET"
