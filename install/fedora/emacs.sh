#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Emacs"

# This package provides the graphical and terminal Emacs clients.
sudo dnf install -y emacs

EMACS_CONFIG_SOURCE="$PROJECT_ROOT/.config/emacs"
EMACS_CONFIG_TARGET="$HOME/.config/emacs"
mkdir -p "$(dirname "$EMACS_CONFIG_TARGET")"

if [[ -L "$EMACS_CONFIG_TARGET" ]]; then
  rm "$EMACS_CONFIG_TARGET"
elif [[ -e "$EMACS_CONFIG_TARGET" ]]; then
  BACKUP="$EMACS_CONFIG_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$EMACS_CONFIG_TARGET" "$BACKUP"
  log_info "Backed up existing Emacs configuration to $BACKUP"
fi

ln -s "$EMACS_CONFIG_SOURCE" "$EMACS_CONFIG_TARGET"
log_info "Linked Emacs configuration: $EMACS_CONFIG_TARGET"
