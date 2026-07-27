#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Claude Code"
brew install --cask claude-code

log_info "Configuring Claude Code"
CLAUDE_CODE_SKILLS_SOURCE="$PROJECT_ROOT/.claude/skills"
CLAUDE_CODE_SKILLS_TARGET="$HOME/.claude/skills"

mkdir -p "$(dirname "$CLAUDE_CODE_SKILLS_TARGET")"

if [[ -L "$CLAUDE_CODE_SKILLS_TARGET" ]]; then
  log_info "Removing existing symlink at $CLAUDE_CODE_SKILLS_TARGET"
  rm "$CLAUDE_CODE_SKILLS_TARGET"
elif [[ -e "$CLAUDE_CODE_SKILLS_TARGET" ]]; then
  log_info "Backing up existing directory at $CLAUDE_CODE_SKILLS_TARGET"
  BACKUP="$CLAUDE_CODE_SKILLS_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$CLAUDE_CODE_SKILLS_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Claude Code skills"
ln -s "$CLAUDE_CODE_SKILLS_SOURCE" "$CLAUDE_CODE_SKILLS_TARGET"
log_info "Linked Claude Code skills: $CLAUDE_CODE_SKILLS_SOURCE -> $CLAUDE_CODE_SKILLS_TARGET"
