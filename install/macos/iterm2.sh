#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing iTerm2"

log_info "Installing iTerm2 package"
brew install iterm2

log_info "Disabling the removed custom preferences folder"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool false
