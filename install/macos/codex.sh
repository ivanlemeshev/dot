#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Codex CLI"

brew install codex

log_info "Configuring Cpdex CLI"
CODEX_CONFIG_SOURCE="$PROJECT_ROOT/.config/codex/config.toml"
CODEX_CONFIG_TARGET="$HOME/.codex/config.toml"

mkdir -p "$(dirname "$CODEX_CONFIG_TARGET")"

if [[ -L "$CODEX_CONFIG_TARGET" ]]; then
  log_info "Removing existing symlink at $CODEX_CONFIG_TARGET"
  rm "$CODEX_CONFIG_TARGET"
elif [[ -e "$CODEX_CONFIG_TARGET" ]]; then
  log_info "Backing up existing directory at $CODEX_CONFIG_TARGET"
  BACKUP="$CODEX_CONFIG_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$CODEX_CONFIG_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Codex CLI configuration"
ln -s "$CODEX_CONFIG_SOURCE" "$CODEX_CONFIG_TARGET"
log_info "Linked Codex CLI configuration: $CODEX_CONFIG_SOURCE -> $CODEX_CONFIG_TARGET"
