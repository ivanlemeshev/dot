#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Codex"
curl -fsSL https://chatgpt.com/codex/install.sh | sh

log_info "Configuring Codex"
CODEX_SKILLS_SOURCE="$PROJECT_ROOT/.codex/skills"
CODEX_SKILLS_TARGET="$HOME/.codex/skills"

mkdir -p "$(dirname "$CODEX_SKILLS_TARGET")"

if [[ -L "$CODEX_SKILLS_TARGET" ]]; then
  log_info "Removing existing symlink at $CODEX_SKILLS_TARGET"
  rm "$CODEX_SKILLS_TARGET"
elif [[ -e "$CODEX_SKILLS_TARGET" ]]; then
  log_info "Backing up existing directory at $CODEX_SKILLS_TARGET"
  BACKUP="$CODEX_SKILLS_TARGET.backup.$(date +%Y%m%d%H%M%S)"
  mv "$CODEX_SKILLS_TARGET" "$BACKUP"
  log_info "Created backup: $BACKUP"
fi

log_info "Creating symlink for Codex skills"
ln -s "$CODEX_SKILLS_SOURCE" "$CODEX_SKILLS_TARGET"
log_info "Linked Codex skills: $CODEX_SKILLS_SOURCE -> $CODEX_SKILLS_TARGET"
