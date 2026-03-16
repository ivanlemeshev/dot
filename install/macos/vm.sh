#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing tools for virtualized environment"

log_info "Installing the QEMU/KVM virtualization stack"
brew install qemu libvirt virt-manager

log_info "Starting the libvirt service and enabling it to start on boot"
brew services start libvirt
