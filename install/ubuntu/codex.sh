#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/link.sh"

print_section "Installing Codex CLI"

npm i -g @openai/codex

log_info "Configuring Codex"
CODEX_SKILLS_SOURCE="$PROJECT_ROOT/.codex/skills"
CODEX_SKILLS_TARGET="$HOME/.codex/skills"
link_directory "$CODEX_SKILLS_SOURCE" "$CODEX_SKILLS_TARGET" "Codex skills"
