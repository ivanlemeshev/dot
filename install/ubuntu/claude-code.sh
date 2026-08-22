#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/link.sh"

print_section "Installing Claude Code"

curl -fsSL https://claude.ai/install.sh | bash

log_info "Configuring Claude Code"
CLAUDE_CODE_SKILLS_SOURCE="$PROJECT_ROOT/.claude/skills"
CLAUDE_CODE_SKILLS_TARGET="$HOME/.claude/skills"
link_directory "$CLAUDE_CODE_SKILLS_SOURCE" "$CLAUDE_CODE_SKILLS_TARGET" "Claude Code skills"
