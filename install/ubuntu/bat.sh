#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"
source "$PROJECT_ROOT/lib/link.sh"

print_section "Installing bat"

log_info "Updating package lists"
sudo apt-get update

log_info "Installing bat"
sudo apt-get install -y bat

link_directory "$PROJECT_ROOT/.config/bat" "$HOME/.config/bat" "bat configuration"

log_info "Rebuilding bat cache"
batcat cache --build
