#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing bat"

log_info "Updating package lists"
sudo apt-get update

log_info "Installing bat"
sudo apt-get install -y bat

# Gruvbox theme is built into bat, no need to download
log_info "Using built-in gruvbox-dark theme"
