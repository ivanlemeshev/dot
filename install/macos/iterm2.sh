#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing iTerm2"

log_info "Installing iTerm2 package"
brew install iterm2

log_info "Configuring the Tomorrow Night profile"
ITERM_PROFILE_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
ITERM_PROFILE_SOURCE="$PROJECT_ROOT/macos/iterm2/TomorrowNight.json"
ITERM_PROFILE_TARGET="$ITERM_PROFILE_DIR/TomorrowNight.json"

# NOTE: The legacy directory link points into the repository.
if [[ -L "$ITERM_PROFILE_DIR" ]] && \
  [[ "$(readlink "$ITERM_PROFILE_DIR")" == "$PROJECT_ROOT/macos/iterm2" ]]; then
  unlink "$ITERM_PROFILE_DIR"
fi

mkdir -p "$ITERM_PROFILE_DIR"
if [[ -L "$ITERM_PROFILE_TARGET" ]] && \
  [[ "$(readlink "$ITERM_PROFILE_TARGET")" == "$ITERM_PROFILE_SOURCE" ]]; then
  log_info "iTerm2 profile already linked: $ITERM_PROFILE_TARGET"
else
  if [[ -L "$ITERM_PROFILE_TARGET" ]]; then
    unlink "$ITERM_PROFILE_TARGET"
  elif [[ -e "$ITERM_PROFILE_TARGET" ]]; then
    # NOTE: iTerm2 must not load the backup as another dynamic profile.
    ITERM_PROFILE_BACKUP="$(dirname "$ITERM_PROFILE_DIR")/TomorrowNight.json.backup.$(date +%Y%m%d%H%M%S)"
    mv "$ITERM_PROFILE_TARGET" "$ITERM_PROFILE_BACKUP"
    log_info "Backed up iTerm2 profile to $ITERM_PROFILE_BACKUP"
  fi
  ln -s "$ITERM_PROFILE_SOURCE" "$ITERM_PROFILE_TARGET"
  log_info "Linked iTerm2 profile: $ITERM_PROFILE_TARGET"
fi

defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool false
defaults write com.googlecode.iterm2 "Default Bookmark Guid" \
  -string "b2f196a0-9822-4f69-8ce9-73f2de6b4371"
