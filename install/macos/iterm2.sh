#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing iTerm2"

log_info "Installing iTerm2 package"
brew install iterm2

log_info "Setting iTerm2 preferences to use custom directory"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$PROJECT_ROOT/macos/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
