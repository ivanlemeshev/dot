#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/link.sh"

print_section "Installing iTerm2"

log_info "Installing iTerm2 package"
brew install iterm2

log_info "Configuring the Tomorrow Night profile"
link_directory "$PROJECT_ROOT/macos/iterm2" \
  "$HOME/Library/Application Support/iTerm2/DynamicProfiles" "iTerm2 profiles"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool false
defaults write com.googlecode.iterm2 "Default Bookmark Guid" \
  -string "b2f196a0-9822-4f69-8ce9-73f2de6b4371"
