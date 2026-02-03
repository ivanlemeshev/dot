#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing: ShellCheck"

log_info "Installing ShellCheck via apt..."
sudo apt-get update -q
sudo apt-get install -y -q shellcheck

log_info "Checking version: ShellCheck"
shellcheck --version

log_success "ShellCheck installation complete"
