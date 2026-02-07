#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing GCC 14"

log_info "Updating package lists"
sudo apt update

log_info "Installing GCC 14 and G++ 14"
sudo apt install -y gcc-14 g++-14

log_info "Setting GCC 14 as the default compiler"
# Set GCC 14 as the default compiler and also keep GCC 13 as an option
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 13 \
  --slave /usr/bin/g++ g++ /usr/bin/g++-13
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 14 \
  --slave /usr/bin/g++ g++ /usr/bin/g++-14
