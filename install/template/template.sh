#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing: [NAME]"

log_info "Installing [NAME] via [INSTALL_METHOD]..."
# [INSTALL_COMMAND]

log_info "Checking version: [NAME]"
# [VERSION_COMMAND]

log_success "[NAME] installation complete"
