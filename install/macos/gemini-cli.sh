#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Gemini CLI"

MISE_BIN="$HOME/.local/bin/mise"

log_info "Installing Gemini CLI with mise-managed Node"
PATH="$HOME/.local/bin:$PATH" "$MISE_BIN" exec -- npm install -g @google/gemini-cli
