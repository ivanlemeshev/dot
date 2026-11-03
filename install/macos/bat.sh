#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/link.sh"

print_section "Installing bat"

log_info "Installing bat package"
brew install bat

BAT_CONFIG_DIR="$(bat --config-dir)"
link_directory "$PROJECT_ROOT/.config/bat" "$BAT_CONFIG_DIR" "bat configuration"

log_info "Rebuilding bat cache"
bat cache --build
